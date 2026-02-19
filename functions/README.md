# Firebase Cloud Functions for AskBeforeAct

This directory contains Firebase Cloud Functions for the AskBeforeAct application.

## Functions

### 1. `fetchScamNews` (Scheduled Function)

Automatically fetches scam and fraud news from Google News RSS feed every 6 hours.

**Trigger**: Pub/Sub Scheduler (runs every 6 hours)
**Timezone**: Asia/Kuala_Lumpur

**What it does**:
- Fetches RSS feed from Google News targeting Malaysia/Chinese context
- Parses XML to JSON using rss-parser
- Stores news articles in Firestore `scam_news` collection
- Uses article URL as document ID to prevent duplicates
- Updates existing articles if they already exist

**Fields stored**:
- `title`: Article title
- `link`: URL to the article
- `pubDate`: Publication date
- `contentSnippet`: Article summary/snippet
- `source`: News source name
- `createdAt`: Timestamp when first added
- `updatedAt`: Timestamp of last update

### 2. `fetchScamNewsManual` (HTTP Function)

Manual trigger for fetching news (useful for testing and immediate updates).

**Trigger**: HTTP Request
**Method**: GET or POST

**Usage**:
```bash
# Using curl
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/fetchScamNewsManual

# Using Firebase CLI
firebase functions:shell
> fetchScamNewsManual()
```

**Response**:
```json
{
  "success": true,
  "message": "Successfully processed X news items",
  "total": 20,
  "new": 5,
  "updated": 15
}
```

### 3. `initializeEducationContent` (HTTP Function)

One-time function to populate the education content collection with scam types information.

**Trigger**: HTTP Request
**Method**: GET or POST

**Usage**:
```bash
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/initializeEducationContent
```

**What it does**:
- Creates 5 education content documents in `education_content` collection
- Each document contains information about a specific scam type:
  - Phishing Emails
  - Romance Scams
  - Payment Fraud
  - Job Scams
  - Tech Support Scams

**Fields stored**:
- `id`: Unique identifier
- `title`: Scam type name
- `description`: Brief description
- `warningSigns`: Array of warning signs
- `preventionTips`: Array of prevention tips
- `example`: Real-world example
- `order`: Display order

## Setup Instructions

### 1. Install Dependencies

```bash
cd functions
npm install
```

### 2. Deploy Functions

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:fetchScamNews
firebase deploy --only functions:fetchScamNewsManual
firebase deploy --only functions:initializeEducationContent
```

### 3. Initialize Education Content

After deploying, run the initialization function once:

```bash
# Get your function URL from Firebase Console
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/initializeEducationContent
```

### 4. Test News Fetching

Manually trigger the news fetch to test:

```bash
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/fetchScamNewsManual
```

## Local Development

### Run Functions Locally

```bash
# Start Firebase emulators
firebase emulators:start

# Or just functions emulator
npm run serve
```

### Test Scheduled Function Locally

```bash
firebase functions:shell
> fetchScamNews()
```

## Monitoring

### View Logs

```bash
# All functions
firebase functions:log

# Specific function
firebase functions:log --only fetchScamNews

# Follow logs in real-time
firebase functions:log --follow
```

### Firebase Console

Monitor function execution, errors, and performance in the Firebase Console:
- Go to Firebase Console → Functions
- View execution history, logs, and metrics

## RSS Feed Details

**URL**: `https://news.google.com/rss/search?q=Scam+OR+Fraud+OR+诈骗&hl=zh-CN&gl=MY&ceid=MY:zh-CN`

**Parameters**:
- `q`: Search query (Scam OR Fraud OR 诈骗)
- `hl`: Language (zh-CN for Chinese)
- `gl`: Region (MY for Malaysia)
- `ceid`: Country/Language combination

**Update Frequency**: Every 6 hours

## Firestore Collections

### `scam_news`

Stores news articles fetched from Google News.

**Document ID**: Base64-encoded URL (truncated to 100 chars)

**Schema**:
```javascript
{
  title: string,
  link: string,
  pubDate: timestamp,
  contentSnippet: string,
  source: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Indexes Required**:
- `pubDate` (descending) - for ordering by date

### `education_content`

Stores educational content about different scam types.

**Document ID**: Scam type identifier (e.g., 'phishing', 'romance')

**Schema**:
```javascript
{
  id: string,
  title: string,
  description: string,
  warningSigns: array<string>,
  preventionTips: array<string>,
  example: string,
  order: number
}
```

**Indexes Required**:
- `order` (ascending) - for ordered display

## Security Rules

Ensure your Firestore rules allow reading these collections:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Education content - public read
    match /education_content/{contentId} {
      allow read: if true;
      allow write: if false; // Only Cloud Functions can write
    }
    
    // Scam news - public read
    match /scam_news/{newsId} {
      allow read: if true;
      allow write: if false; // Only Cloud Functions can write
    }
  }
}
```

## Troubleshooting

### Function Not Running

1. Check Cloud Scheduler in Google Cloud Console
2. Verify function is deployed: `firebase functions:list`
3. Check logs: `firebase functions:log`

### No News Appearing

1. Manually trigger: `fetchScamNewsManual`
2. Check Firestore console for `scam_news` collection
3. Verify network access (Cloud Functions can reach external URLs)

### RSS Parsing Errors

1. Test RSS URL directly in browser
2. Check axios timeout (currently 10 seconds)
3. Verify rss-parser version compatibility

## Cost Considerations

**Scheduled Function**: Runs 4 times per day (every 6 hours)
- ~120 invocations per month
- Minimal cost (within free tier for most projects)

**HTTP Functions**: Only run when called
- Use sparingly to avoid unnecessary costs

**Firestore**: 
- Reads: Charged per document read by app
- Writes: ~80-100 writes per day from scheduled function
- Storage: Minimal (news articles are small)

## Dependencies

- `firebase-admin`: ^12.0.0 - Firebase Admin SDK
- `firebase-functions`: ^4.6.0 - Cloud Functions SDK
- `axios`: ^1.6.7 - HTTP client for fetching RSS
- `rss-parser`: ^3.13.0 - RSS/XML parser

## Environment Variables

No environment variables required. All configuration is in code.

## Future Enhancements

Potential improvements:
1. Add sentiment analysis to news articles
2. Categorize news by scam type
3. Send notifications for critical scam alerts
4. Add more news sources
5. Implement caching layer
6. Add rate limiting for manual triggers
7. Create admin dashboard for content management
