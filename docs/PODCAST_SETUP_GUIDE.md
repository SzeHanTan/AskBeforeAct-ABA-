# Daily Podcast Feature - Quick Setup Guide

## 🎯 What's New?

Your AskBeforeAct app now has an AI-powered daily podcast feature that automatically summarizes community posts using Google's Gemini AI! 

## 📋 Prerequisites

✅ All dependencies already in `pubspec.yaml`:
- `google_generative_ai: ^0.4.7` (already installed)
- `provider: ^6.1.2` (already installed)
- `cloud_firestore: ^5.5.0` (already installed)

## 🚀 Quick Start

### Step 1: Verify Gemini API Key

Make sure your Gemini API key is configured in `lib/core/config/env_config.dart`:

```dart
class EnvConfig {
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  // ... other config
}
```

### Step 2: Set Up Firestore Indexes

Go to Firebase Console → Firestore Database → Indexes and create:

1. **Composite Index for podcasts collection**:
   - Collection: `podcasts`
   - Fields: 
     - `date` (Ascending)
     - `createdAt` (Descending)
   - Query scope: Collection

2. **Single Field Index** (usually auto-created):
   - Collection: `podcasts`
   - Field: `date`
   - Order: Ascending

### Step 3: Update Firestore Security Rules (Optional)

Add these rules to your `firestore.rules`:

```javascript
match /podcasts/{podcastId} {
  // Anyone authenticated can read podcasts
  allow read: if request.auth != null;
  
  // Anyone authenticated can create podcasts
  allow create: if request.auth != null;
  
  // Only admins can update/delete (optional)
  allow update, delete: if request.auth.token.admin == true;
}
```

### Step 4: Run the App

```bash
flutter pub get
flutter run -d chrome
```

## 🎨 How It Works

### User Experience

1. **User opens Community screen**
   - Podcast card appears at the top
   - Shows "Generating today's podcast summary..." if first time

2. **AI generates podcast**
   - Fetches all posts from today
   - Groups by scam type (phishing, romance, etc.)
   - Sends to Gemini AI for script generation
   - Stores in Firestore for future access

3. **User clicks "Listen to Summary"**
   - Dialog opens with full podcast script
   - Shows key insights and statistics
   - Future: Will play audio version

### Behind the Scenes

```
Community Screen
    ↓
CommunityProvider.loadTodaysPodcast()
    ↓
CommunityRepository.getTodaysPodcast()
    ↓
Check Firestore: Podcast exists for today?
    ↓ No
PodcastService.generateDailyPodcast()
    ↓
Fetch posts from Firestore (today's date range)
    ↓
Prepare summary (group by scam type)
    ↓
Call Gemini API with specialized prompt
    ↓
Parse JSON response (title, script, insights)
    ↓
Save to Firestore
    ↓
Return to UI
```

## 📁 New Files Created

```
lib/
├── models/
│   └── podcast_model.dart          # Podcast data model
├── services/
│   └── podcast_service.dart        # Gemini AI integration for podcasts
└── (Updated files)
    ├── services/firestore_service.dart
    ├── repositories/community_repository.dart
    ├── providers/community_provider.dart
    ├── views/community/community_screen.dart
    └── main.dart
```

## 🧪 Testing the Feature

### Test Scenario 1: First Time Load
1. Open Community screen
2. Should see "Generating today's podcast summary..."
3. Wait 5-10 seconds
4. Podcast card appears with title and stats
5. Click "Listen to Summary"
6. Dialog shows full script

### Test Scenario 2: Subsequent Loads
1. Refresh the page
2. Podcast loads instantly (cached in Firestore)
3. No regeneration needed

### Test Scenario 3: No Posts Today
1. Delete all posts for today (or test on a fresh database)
2. Open Community screen
3. Should see podcast with title "No Activity Today"
4. Script encourages users to stay vigilant

### Test Scenario 4: Error Handling
1. Temporarily break Gemini API key
2. Open Community screen
3. Should see error message in red card
4. Fix API key and refresh

## 🎯 Key Features

### ✨ What's Implemented

- ✅ **Automatic daily podcast generation**
- ✅ **Gemini AI-powered script writing**
- ✅ **Beautiful gradient podcast card UI**
- ✅ **Key insights extraction**
- ✅ **Post statistics (count, duration, date)**
- ✅ **Full script viewer dialog**
- ✅ **Empty state handling (no posts)**
- ✅ **Error handling and loading states**
- ✅ **Firestore caching (no duplicate generation)**

### 🚧 Future Enhancements (Not Yet Implemented)

- ⏳ **Text-to-Speech**: Convert script to audio
- ⏳ **Scheduled generation**: Cloud Function to auto-generate daily
- ⏳ **Podcast history**: Browse past episodes
- ⏳ **Sharing**: Share podcasts on social media
- ⏳ **Analytics**: Track listen counts

## 🔧 Customization

### Change Podcast Duration

Edit `lib/services/podcast_service.dart`:

```dart
GenerationConfig(
  temperature: 0.7,
  maxOutputTokens: 4096,  // Increase for longer podcasts
)
```

And update the prompt:
```dart
// Change from "250-350 words" to "500-700 words"
7. Is approximately 500-700 words
```

### Modify Podcast Style

Edit the prompt in `podcast_service.dart`:

```dart
final prompt = '''
You are a [CHANGE STYLE HERE] podcast host...
- More formal? "professional news anchor"
- More casual? "friendly neighbor sharing tips"
- More dramatic? "investigative journalist"
''';
```

### Change UI Colors

Edit `community_screen.dart`:

```dart
// Podcast card gradient
gradient: const LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],  // Change these
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),
```

## 🐛 Troubleshooting

### Issue: "Failed to generate podcast"

**Possible causes**:
1. Invalid Gemini API key
2. API quota exceeded
3. Network connectivity issues

**Solutions**:
- Verify API key in `env_config.dart`
- Check Firebase Console for errors
- Test Gemini API separately

### Issue: Podcast not appearing

**Possible causes**:
1. Provider not initialized
2. Firestore permissions
3. Date mismatch

**Solutions**:
- Check `main.dart` has `PodcastService` initialized
- Verify Firestore rules allow reads
- Check device date/time settings

### Issue: UI not updating

**Possible causes**:
1. Provider not notifying listeners
2. Widget not consuming provider

**Solutions**:
- Verify `Consumer<CommunityProvider>` wraps podcast card
- Check `notifyListeners()` is called after state changes
- Try hot restart (not just hot reload)

## 📊 Monitoring

### Check Gemini API Usage

1. Go to [Google AI Studio](https://aistudio.google.com/)
2. View your API key usage
3. Monitor quota and costs

### Check Firestore Usage

1. Firebase Console → Firestore Database
2. Usage tab
3. Monitor reads/writes/storage

### Estimated Costs

- **Gemini API**: ~$0.001 per podcast (1 per day)
- **Firestore**: ~100 reads/day, ~1 write/day
- **Total**: <$1/month for 1000 active users

## 🎓 Learning Resources

### Understanding the Code

1. **Start with**: `podcast_model.dart` (data structure)
2. **Then read**: `podcast_service.dart` (AI generation)
3. **Then explore**: `community_repository.dart` (business logic)
4. **Finally**: `community_screen.dart` (UI)

### Key Concepts

- **Provider Pattern**: State management
- **Repository Pattern**: Data abstraction
- **Service Layer**: External API integration
- **Gemini Prompting**: AI instruction engineering

## 📞 Support

If you encounter issues:

1. Check the detailed implementation doc: `PODCAST_FEATURE_IMPLEMENTATION.md`
2. Review error logs in console
3. Test with sample data
4. Verify all dependencies are installed

## 🎉 Success Checklist

- [ ] Gemini API key configured
- [ ] Firestore indexes created
- [ ] Security rules updated
- [ ] App runs without errors
- [ ] Podcast card appears on Community screen
- [ ] "Listen to Summary" button works
- [ ] Dialog shows full script
- [ ] Key insights display correctly
- [ ] Empty state works (no posts)
- [ ] Error handling works (invalid API key)

---

**Ready to test?** Open the Community screen and watch the magic happen! 🎙️✨
