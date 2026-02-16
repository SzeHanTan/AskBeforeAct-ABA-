# How to Get Your OAuth Client Secret

## Quick Steps

### 1. Go to Google Cloud Console
https://console.cloud.google.com/apis/credentials

### 2. Find Your OAuth Client
Look for: **"AskBeforeAct Web Client"**

### 3. Click on It
You'll see a page with details

### 4. Find the Client Secret
On the right side, you'll see:

```
Client ID
1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com

Client secret
GOCSPX-xxxxxxxxxxxxxxxxxxxxx
```

### 5. Copy Both
- Client ID: `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com`
- Client secret: `GOCSPX-xxxxxxxxxxxxxxxxxxxxx`

---

## Add to Firebase

### 1. Go to Firebase Console
https://console.firebase.google.com/

### 2. Navigate to Google Sign-In
Authentication → Sign-in method → Click on **Google**

### 3. Fill in Web SDK Configuration

**Web client ID:**
```
1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com
```

**Web client secret:**
```
GOCSPX-xxxxxxxxxxxxxxxxxxxxx
```
(Paste your actual secret)

### 4. Save
Click the **Save** button

---

## If You Can't See the Client Secret

### Option 1: Click Edit Icon
- Click the pencil/edit icon on your OAuth client
- The secret should be visible in the edit view

### Option 2: Reset the Secret
- Click "Reset secret" button
- Copy the new secret immediately
- Update it in Firebase

---

## Test After Configuration

1. Restart your Flutter app
2. Click "Sign In"
3. Click "Continue with Google"
4. Select your account
5. ✅ Should work!

---

## What This Fixes

**Before:** Firebase rejects Google token (400 error)  
**After:** Firebase validates and accepts Google token ✅

The Client Secret allows Firebase to verify that the access token really came from your OAuth client.

---

**That's it! Just copy the Client Secret from Google Cloud Console and paste it into Firebase Console.** 🔑
