# Configure Firebase Web SDK for Google Sign-In

## The Problem

You're getting an access token from Google (✅ Good!), but Firebase is rejecting it with a 400 error because the Web SDK Configuration is not properly set up.

The error shows:
```
identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=... 400
```

This means Firebase doesn't recognize your OAuth client.

---

## Solution: Add Web Client ID and Secret to Firebase

### Step 1: Get Your Client Secret from Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **APIs & Services** → **Credentials**
4. Click on **"AskBeforeAct Web Client"** (your OAuth client)
5. You'll see:
   - **Client ID:** `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com`
   - **Client secret:** `GOCSPX-xxxxxxxxxxxxxxxxxxxxx` (looks like this)
6. **Copy both** the Client ID and Client secret

### Step 2: Configure Firebase Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **askbeforeact-f5326**
3. Go to **Authentication** → **Sign-in method**
4. Click on **Google** (should already be enabled)
5. In the configuration panel:

   **Enable:** ✅ ON (should be blue/green)
   
   **Project support email:** Select your email
   
   **Web SDK configuration:**
   - **Web client ID:** `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com`
   - **Web client secret:** Paste the secret from Step 1 (e.g., `GOCSPX-xxxxxxxxxxxxxxxxxxxxx`)

6. Click **Save**

### Step 3: If You Get "Error Updating Google"

If Firebase won't let you save, try this workaround:

**Option A: Use Firebase CLI**

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Select your project
firebase use askbeforeact-f5326
```

Then manually configure via the console again after a few minutes.

**Option B: Delete and Re-add Google Provider**

1. In Firebase Console, click on Google provider
2. Toggle **Disable**
3. Click Save
4. Wait 30 seconds
5. Click on Google again
6. Toggle **Enable**
7. Add your support email
8. Add Web SDK configuration (Client ID and Secret)
9. Click Save

---

## Step 4: Verify OAuth Client Configuration

Make sure your OAuth client in Google Cloud Console has these:

**Authorized JavaScript origins:**
```
http://localhost
http://localhost:8080
https://askbeforeact-f5326.web.app
https://askbeforeact-f5326.firebaseapp.com
```

**Authorized redirect URIs:**
```
http://localhost/__/auth/handler
http://localhost:8080/__/auth/handler
https://askbeforeact-f5326.web.app/__/auth/handler
https://askbeforeact-f5326.firebaseapp.com/__/auth/handler
```

---

## Step 5: Restart Your App

```bash
# Stop the app (Ctrl+C)
flutter run -d chrome
```

---

## Step 6: Test Google Sign-In

1. Click "Sign In"
2. Click "Continue with Google"
3. Select your Google account
4. ✅ **Should work now!**

---

## Understanding the Error

The logs show:
```javascript
[GSI_LOGGER-TOKEN_CLIENT]: Handling response. 
{"access_token":"ya29.A0ATkoCc41ih9Pj4MLOmFBDGnpHORSToHdGiIHIvUrFt79yuuQgfZy3GvuKiHTLleGXlaM0EF_kmduucnDiA1oIOhWC2YvJ6wsW2csEHMjRj58sAu6EpBo4ZZNQWyqOYDTWpfOiTlH9jyVOdDTxk1jaqrdSe2Px3AVq-QskkmSlIn46nIjvqu9NQ3LP17pDBVnSdq_GNoqtuaqen1wAE9GWt6O9g3HtFzR6nKzAJehfOIunaxch2UTzqZ9xt_n7fJ0z0mpcwD0DCyCkGpkfFsU67hPiW3xaCgYKAV8SARcSFQHGX2MiMBJaDZfNfa18CCdpdYzZIw0291",...}
```

✅ **Good:** You're successfully getting an access token from Google  
❌ **Problem:** Firebase doesn't recognize this token because the Web SDK config is missing

---

## Why Web SDK Configuration is Required

Firebase needs to know:
1. **Which OAuth client** you're using (Client ID)
2. **How to verify** the tokens from that client (Client Secret)

Without this configuration, Firebase can't validate the Google token and rejects it with a 400 error.

---

## Alternative: Check if There's an Auto-Generated Client

Sometimes Firebase creates a client automatically. Check Google Cloud Console:

1. Go to Credentials
2. Look for any client with "auto created by Google Service" in the name
3. If you find one, use its Client ID and Secret instead

But based on your screenshot, you only have the one you created, so use that.

---

## Finding Your Client Secret

If you can't find the client secret:

1. Go to Google Cloud Console → Credentials
2. Click on your OAuth client
3. Look for **Client secret** on the right side
4. If you don't see it, you may need to:
   - Click the **pencil icon** (edit)
   - The secret should be visible there
5. If it's hidden, you can **reset** it:
   - Click "Reset secret"
   - Copy the new secret
   - Use it in Firebase

---

## Expected Firebase Configuration

After configuration, your Firebase Google provider should show:

```
Google Sign-In Provider
├── Status: Enabled ✅
├── Support email: your-email@gmail.com
└── Web SDK configuration:
    ├── Web client ID: 1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com
    └── Web client secret: GOCSPX-xxxxxxxxxxxxxxxxxxxxx
```

---

## Troubleshooting

### Error: "Error Updating Google"

**Cause:** Firebase can't validate your client ID/secret

**Solutions:**
1. Double-check the Client ID and Secret (no extra spaces)
2. Make sure the OAuth client is in the same Google Cloud project as Firebase
3. Try disabling and re-enabling the Google provider
4. Wait a few minutes and try again (propagation delay)

### Error: "Invalid client"

**Cause:** Client ID doesn't match or is from a different project

**Solution:** 
1. Verify the Client ID in Google Cloud Console
2. Make sure you're in the correct Firebase project
3. Check that the project numbers match (282557061599)

### Still getting 400 error after configuration

**Possible causes:**
1. Changes haven't propagated yet (wait 1-2 minutes)
2. Browser cache (clear cache or use incognito)
3. App needs restart (stop and restart Flutter app)

---

## Quick Summary

**What you need to do:**

1. ✅ Go to Google Cloud Console → Credentials
2. ✅ Click on "AskBeforeAct Web Client"
3. ✅ Copy the **Client secret**
4. ✅ Go to Firebase Console → Authentication → Sign-in method → Google
5. ✅ Add **Web client ID** and **Web client secret**
6. ✅ Click **Save**
7. ✅ Restart your Flutter app
8. ✅ Test Google Sign-In

**The key is adding both the Client ID AND Client Secret to Firebase!** 🔑

---

## After Successful Configuration

Once configured correctly, the flow will be:

1. User clicks "Continue with Google"
2. Google popup opens ✅ (working)
3. User selects account ✅ (working)
4. Google returns access token ✅ (working)
5. Firebase validates the token ✅ (will work after config)
6. User is authenticated in Firebase ✅
7. User data saved to Firestore ✅
8. Redirected to dashboard ✅

**You're almost there! Just need to add the Client Secret to Firebase!** 🚀
