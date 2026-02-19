const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
const Parser = require('rss-parser');

admin.initializeApp();
const db = admin.firestore();
const parser = new Parser({
  customFields: {
    item: ['source']
  }
});

/**
 * Scheduled function to fetch scam news from Google News RSS
 * Runs every 6 hours
 */
exports.fetchScamNews = functions.pubsub
  .schedule('every 6 hours')
  .timeZone('Asia/Kuala_Lumpur')
  .onRun(async (context) => {
    try {
      console.log('Starting scam news fetch...');
      
      // RSS URL targeting Malaysia/Chinese context
      const rssUrl = 'https://news.google.com/rss/search?q=Scam+OR+Fraud+OR+诈骗&hl=zh-CN&gl=MY&ceid=MY:zh-CN';
      
      // Fetch RSS feed
      const response = await axios.get(rssUrl, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; AskBeforeAct/1.0)'
        }
      });
      
      // Parse RSS XML to JSON
      const feed = await parser.parseString(response.data);
      
      console.log(`Found ${feed.items.length} news items`);
      
      // Process each news item
      const batch = db.batch();
      let newCount = 0;
      let updatedCount = 0;
      
      for (const item of feed.items) {
        // Use URL as document ID to prevent duplicates
        const docId = Buffer.from(item.link).toString('base64')
          .replace(/[/+=]/g, '_')
          .substring(0, 100); // Firestore doc ID limit
        
        const newsRef = db.collection('scam_news').doc(docId);
        
        // Check if document exists
        const docSnapshot = await newsRef.get();
        
        const newsData = {
          title: item.title || '',
          link: item.link || '',
          pubDate: item.pubDate ? new Date(item.pubDate) : new Date(),
          contentSnippet: item.contentSnippet || item.content || '',
          source: item.source?._ || item.source || 'Google News',
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        
        if (!docSnapshot.exists) {
          // New document
          newsData.createdAt = admin.firestore.FieldValue.serverTimestamp();
          batch.set(newsRef, newsData);
          newCount++;
        } else {
          // Update existing document
          batch.update(newsRef, newsData);
          updatedCount++;
        }
      }
      
      // Commit batch write
      await batch.commit();
      
      console.log(`Successfully processed ${feed.items.length} news items: ${newCount} new, ${updatedCount} updated`);
      
      return {
        success: true,
        total: feed.items.length,
        new: newCount,
        updated: updatedCount
      };
      
    } catch (error) {
      console.error('Error fetching scam news:', error);
      throw error;
    }
  });

/**
 * HTTP function to manually trigger news fetch (for testing)
 */
exports.fetchScamNewsManual = functions.https.onRequest(async (req, res) => {
  try {
    console.log('Manual scam news fetch triggered...');
    
    const rssUrl = 'https://news.google.com/rss/search?q=Scam+OR+Fraud+OR+诈骗&hl=zh-CN&gl=MY&ceid=MY:zh-CN';
    
    const response = await axios.get(rssUrl, {
      timeout: 10000,
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; AskBeforeAct/1.0)'
      }
    });
    
    const feed = await parser.parseString(response.data);
    
    const batch = db.batch();
    let newCount = 0;
    let updatedCount = 0;
    
    for (const item of feed.items) {
      const docId = Buffer.from(item.link).toString('base64')
        .replace(/[/+=]/g, '_')
        .substring(0, 100);
      
      const newsRef = db.collection('scam_news').doc(docId);
      const docSnapshot = await newsRef.get();
      
      const newsData = {
        title: item.title || '',
        link: item.link || '',
        pubDate: item.pubDate ? new Date(item.pubDate) : new Date(),
        contentSnippet: item.contentSnippet || item.content || '',
        source: item.source?._ || item.source || 'Google News',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      if (!docSnapshot.exists) {
        newsData.createdAt = admin.firestore.FieldValue.serverTimestamp();
        batch.set(newsRef, newsData);
        newCount++;
      } else {
        batch.update(newsRef, newsData);
        updatedCount++;
      }
    }
    
    await batch.commit();
    
    res.json({
      success: true,
      message: `Successfully processed ${feed.items.length} news items`,
      total: feed.items.length,
      new: newCount,
      updated: updatedCount
    });
    
  } catch (error) {
    console.error('Error in manual fetch:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Initialize education content in Firestore
 * This function can be called once to populate the education_content collection
 */
exports.initializeEducationContent = functions.https.onRequest(async (req, res) => {
  try {
    const educationContent = [
      {
        id: 'phishing',
        title: 'Phishing Emails',
        description: 'Fake emails pretending to be from legitimate companies',
        // Note: Icon is stored as emoji text, not in Firebase
        warningSigns: [
          'Urgent requests for personal information',
          'Suspicious sender email addresses',
          'Poor grammar and spelling mistakes',
          'Requests to click suspicious links',
          'Threats of account closure'
        ],
        preventionTips: [
          'Verify sender email addresses carefully',
          'Never click suspicious links',
          'Contact companies directly through official channels',
          'Enable two-factor authentication',
          'Use email filters and spam detection'
        ],
        example: 'An email claiming to be from your bank asking you to "verify your account" by clicking a link and entering your password.',
        order: 1
      },
      {
        id: 'romance',
        title: 'Romance Scams',
        description: 'Fake online relationships designed to steal money',
        warningSigns: [
          'Quick declarations of love',
          'Reluctance to meet in person or video call',
          'Requests for money or financial help',
          'Stories of emergencies or crises',
          'Inconsistent personal details'
        ],
        preventionTips: [
          'Be cautious with online relationships',
          'Never send money to someone you haven\'t met',
          'Do reverse image searches on profile photos',
          'Take relationships slowly',
          'Trust your instincts if something feels wrong'
        ],
        example: 'Someone you met online professes love quickly, then asks for money to help with a medical emergency or travel costs to visit you.',
        order: 2
      },
      {
        id: 'payment',
        title: 'Payment Fraud',
        description: 'Unauthorized charges and fake payment requests',
        warningSigns: [
          'Unexpected payment requests',
          'Unfamiliar charges on statements',
          'Requests for unusual payment methods',
          'Pressure to pay immediately',
          'Requests to pay via gift cards or cryptocurrency'
        ],
        preventionTips: [
          'Monitor your accounts regularly',
          'Use secure payment methods',
          'Verify payment requests independently',
          'Set up transaction alerts',
          'Never pay with gift cards for legitimate services'
        ],
        example: 'Receiving a call claiming you owe taxes and must pay immediately with gift cards or face arrest.',
        order: 3
      },
      {
        id: 'job',
        title: 'Job Scams',
        description: 'Fake job offers and work-from-home schemes',
        warningSigns: [
          'Jobs requiring upfront payment',
          'Unrealistic salary promises',
          'Vague job descriptions',
          'Requests for personal financial information early',
          'Pressure to start immediately without proper interview'
        ],
        preventionTips: [
          'Research companies thoroughly',
          'Never pay for job opportunities',
          'Be wary of too-good-to-be-true offers',
          'Verify job postings on official company websites',
          'Use reputable job platforms'
        ],
        example: 'A "work from home" opportunity promising $5000/week but requiring you to pay for training materials or equipment upfront.',
        order: 4
      },
      {
        id: 'tech_support',
        title: 'Tech Support Scams',
        description: 'Fake technical support claiming to fix your device',
        warningSigns: [
          'Unsolicited calls about computer problems',
          'Pop-ups claiming your device is infected',
          'Requests for remote access to your device',
          'Pressure to pay for unnecessary services',
          'Claims to be from Microsoft, Apple, or other tech companies'
        ],
        preventionTips: [
          'Legitimate companies don\'t call unsolicited',
          'Never give remote access to strangers',
          'Use official support channels only',
          'Install reputable antivirus software',
          'Hang up on suspicious tech support calls'
        ],
        example: 'A pop-up warning that your computer is infected, with a phone number to call for "immediate support" that charges hundreds of dollars.',
        order: 5
      }
    ];

    const batch = db.batch();
    
    for (const content of educationContent) {
      const docRef = db.collection('education_content').doc(content.id);
      batch.set(docRef, content);
    }
    
    await batch.commit();
    
    res.json({
      success: true,
      message: `Successfully initialized ${educationContent.length} education content items`
    });
    
  } catch (error) {
    console.error('Error initializing education content:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});
