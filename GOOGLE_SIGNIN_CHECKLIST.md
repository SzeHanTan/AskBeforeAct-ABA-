# Google Sign-In Configuration Checklist ✅

## Your Setup
- **Client ID:** `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com`
- **Client Name:** AskBeforeAct Web Client
- **Already in index.html:** ✅ Done

---

## Step 1: Configure OAuth Client in Google Cloud Console

### Go to: https://console.cloud.google.com/apis/credentials

1. Click on **"AskBeforeAct Web Client"**

2. **Authorized JavaScript origins** - Add these:
   ```
   ☐ http://localhost
   ☐ http://localhost:8080
   ☐ https://askbeforeact-f5326.web.app
   ☐ https://askbeforeact-f5326.firebaseapp.com
   ```

3. **Authorized redirect URIs** - Add these:
   ```
   ☐ http://localhost/__/auth/handler
   ☐ http://localhost:8080/__/auth/handler
   ☐ https://askbeforeact-f5326.web.app/__/auth/handler
   ☐ https://askbeforeact-f5326.firebaseapp.com/__/auth/handler
   ```

4. Click **SAVE** ✅

---

## Step 2: Enable Google Sign-In in Firebase

### Go to: https://console.firebase.google.com/

1. Select project: **askbeforeact-f5326**

2. Go to: **Authentication** → **Sign-in method**

3. Click on **Google**

4. Configuration:
   ```
   ☐ Toggle "Enable" to ON
   ☐ Select your support email
   ☐ Leave "Web SDK configuration" EMPTY (don't fill anything)
   ```

5. Click **Save** ✅

---

## Step 3: Test

1. **Restart your app:**
   ```bash
   flutter run -d chrome
   ```

2. **Test Google Sign-In:**
   ```
   ☐ Click "Sign In"
   ☐ Click "Continue with Google"
   ☐ Select your Google account
   ☐ Should be signed in! 🎉
   ```

---

## If It Doesn't Work

### Check the error in browser console (F12):

**"redirect_uri_mismatch"**
- Add the exact URI from the error to your OAuth client

**"popup_closed_by_user"**
- Normal - user closed popup, try again

**"400 Bad Request"**
- Google not enabled in Firebase - go back to Step 2

**"idpiframe_initialization_failed"**
- Browser blocking cookies - allow cookies or try incognito

---

## Quick Debug

Add this to see what's happening:

Open browser console (F12) and check for errors when clicking "Continue with Google"

---

## That's It!

Once you complete Steps 1 and 2, Google Sign-In will work! ✅

**The key points:**
1. ✅ OAuth client has correct redirect URIs
2. ✅ Google is enabled in Firebase
3. ✅ index.html has correct client ID (already done)

**Total time: ~5 minutes** ⏱️
