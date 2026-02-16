# Fix Firebase Google Client ID Mismatch

## The Problem
- **Your Google Cloud Console Client ID:** `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com`
- **Firebase won't update** the Web SDK Configuration
- **Error:** "Error Updating Google"

This happens when there's a mismatch between Firebase's auto-generated client and your custom client.

---

## Solution: Use Firebase's Auto-Generated Web Client

Firebase automatically creates OAuth clients when you enable Google Sign-In. Let's use that instead.

### Step 1: Find Firebase's Auto-Generated Web Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: **askbeforeact-f5326** (282557061599)
3. Go to **APIs & Services** → **Credentials**
4. Look for OAuth 2.0 Client IDs - you should see:
   - ✅ **Web client (auto created by Google Service)**
   - Your custom client: `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o`
   
5. **Click on "Web client (auto created by Google Service)"**
6. **Copy this Client ID** - it should look like:
   ```
   282557061599-XXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com
   ```

### Step 2: Configure the Auto-Generated Client

Since Firebase auto-creates this client, we need to configure it properly:

1. In Google Cloud Console, click on **Web client (auto created by Google Service)**
2. Add **Authorized JavaScript origins:**
   ```
   http://localhost
   http://localhost:8080
   https://askbeforeact-f5326.web.app
   https://askbeforeact-f5326.firebaseapp.com
   ```
3. Add **Authorized redirect URIs:**
   ```
   http://localhost/__/auth/handler
   http://localhost:8080/__/auth/handler
   https://askbeforeact-f5326.web.app/__/auth/handler
   https://askbeforeact-f5326.firebaseapp.com/__/auth/handler
   ```
4. Click **Save**

### Step 3: Update Your index.html

Update the client ID in your `web/index.html`:

```html
<meta name="google-signin-client_id" content="282557061599-XXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com">
```

Replace with the **Web client (auto created by Google Service)** Client ID.

### Step 4: Enable Google Sign-In in Firebase (Simple Mode)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Authentication → Sign-in method → Google
3. **Toggle Enable ON**
4. **Select support email**
5. **Leave Web SDK Configuration EMPTY** (don't fill in client ID/secret)
6. Click **Save**

**Important:** By leaving the Web SDK Configuration empty, Firebase will use its auto-generated client, which should work seamlessly.

---

## Alternative Solution: Delete and Re-enable Google Provider

If the above doesn't work, try resetting:

### Step 1: Disable Google Provider in Firebase

1. Firebase Console → Authentication → Sign-in method
2. Click on **Google**
3. Toggle **Disable**
4. Click **Save**

### Step 2: Wait 30 seconds

Give Firebase time to clean up the configuration.

### Step 3: Re-enable Google Provider

1. Click on **Google** again
2. Toggle **Enable ON**
3. Select your **support email**
4. **Leave Web SDK Configuration empty**
5. Click **Save**

### Step 4: Use Firebase's Auto-Generated Client

Firebase will automatically use its own OAuth client. Find it in Google Cloud Console:

1. Go to Credentials
2. Look for **Web client (auto created by Google Service)**
3. Copy that Client ID
4. Update your `index.html` with it

---

## Solution 3: Use Your Custom Client ID Everywhere

If you want to use your custom client (`1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o`):

### Step 1: Get Client Secret

1. Go to Google Cloud Console → Credentials
2. Click on your client: `1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o`
3. Copy the **Client secret** (looks like: `GOCSPX-xxxxxxxxxxxxx`)

### Step 2: Configure in Firebase via Firebase CLI

Since the console won't let you update, use the Firebase CLI:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Select your project
firebase use askbeforeact-f5326
```

Then manually configure via Google Cloud Console instead.

### Step 3: Or Configure Manually in Firebase Project Settings

1. Go to Firebase Console → Project Settings (⚙️ icon)
2. Scroll to **Your apps** section
3. Find your Web app
4. Look for OAuth settings there

---

## Recommended Approach: Use Firebase's Auto-Generated Client

**This is the simplest and most reliable solution:**

1. ✅ Find Firebase's auto-generated Web client in Google Cloud Console
2. ✅ Configure its authorized origins and redirect URIs
3. ✅ Use that Client ID in your `index.html`
4. ✅ Enable Google Sign-In in Firebase (leave Web SDK config empty)
5. ✅ Test!

---

## Update Your index.html

Once you have the correct Client ID, update your file:

**Current (wrong):**
```html
<meta name="google-signin-client_id" content="1001926999690-e5d6q919eg40u59ln6kkkgvlld8a5clh.apps.googleusercontent.com">
```

**Should be (Firebase's auto-generated):**
```html
<meta name="google-signin-client_id" content="282557061599-XXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com">
```

Where `282557061599` is your project number and the rest is auto-generated by Firebase.

---

## Finding the Right Client ID

In Google Cloud Console → Credentials, you should see something like:

```
OAuth 2.0 Client IDs
├── Web client (auto created by Google Service)          ← USE THIS ONE!
│   Client ID: 282557061599-abc123xyz.apps.googleusercontent.com
│   Type: Web application
│
├── iOS client (auto created by Google Service)          ← Don't use
│   Client ID: 282557061599-pdbqhu603qhthmvndlqknglj99uvaua8.apps.googleusercontent.com
│   Type: iOS
│
└── Your custom client                                    ← Can use, but needs proper config
    Client ID: 1001926999690-38ig1cuh2tui6hfbaekbijcogflk0p0o.apps.googleusercontent.com
    Type: Web application
```

**Use the first one (auto created by Google Service)** for easiest setup!

---

## Why Firebase Won't Update

Firebase's "Error Updating Google" happens when:
1. There's a mismatch between Firebase and Google Cloud Console
2. The client ID doesn't belong to the Firebase project
3. Permissions issues
4. The client was created manually instead of by Firebase

**Solution:** Use Firebase's auto-generated client to avoid this issue.

---

## Testing After Fix

1. ✅ Update `web/index.html` with correct Client ID
2. ✅ Restart Flutter app: `flutter run -d chrome`
3. ✅ Click "Sign In"
4. ✅ Click "Continue with Google"
5. ✅ Select your Google account
6. ✅ **Should work now!** 🎉

---

## Verification Checklist

Before testing:

- ✅ Client ID in `index.html` matches the one in Google Cloud Console
- ✅ Client type is **Web application** (not iOS/Android)
- ✅ Authorized JavaScript origins include localhost
- ✅ Authorized redirect URIs include `/__/auth/handler`
- ✅ Google Sign-In is **Enabled** in Firebase Console
- ✅ Support email is selected in Firebase

---

## Quick Command to Check Your Setup

Add this temporarily to your `auth_service.dart` to debug:

```dart
Future<UserCredential> signInWithGoogle() async {
  print('🔍 Attempting Google Sign-In...');
  print('📱 Client ID from HTML should be used');
  
  try {
    final GoogleSignInAccount? googleUser = await _getGoogleSignIn.signIn();
    
    if (googleUser == null) {
      print('❌ User cancelled sign-in');
      throw Exception('Google sign in was cancelled');
    }
    
    print('✅ Google user: ${googleUser.email}');
    
    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;
    
    print('✅ Got auth tokens');
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    print('✅ Created Firebase credential');
    
    final result = await _auth.signInWithCredential(credential);
    print('✅ Signed in to Firebase: ${result.user?.email}');
    
    return result;
  } catch (e) {
    print('❌ Error: $e');
    throw e;
  }
}
```

This will help you see exactly where it's failing.

---

## Summary

**The Fix:**

1. Find Firebase's **auto-generated Web client** in Google Cloud Console
2. Configure its authorized origins and redirect URIs
3. Copy that Client ID
4. Update your `index.html` with it
5. Enable Google Sign-In in Firebase (leave Web SDK config empty)
6. Restart your app
7. Test Google Sign-In

**The key is using the right Client ID that Firebase recognizes!** 🔑
