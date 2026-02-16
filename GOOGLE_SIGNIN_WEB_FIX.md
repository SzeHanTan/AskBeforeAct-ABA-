# Google Sign-In Web Configuration Fix

## Problem
Google Sign-In is failing with the error:
```
ClientID not set. Either set it on a <meta name="google-signin-client_id" content="CLIENT_ID" /> tag, 
or pass clientId when initializing GoogleSignIn
```

This happens because Google Sign-In for web requires additional configuration beyond what Firebase provides.

---

## Solution: Add Google Client ID to Web

### Step 1: Get Your Google OAuth Client ID

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **askbeforeact-f5326**
3. Click the **⚙️ Settings** icon → **Project settings**
4. Scroll down to **Your apps** section
5. Find your **Web app** and look for the **Web API Key**

**OR** Get it from Google Cloud Console:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **APIs & Services** → **Credentials**
4. Look for **OAuth 2.0 Client IDs**
5. Find the **Web client** (Auto-created by Google Service)
6. Copy the **Client ID** (looks like: `123456789-abc123def456.apps.googleusercontent.com`)

### Step 2: Add Client ID to index.html

Open: `askbeforeact/web/index.html`

Add this `<meta>` tag inside the `<head>` section:

```html
<!DOCTYPE html>
<html>
<head>
  <!-- ... existing tags ... -->
  
  <!-- Add this line for Google Sign-In -->
  <meta name="google-signin-client_id" content="YOUR_CLIENT_ID_HERE.apps.googleusercontent.com">
  
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <!-- ... rest of the file ... -->
</head>
```

**Replace `YOUR_CLIENT_ID_HERE` with your actual Client ID!**

### Step 3: Enable Google Sign-In in Firebase

1. Go to Firebase Console → **Authentication** → **Sign-in method**
2. Click on **Google**
3. Click **Enable**
4. Add your **support email**
5. Click **Save**

### Step 4: Add Authorized Domains

In Firebase Console → Authentication → Settings → **Authorized domains**

Make sure these are listed:
- ✅ `localhost`
- ✅ Your production domain (when you deploy)

### Step 5: Restart Your App

```bash
# Stop the app (Ctrl+C)
# Then restart
flutter run -d chrome
```

---

## Alternative: Configure in Code (Optional)

If you prefer to configure it in code instead of HTML, update `auth_service.dart`:

```dart
GoogleSignIn get _getGoogleSignIn {
  _googleSignIn ??= GoogleSignIn(
    clientId: 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com',
  );
  return _googleSignIn!;
}
```

---

## How to Find Your Client ID

### Method 1: From Firebase Console
1. Firebase Console → Project Settings
2. Scroll to "Your apps" section
3. Click on your Web app
4. Look for "Web client ID"

### Method 2: From firebase_options.dart
Check your `lib/firebase_options.dart` file - sometimes the iOS client ID is there:

```dart
static const FirebaseOptions ios = FirebaseOptions(
  // ...
  iosClientId: '282557061599-pdbqhu603qhthmvndlqknglj99uvaua8.apps.googleusercontent.com',
  // ...
);
```

### Method 3: Create a New Web Client ID

If you don't have one:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. **APIs & Services** → **Credentials**
4. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
5. Application type: **Web application**
6. Name: "AskBeforeAct Web Client"
7. Authorized JavaScript origins:
   - `http://localhost:7357`
   - `http://localhost` (add your port)
8. Authorized redirect URIs:
   - `http://localhost:7357/__/auth/handler`
   - `http://localhost/__/auth/handler`
9. Click **Create**
10. Copy the **Client ID**

---

## Complete Example: index.html

Here's what your `web/index.html` should look like:

```html
<!DOCTYPE html>
<html>
<head>
  <!--
    If you are serving your web app in a path other than the root, change the
    href value below to reflect the base path you are serving from.

    The path provided below has to start and end with a slash "/" in order for
    it to work correctly.

    For more details:
    * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base

    This is a placeholder for base href that will be replaced by the value of
    the `--base-href` argument provided to `flutter build`.
  -->
  <base href="$FLUTTER_BASE_HREF">

  <!-- Google Sign-In Client ID -->
  <meta name="google-signin-client_id" content="282557061599-pdbqhu603qhthmvndlqknglj99uvaua8.apps.googleusercontent.com">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="AI-powered fraud detection web application">

  <!-- iOS meta tags & icons -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="AskBeforeAct">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>AskBeforeAct - AI Fraud Detection</title>
  <link rel="manifest" href="manifest.json">

  <script>
    // The value below is injected by flutter build, do not touch.
    var serviceWorkerVersion = null;
  </script>
  <!-- This script adds the flutter initialization JS code -->
  <script src="flutter.js" defer></script>
</head>
<body>
  <script>
    window.addEventListener('load', function(ev) {
      // Download main.dart.js
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
</body>
</html>
```

**Note:** I used the iOS client ID from your `firebase_options.dart` as an example. You should verify this is the correct web client ID.

---

## Testing Google Sign-In

After configuration:

1. ✅ Restart your app
2. ✅ Click "Sign In"
3. ✅ Click "Continue with Google"
4. ✅ Select your Google account
5. ✅ You should be signed in successfully!

---

## Troubleshooting

### Error: "popup_closed_by_user"
- User closed the popup → Normal behavior, try again

### Error: "access_denied"
- Check authorized domains in Firebase Console
- Make sure localhost is authorized

### Error: "invalid_client"
- Wrong Client ID
- Check that the Client ID matches your Firebase project

### Still not working?
1. Clear browser cache
2. Try in incognito mode
3. Check browser console for specific errors
4. Verify Client ID is correct (no typos)

---

## Quick Fix Summary

**What you need to do:**

1. ✅ Get your Google OAuth Client ID from Firebase/Google Cloud Console
2. ✅ Add it to `web/index.html` in the `<meta>` tag
3. ✅ Enable Google Sign-In in Firebase Console
4. ✅ Restart your app
5. ✅ Test Google Sign-In

**That's it!** 🎉
