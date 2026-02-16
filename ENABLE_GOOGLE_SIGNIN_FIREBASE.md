# Enable Google Sign-In in Firebase - Fix 400 Error

## The Problem
You're getting a 400 error when trying to sign in with Google:
```
POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=... 400 (Bad Request)
```

This means **Google Sign-In provider is not enabled in Firebase Authentication**.

---

## Solution: Enable Google Sign-In in Firebase Console

### Step 1: Go to Firebase Console

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **askbeforeact-f5326**
3. In the left sidebar, click **Authentication**
4. Click on the **Sign-in method** tab

### Step 2: Enable Google Provider

1. Look for **Google** in the list of providers
2. Click on **Google** (the row, not just the toggle)
3. You'll see a configuration panel

### Step 3: Configure Google Sign-In

**Toggle:** Turn **Enable** ON (should be blue/green)

**Project support email:** 
- Select your email from the dropdown
- This is required by Google

**Web SDK configuration (Optional but Recommended):**
- **Web client ID:** Paste your Web OAuth Client ID
  - Example: `1001926999690-xxxxxxxxxx.apps.googleusercontent.com`
- **Web client secret:** Paste the client secret from Google Cloud Console
  - You can find this in Google Cloud Console → Credentials → Your Web Client

**Public-facing name for project:** 
- Leave as default or customize: `AskBeforeAct`

### Step 4: Save Configuration

1. Click **Save** at the bottom
2. Wait for the confirmation message

### Step 5: Verify It's Enabled

Back on the Sign-in method page, you should see:
- ✅ **Google** - Status: **Enabled** (green checkmark)

---

## Step-by-Step with Screenshots Description

### What You Should See:

**Before Enabling:**
```
Sign-in method
├── Email/Password    [Enabled]
├── Google            [Disabled] ← Click here
├── Anonymous         [Disabled]
└── ...
```

**After Enabling:**
```
Sign-in method
├── Email/Password    [Enabled]
├── Google            [Enabled] ✅ ← Should be green
├── Anonymous         [Disabled]
└── ...
```

---

## Common Issues

### Issue 1: "Support email is required"
**Solution:** Select your email from the dropdown in the configuration panel

### Issue 2: "Web client ID is invalid"
**Solution:** 
1. Go to Google Cloud Console → Credentials
2. Copy the **Web application** client ID (not iOS/Android)
3. Paste it in Firebase Console

### Issue 3: Can't find Google in the list
**Solution:** Scroll down - it should be there. If not, your Firebase project might have issues.

### Issue 4: Save button is grayed out
**Solution:** Make sure you've:
- Toggled Enable ON
- Selected a support email
- Filled in required fields

---

## Alternative: Enable via Firebase CLI (Advanced)

If you prefer using the command line:

```bash
# Install Firebase CLI if not installed
npm install -g firebase-tools

# Login
firebase login

# List your projects
firebase projects:list

# Select your project
firebase use askbeforeact-f5326

# Note: You still need to enable it in the console
# The CLI doesn't have a direct command for this
```

---

## After Enabling: Test Google Sign-In

1. ✅ Make sure Google is **Enabled** in Firebase Console
2. ✅ Restart your Flutter app (if needed)
3. ✅ Click "Sign In"
4. ✅ Click "Continue with Google"
5. ✅ Select your Google account
6. ✅ You should be signed in successfully! 🎉

---

## Verification Checklist

Before testing, verify:

- ✅ Google provider is **Enabled** in Firebase Console
- ✅ Support email is selected
- ✅ Web Client ID is configured (optional but recommended)
- ✅ Your `index.html` has the correct Web client ID
- ✅ OAuth client in Google Cloud Console is **Web application** type
- ✅ Authorized domains include `localhost` and your Firebase domain

---

## What Happens After Enabling

When you enable Google Sign-In in Firebase:

1. Firebase creates the necessary backend configuration
2. The Identity Toolkit API is properly configured
3. Your app can now authenticate users with Google
4. User data is stored in Firebase Authentication

---

## Troubleshooting After Enabling

### Still getting 400 error?

**Check 1: Is it really enabled?**
- Go back to Firebase Console → Authentication → Sign-in method
- Verify Google shows as "Enabled" with a green checkmark

**Check 2: Wait a moment**
- Changes can take 30-60 seconds to propagate
- Try refreshing your app

**Check 3: Check browser console**
- Look for more specific error messages
- Common errors:
  - "auth/operation-not-allowed" → Not enabled properly
  - "auth/popup-closed-by-user" → User closed popup (normal)
  - "auth/cancelled-popup-request" → Multiple popups (normal)

**Check 4: Try in incognito mode**
- Clear browser cache
- Test in incognito/private browsing

**Check 5: Verify API is enabled**
- Go to Google Cloud Console
- APIs & Services → Library
- Search for "Identity Toolkit API"
- Make sure it's **Enabled**

---

## Identity Toolkit API

The error mentions `identitytoolkit.googleapis.com` - this is Firebase's authentication service.

### Enable Identity Toolkit API (if needed):

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **APIs & Services** → **Library**
4. Search for "**Identity Toolkit API**"
5. Click on it
6. Click **Enable** (if not already enabled)

Usually this is auto-enabled when you enable Google Sign-In in Firebase, but check just in case.

---

## Quick Summary

**What you need to do RIGHT NOW:**

1. ✅ Go to [Firebase Console](https://console.firebase.google.com/)
2. ✅ Select your project
3. ✅ Go to **Authentication** → **Sign-in method**
4. ✅ Click on **Google**
5. ✅ Toggle **Enable** ON
6. ✅ Select your **support email**
7. ✅ Click **Save**
8. ✅ Test Google Sign-In in your app

**That's it!** The 400 error should be gone. 🎉

---

## Expected Result

After enabling Google Sign-In:

✅ **Before:** 400 Bad Request error  
✅ **After:** Successfully signed in with Google account

Your user will be:
- Authenticated in Firebase
- Stored in Firestore (via your UserRepository)
- Redirected to the dashboard
- Able to analyze content

---

## Need Help?

If you're still stuck:
1. Check that Email/Password authentication is also enabled (for comparison)
2. Look at the detailed error in browser console (F12)
3. Verify your Firebase project is on the free Spark plan or higher
4. Make sure you're the owner/editor of the Firebase project

**The most common cause of this 400 error is simply forgetting to enable the Google provider in Firebase Console!** 🔑
