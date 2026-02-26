# Learn Section Integration - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

Follow these steps to get the Learn section with Firebase integration up and running.

## Prerequisites

- Firebase project already set up
- Firebase CLI installed: `npm install -g firebase-tools`
- Logged in to Firebase: `firebase login`

## Step-by-Step Setup

### 1. Install Function Dependencies (2 minutes)

```bash
cd functions
npm install
```

This installs:
- firebase-admin
- firebase-functions  
- axios
- rss-parser

### 2. Deploy Cloud Functions (2 minutes)

```bash
# Make sure you're in the project root
cd ..

# Deploy all functions
firebase deploy --only functions
```

Wait for deployment to complete. You'll see output like:
```
✔  functions: Finished running predeploy script.
✔  functions[fetchScamNews(us-central1)] Successful create operation.
✔  functions[fetchScamNewsManual(us-central1)] Successful create operation.
✔  functions[initializeEducationContent(us-central1)] Successful create operation.
```

### 3. Initialize Education Content (30 seconds)

Get your function URL from the deployment output or Firebase Console, then:

```bash
# Replace YOUR_REGION and YOUR_PROJECT_ID with actual values
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/initializeEducationContent
```

Example:
```bash
curl https://us-central1-askbeforeact-f5326.cloudfunctions.net/initializeEducationContent
```

Expected response:
```json
{
  "success": true,
  "message": "Successfully initialized 5 education content items"
}
```

### 4. Fetch Initial News (30 seconds)

```bash
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/fetchScamNewsManual
```

Expected response:
```json
{
  "success": true,
  "message": "Successfully processed 20 news items",
  "total": 20,
  "new": 20,
  "updated": 0
}
```

### 5. Update Firestore Rules (1 minute)

Add these rules to your `firestore.rules` file:

```javascript
// Add these to your existing rules
match /education_content/{contentId} {
  allow read: if true;
  allow write: if false;
}

match /scam_news/{newsId} {
  allow read: if true;
  allow write: if false;
}
```

Deploy the rules:
```bash
firebase deploy --only firestore:rules
```

### 6. Run Flutter App (1 minute)

```bash
cd askbeforeact
flutter pub get
flutter run -d chrome
```

## ✅ Verification

### Check Firestore Collections

1. Open Firebase Console → Firestore Database
2. Verify these collections exist:
   - `education_content` (5 documents)
   - `scam_news` (20+ documents)

### Test the App

1. Navigate to the Learn section
2. You should see two tabs:
   - **Common Scams**: 5 scam types with icons
   - **Latest News**: News articles from Google News
3. Try:
   - Tapping a scam card → Opens detailed modal
   - Tapping a news card → Opens article in browser
   - Pull down to refresh

## 🎯 What You Get

### Common Scams Tab
- 🎣 Phishing Emails
- 💔 Romance Scams
- 💳 Payment Fraud
- 💼 Job Scams
- 🔧 Tech Support Scams

Each with:
- Warning signs
- Prevention tips
- Real-world examples

### Latest News Tab
- Real-time scam news from Google News
- Targeting Malaysia/Chinese context
- Auto-updates every 6 hours
- Pull-to-refresh support

## 📱 Features

- ✅ Tabbed interface
- ✅ Pull-to-refresh on both tabs
- ✅ Detailed modal for scam information
- ✅ External link opening for news
- ✅ Loading states
- ✅ Error handling
- ✅ Offline fallback data
- ✅ Responsive design

## 🔄 Automatic Updates

The `fetchScamNews` function runs automatically every 6 hours:
- 12:00 AM (midnight)
- 6:00 AM
- 12:00 PM (noon)
- 6:00 PM

Timezone: Asia/Kuala_Lumpur (GMT+8)

## 🐛 Troubleshooting

### No news appearing?
```bash
# Manually trigger news fetch
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/fetchScamNewsManual
```

### Education content not loading?
```bash
# Re-run initialization
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/initializeEducationContent
```

### Check function logs
```bash
firebase functions:log --only fetchScamNews
```

### App errors?
```bash
cd askbeforeact
flutter clean
flutter pub get
flutter run -d chrome
```

## 📊 Monitor Usage

### Firebase Console
1. Go to Firebase Console → Functions
2. View execution history and logs
3. Monitor performance metrics

### Firestore Usage
1. Go to Firebase Console → Firestore Database → Usage
2. Check reads/writes/storage

## 💰 Cost

Expected cost: **$0/month** (within free tier)

- Scheduled function: 120 invocations/month
- Free tier: 2 million invocations/month
- Firestore writes: ~2,500/month
- Free tier: 600,000 writes/month

## 📚 Documentation

For detailed information, see:
- `LEARN_SECTION_INTEGRATION.md` - Complete architecture and details
- `functions/README.md` - Cloud Functions documentation

## 🎉 Done!

Your Learn section is now fully integrated with Firebase and will automatically fetch the latest scam news every 6 hours!

## Next Steps

Optional enhancements:
1. Add push notifications for critical scam alerts
2. Implement search functionality for news
3. Add bookmarking feature
4. Create admin dashboard for content management
5. Add more news sources

## Need Help?

1. Check Firebase Console logs
2. Review Flutter console output
3. Verify Firestore rules are correct
4. Test with manual function triggers
5. Check `LEARN_SECTION_INTEGRATION.md` for detailed troubleshooting
