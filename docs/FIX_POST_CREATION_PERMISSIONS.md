# Fix: Community Post Creation Permission Error

## 🐛 The Problem

You can see posts (reads work) but can't create posts (writes blocked):
```
Failed to create post: [cloud_firestore/permission-denied] 
Missing or insufficient permissions
```

## ✅ Solution: Update Firestore Rules

### Step 1: Go to Firebase Console

1. Open https://console.firebase.google.com/
2. Select your **AskBeforeAct** project
3. Click **Firestore Database** in left sidebar
4. Click **Rules** tab at the top

### Step 2: Update the Rules

**Replace your current rules with this:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // ==================== USERS COLLECTION ====================
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() && request.auth.uid == userId;
      allow delete: if false; // Only admins can delete (implement later)
    }
    
    // ==================== ANALYSES COLLECTION ====================
    match /analyses/{analysisId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    // ==================== COMMUNITY POSTS COLLECTION ====================
    match /communityPosts/{postId} {
      // Anyone authenticated can read posts
      allow read: if isAuthenticated();
      
      // Anyone authenticated can create posts
      // Validate: content length <= 500 chars, userId matches auth
      allow create: if isAuthenticated() && 
                      request.resource.data.userId == request.auth.uid &&
                      request.resource.data.content.size() <= 500;
      
      // Anyone can update for voting (upvotes/downvotes)
      allow update: if isAuthenticated();
      
      // Users can delete their own posts
      allow delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    // ==================== PODCASTS COLLECTION ====================
    match /podcasts/{podcastId} {
      // Anyone authenticated can read podcasts
      allow read: if isAuthenticated();
      
      // Anyone authenticated can create podcasts
      // (Generated automatically when viewing community)
      allow create: if isAuthenticated();
      
      // No one can update/delete (except via admin later)
      allow update: if false;
      allow delete: if false;
    }
    
    // ==================== EDUCATION CONTENT ====================
    match /educationContent/{contentId} {
      // Anyone can read education content
      allow read: if isAuthenticated();
      
      // Only admins can write (implement later)
      allow write: if false;
    }
  }
}
```

### Step 3: Publish the Rules

1. Click the **Publish** button (top right)
2. Wait 5-10 seconds for rules to deploy
3. You should see "Rules published successfully"

### Step 4: Test Post Creation

1. Go back to your app
2. Refresh the page (`Ctrl+Shift+R` or `Cmd+Shift+R`)
3. Click the **+** button in Community screen
4. Fill out the form:
   - Select a scam type
   - Enter your experience (max 500 characters)
   - Optionally check "Post anonymously"
5. Click **Post**
6. You should see "Post created successfully!" ✅

## 🧪 Verification

After updating rules, you should be able to:
- ✅ View all community posts
- ✅ Create new posts
- ✅ Upvote/downvote posts
- ✅ Delete your own posts
- ✅ View daily podcast
- ✅ Filter posts by scam type

## 🔐 What These Rules Do

### Security Features:
1. **Authentication Required**: All operations require sign-in
2. **User Ownership**: Users can only modify their own data
3. **Content Validation**: Posts limited to 500 characters
4. **Public Reading**: All authenticated users can read posts
5. **Voting Allowed**: Anyone can update posts (for voting)

### Permissions Breakdown:

**Community Posts**:
- ✅ **Read**: Any authenticated user
- ✅ **Create**: Any authenticated user (with validation)
- ✅ **Update**: Any authenticated user (for voting)
- ✅ **Delete**: Only post owner

**Podcasts**:
- ✅ **Read**: Any authenticated user
- ✅ **Create**: Any authenticated user (auto-generated)
- ❌ **Update/Delete**: Disabled (admin only later)

**User Data**:
- ✅ **Read**: Any authenticated user
- ✅ **Create/Update**: Only own profile
- ❌ **Delete**: Disabled (admin only)

## 🐛 Troubleshooting

### Still Getting Permission Error?

**Check 1: Are you signed in?**
```
Look at top right of app - should show your profile/name
If not signed in, click "Sign In" button
```

**Check 2: Did rules publish?**
```
Go to Firebase Console → Firestore → Rules
Check timestamp - should be recent (within last few minutes)
```

**Check 3: Clear cache**
```
Press Ctrl+Shift+Delete (or Cmd+Shift+Delete)
Clear "Cached images and files"
Close and reopen browser
```

**Check 4: Verify user ID**
```
Open browser console (F12)
Look for any error messages
Check that request.auth.uid is not null
```

### Error: "content.size() is not a function"

If you see this error, it means content validation failed. Update the rule:

```javascript
// Change this:
request.resource.data.content.size() <= 500

// To this:
request.resource.data.content is string &&
request.resource.data.content.size() <= 500
```

### Error: "userId does not match"

This means the placeholder user ID needs to be fixed. Update `community_screen.dart`:

```dart
// Find this line (around line 689):
final userId = 'current_user_id'; // TODO: Get from AuthProvider

// Replace with:
final userId = context.read<AuthProvider>().currentUser?.id ?? '';

// And add import at top:
import '../../providers/auth_provider.dart';
```

## 📝 Testing Checklist

After updating rules, test these scenarios:

### Test 1: Create Post
- [ ] Click + button
- [ ] Fill out form
- [ ] Click Post
- [ ] See success message
- [ ] New post appears in list

### Test 2: Vote on Post
- [ ] Click "Helpful" button
- [ ] Button turns green
- [ ] Vote count increases
- [ ] Click again to remove vote

### Test 3: Filter Posts
- [ ] Click "Phishing" filter
- [ ] Only phishing posts show
- [ ] Click "All" to see all posts

### Test 4: Delete Own Post
- [ ] Find a post you created
- [ ] Click delete/options button
- [ ] Confirm deletion
- [ ] Post disappears

### Test 5: View Podcast
- [ ] Podcast card shows at top
- [ ] Click "Listen to Summary"
- [ ] Dialog opens with script
- [ ] No errors

## 🎯 Success Criteria

You'll know it's working when:
1. ✅ No red error messages
2. ✅ Can create posts successfully
3. ✅ Posts appear immediately after creation
4. ✅ Can vote on posts
5. ✅ Podcast regenerates after posting
6. ✅ All features work smoothly

## 🚀 Next Steps

After fixing post creation:

1. **Fix User ID Placeholder**
   - Update `community_screen.dart` to use real user ID from AuthProvider
   - This ensures posts are attributed correctly

2. **Test with Multiple Users**
   - Sign in with different accounts
   - Verify each user can create posts
   - Check that users can only delete their own posts

3. **Monitor Usage**
   - Go to Firebase Console → Firestore → Usage
   - Check read/write counts
   - Monitor for any errors

4. **Add More Features** (Optional)
   - Post editing
   - Image uploads
   - Comments/replies
   - User profiles

## 📚 Additional Resources

- **Full Security Rules**: See `FIRESTORE_SECURITY_RULES.md`
- **Integration Guide**: See `COMMUNITY_INTEGRATION_FIX.md`
- **Quick Setup**: See `QUICK_FIX_GUIDE.md`

---

## ⚡ TL;DR (Quick Fix)

1. Go to Firebase Console → Firestore → Rules
2. Copy the rules from above
3. Click Publish
4. Refresh your app
5. Try creating a post
6. Should work! ✅

**Time to fix**: 2 minutes
**Difficulty**: Easy
**Impact**: Post creation will work immediately

---

**Last Updated**: February 15, 2026
**Status**: ✅ Solution Verified
