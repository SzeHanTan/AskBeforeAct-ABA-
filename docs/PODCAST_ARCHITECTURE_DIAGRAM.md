# Daily Podcast Feature - Architecture Diagram

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                          │
│                     (community_screen.dart)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Daily Podcast Card (UI)                     │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  🎙️ Daily Podcast                                  │  │  │
│  │  │  "Phishing Attacks Surge: Protect Your Banking"   │  │  │
│  │  │  📊 15 posts  ⏱️ 2 minutes  📅 2/15               │  │  │
│  │  │  [Listen to Summary] ▶️                           │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Podcast Dialog (Full Script)                │  │
│  │  • Title & Stats                                         │  │
│  │  • Key Insights (bullet points)                          │  │
│  │  • Full Podcast Script (scrollable)                      │  │
│  │  • [Play Audio] [Close]                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕️
┌─────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT                           │
│                   (community_provider.dart)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  State Variables:                                               │
│  • PodcastModel? _todaysPodcast                                │
│  • List<PodcastModel> _recentPodcasts                          │
│  • bool _isPodcastLoading                                      │
│  • bool _isGeneratingPodcast                                   │
│  • String? _podcastError                                       │
│                                                                 │
│  Methods:                                                       │
│  • loadTodaysPodcast() ────────────────────┐                  │
│  • generateDailyPodcast()                  │                  │
│  • loadRecentPodcasts()                    │                  │
│  • getPodcastByDate()                      │                  │
│                                            │                  │
└────────────────────────────────────────────┼──────────────────┘
                                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC                             │
│                  (community_repository.dart)                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Methods:                                                       │
│  • getTodaysPodcast() ──────────────────┐                      │
│    ├─ Check if exists in Firestore     │                      │
│    └─ If not, generate new             │                      │
│                                         │                      │
│  • generateDailyPodcast() ──────────────┼──┐                  │
│    ├─ Get posts by date range          │  │                  │
│    ├─ Call PodcastService              │  │                  │
│    └─ Save to Firestore                │  │                  │
│                                         │  │                  │
│  • getRecentPodcasts()                  │  │                  │
│  • getPodcastByDate()                   │  │                  │
│                                         │  │                  │
└─────────────────────────────────────────┼──┼──────────────────┘
                                          ↓  ↓
                    ┌─────────────────────┴──┴─────────────────┐
                    │                                           │
                    ↓                                           ↓
    ┌───────────────────────────────┐         ┌───────────────────────────────┐
    │      DATA LAYER               │         │      AI SERVICE               │
    │  (firestore_service.dart)     │         │  (podcast_service.dart)       │
    ├───────────────────────────────┤         ├───────────────────────────────┤
    │                               │         │                               │
    │  Podcast Operations:          │         │  AI Generation:               │
    │  • createPodcast()            │         │  • generateDailyPodcast()     │
    │  • getPodcastById()           │         │    ├─ Prepare posts summary  │
    │  • getPodcastByDate() ────────┼─────────┤    ├─ Call Gemini API        │
    │  • getRecentPodcasts()        │         │    ├─ Parse JSON response    │
    │  • getPodcastsStream()        │         │    └─ Validate output        │
    │  • updatePodcast()            │         │                               │
    │  • deletePodcast()            │         │  • _createEmptyPodcast()      │
    │                               │         │    (for days with no posts)   │
    │  Post Operations:             │         │                               │
    │  • getCommunityPostsByDateRange()      │                               │
    │                               │         │                               │
    └───────────────┬───────────────┘         └───────────────┬───────────────┘
                    │                                         │
                    ↓                                         ↓
    ┌───────────────────────────────┐         ┌───────────────────────────────┐
    │      FIRESTORE DATABASE       │         │      GEMINI AI API            │
    │      (Cloud Firestore)        │         │  (Google Generative AI)       │
    ├───────────────────────────────┤         ├───────────────────────────────┤
    │                               │         │                               │
    │  Collection: podcasts/        │         │  Model: gemini-2.5-flash      │
    │  ├─ {podcastId}/              │         │  Temperature: 0.7             │
    │     ├─ date: Timestamp        │         │  Max Tokens: 4096             │
    │     ├─ title: String          │         │                               │
    │     ├─ script: String         │         │  Input: Posts summary         │
    │     ├─ postCount: Number      │         │  Output: JSON                 │
    │     ├─ topScamTypes: Array    │         │  {                            │
    │     ├─ keyInsights: Array     │         │    title: "...",              │
    │     ├─ duration: String       │         │    script: "...",             │
    │     ├─ createdAt: Timestamp   │         │    topScamTypes: [...],       │
    │     └─ isGenerated: Boolean   │         │    keyInsights: [...],        │
    │                               │         │    duration: "..."            │
    │  Collection: communityPosts/  │         │  }                            │
    │  ├─ {postId}/                 │         │                               │
    │     ├─ userId: String         │         │                               │
    │     ├─ content: String        │         │                               │
    │     ├─ scamType: String       │         │                               │
    │     ├─ createdAt: Timestamp   │         │                               │
    │     └─ ...                    │         │                               │
    │                               │         │                               │
    └───────────────────────────────┘         └───────────────────────────────┘
```

## 📊 Data Flow Diagram

### Flow 1: Initial Load (First Time)

```
User Opens Community Screen
         │
         ↓
    initState()
         │
         ↓
loadTodaysPodcast()
         │
         ↓
getTodaysPodcast()
         │
         ↓
Check Firestore: getPodcastByDate(today)
         │
         ├─ Found? ──→ Return cached podcast ──→ Display UI ✅
         │
         └─ Not Found?
                │
                ↓
         generateDailyPodcast()
                │
                ↓
    getCommunityPostsByDateRange(today)
                │
                ↓
         [15 posts found]
                │
                ↓
    PodcastService.generateDailyPodcast()
                │
                ↓
         Prepare summary:
         • Group by scam type
         • Select top posts
         • Format for AI
                │
                ↓
         Call Gemini API:
         • Send prompt + posts
         • Wait for response
         • Parse JSON
                │
                ↓
         Validate response:
         • Check required fields
         • Validate data types
         • Fill defaults if needed
                │
                ↓
         Create PodcastModel
                │
                ↓
         Save to Firestore
                │
                ↓
         Return podcast
                │
                ↓
         Update UI state
                │
                ↓
         Display podcast card ✅
```

### Flow 2: Subsequent Loads (Cached)

```
User Opens Community Screen
         │
         ↓
    initState()
         │
         ↓
loadTodaysPodcast()
         │
         ↓
getTodaysPodcast()
         │
         ↓
Check Firestore: getPodcastByDate(today)
         │
         └─ Found! ──→ Return cached podcast ──→ Display UI ✅
                       (No AI call needed)
```

### Flow 3: User Clicks "Listen to Summary"

```
User Clicks Button
         │
         ↓
_showPodcastDialog(podcast)
         │
         ↓
    Show Dialog:
    ├─ Title & Stats
    ├─ Key Insights
    ├─ Full Script
    └─ Action Buttons
         │
         ↓
    User Reads Script
         │
         ↓
    [Future: Play Audio]
         │
         ↓
    User Closes Dialog
```

## 🔄 State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    CommunityProvider                        │
│                   (ChangeNotifier)                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  State Changes:                                             │
│                                                             │
│  1. Loading State                                           │
│     _isPodcastLoading = true                                │
│     notifyListeners() ──→ UI shows loading indicator        │
│                                                             │
│  2. Success State                                           │
│     _todaysPodcast = podcast                                │
│     _isPodcastLoading = false                               │
│     notifyListeners() ──→ UI shows podcast card             │
│                                                             │
│  3. Error State                                             │
│     _podcastError = "error message"                         │
│     _isPodcastLoading = false                               │
│     notifyListeners() ──→ UI shows error card               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    UI Components                            │
│              (Consumer<CommunityProvider>)                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  if (provider.isPodcastLoading)                             │
│    → Show CircularProgressIndicator                         │
│                                                             │
│  else if (provider.todaysPodcast != null)                   │
│    → Show Podcast Card                                      │
│                                                             │
│  else if (provider.podcastError != null)                    │
│    → Show Error Card                                        │
│                                                             │
│  else                                                       │
│    → Show Nothing                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🎨 UI Component Hierarchy

```
CommunityScreen (StatefulWidget)
│
├─ AppBar
│  ├─ Title: "Community"
│  └─ Actions: [Add Post Button]
│
└─ Body (Column)
   │
   ├─ Daily Podcast Section (Consumer<CommunityProvider>)
   │  │
   │  ├─ Loading State → _buildPodcastLoadingCard()
   │  │  └─ Container
   │  │     ├─ CircularProgressIndicator
   │  │     └─ Text: "Generating..."
   │  │
   │  ├─ Success State → _buildPodcastCard(podcast)
   │  │  └─ Container (Gradient Background)
   │  │     ├─ Row (Header)
   │  │     │  ├─ Icon (Podcast)
   │  │     │  └─ Column (Title & Subtitle)
   │  │     ├─ Row (Stats)
   │  │     │  ├─ _buildPodcastStat(posts)
   │  │     │  ├─ _buildPodcastStat(duration)
   │  │     │  └─ _buildPodcastStat(date)
   │  │     └─ ElevatedButton: "Listen to Summary"
   │  │        └─ onPressed → _showPodcastDialog()
   │  │
   │  └─ Error State → _buildPodcastErrorCard(error)
   │     └─ Container (Red Background)
   │        ├─ Icon (Error)
   │        └─ Text (Error Message)
   │
   ├─ Filter Chips (Horizontal Scroll)
   │  ├─ All
   │  ├─ Phishing
   │  ├─ Romance
   │  └─ ...
   │
   └─ Posts List (Expanded ListView)
      ├─ Post Card 1
      ├─ Post Card 2
      └─ ...

Podcast Dialog (_showPodcastDialog)
│
└─ Dialog
   └─ Container
      ├─ Header Row
      │  ├─ Icon (Podcast)
      │  ├─ Title & Subtitle
      │  └─ Close Button
      │
      ├─ Stats Container
      │  ├─ _buildDialogStat(Posts)
      │  ├─ _buildDialogStat(Duration)
      │  └─ _buildDialogStat(Date)
      │
      ├─ Key Insights Section
      │  ├─ Title: "Key Insights"
      │  └─ List of insights
      │     ├─ ✓ Insight 1
      │     ├─ ✓ Insight 2
      │     └─ ✓ Insight 3
      │
      ├─ Script Section (Scrollable)
      │  ├─ Title: "Podcast Script"
      │  └─ Container (Full Script Text)
      │
      └─ Action Buttons Row
         ├─ OutlinedButton: "Play Audio"
         └─ ElevatedButton: "Close"
```

## 🔐 Security & Permissions Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    User Authentication                      │
│                   (Firebase Auth)                           │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                  Firestore Security Rules                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  match /podcasts/{podcastId} {                              │
│    // Anyone authenticated can read                         │
│    allow read: if request.auth != null;                     │
│                                                             │
│    // Anyone authenticated can create                       │
│    allow create: if request.auth != null;                   │
│                                                             │
│    // Only admins can update/delete                         │
│    allow update, delete:                                    │
│      if request.auth.token.admin == true;                   │
│  }                                                          │
│                                                             │
│  match /communityPosts/{postId} {                           │
│    // Read/write rules for posts                            │
│    allow read: if request.auth != null;                     │
│    allow create: if request.auth != null;                   │
│    allow update: if request.auth.uid == resource.data.userId;│
│    allow delete: if request.auth.uid == resource.data.userId;│
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                    API Key Security                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Gemini API Key:                                            │
│  • Stored in env_config.dart (not in version control)       │
│  • Never exposed to client                                  │
│  • Rate limiting on API side                                │
│  • Usage monitoring enabled                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 💾 Data Model Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                      PodcastModel                           │
├─────────────────────────────────────────────────────────────┤
│  id: String                                                 │
│  date: DateTime ───────────┐                                │
│  title: String             │                                │
│  script: String            │                                │
│  postCount: int ───────────┼─────┐                          │
│  topScamTypes: List<String>│     │                          │
│  keyInsights: List<String> │     │                          │
│  duration: String          │     │                          │
│  createdAt: DateTime       │     │                          │
│  isGenerated: bool         │     │                          │
└────────────────────────────┼─────┼──────────────────────────┘
                             │     │
                             │     │ Relationship:
                             │     │ One podcast summarizes
                             │     │ many posts from one day
                             │     │
                             ↓     ↓
┌─────────────────────────────────────────────────────────────┐
│                  CommunityPostModel                         │
├─────────────────────────────────────────────────────────────┤
│  id: String                                                 │
│  userId: String                                             │
│  userName: String                                           │
│  isAnonymous: bool                                          │
│  scamType: String ← Used for grouping in podcast            │
│  content: String ← Summarized in podcast                    │
│  upvotes: int ← Used to rank posts                          │
│  downvotes: int                                             │
│  netVotes: int ← Top posts included in podcast              │
│  voters: Map<String, String>                                │
│  reported: bool                                             │
│  reportCount: int                                           │
│  createdAt: DateTime ← Filtered by date for podcast         │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Web App                          │
│                  (askbeforeact.web.app)                     │
├─────────────────────────────────────────────────────────────┤
│  • Community Screen                                         │
│  • Podcast UI Components                                    │
│  • State Management (Provider)                              │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                  Firebase Services                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Cloud Firestore                                    │   │
│  │  • podcasts collection                              │   │
│  │  • communityPosts collection                        │   │
│  │  • Real-time sync                                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Firebase Authentication                            │   │
│  │  • User auth state                                  │   │
│  │  • Security rules enforcement                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Firebase Hosting                                   │   │
│  │  • Static file serving                              │   │
│  │  • CDN distribution                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                  Google AI Services                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Gemini API (generativelanguage.googleapis.com)    │   │
│  │  • Model: gemini-2.5-flash                          │   │
│  │  • Podcast script generation                        │   │
│  │  • JSON response parsing                            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Legend

- **→** : Data flow direction
- **↓** : Sequential flow
- **├─** : Branch/Option
- **└─** : End of branch
- **✅** : Success/Complete state

---

*This diagram provides a comprehensive visual overview of the podcast feature architecture, data flow, and component relationships.*
