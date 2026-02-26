# Create Web OAuth Client ID - Step by Step

## The Problem
You're getting "Storagerelay URI is not allowed for 'NATIVE_IOS' client type" because you need a **Web application** OAuth client, not an iOS client.

---

## Solution: Create Web OAuth Client ID

### Step 1: Go to Google Cloud Console

1. Open [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: **askbeforeact-f5326** (or project ID: 282557061599)
3. In the left menu, go to: **APIs & Services** → **Credentials**

### Step 2: Create OAuth Client ID

1. Click **+ CREATE CREDENTIALS** (at the top)
2. Select **OAuth client ID**

### Step 3: Configure the Web Client

**Application type:** Select **Web application**

**Name:** `AskBeforeAct Web Client` (or any name you prefer)

**Authorized JavaScript origins:** Add these URLs:
```
http://localhost
http://localhost:7357
http://localhost:8080
https://askbeforeact-f5326.web.app
https://askbeforeact-f5326.firebaseapp.com
```

**Authorized redirect URIs:** Add these:
```
http://localhost/__/auth/handler
http://localhost:7357/__/auth/handler
http://localhost:8080/__/auth/handler
https://askbeforeact-f5326.web.app/__/auth/handler
https://askbeforeact-f5326.firebaseapp.com/__/auth/handler
```

**Important Notes:**
- Replace `7357` with your actual Flutter dev server port (check your terminal)
- Add both `localhost` and `127.0.0.1` if needed
- Include your production domain when you deploy

### Step 4: Create and Copy Client ID

1. Click **CREATE**
2. A popup will show your **Client ID** and **Client secret**
3. **Copy the Client ID** (looks like: `123456789-abc123xyz.apps.googleusercontent.com`)
4. Click **OK**

### Step 5: Update index.html

Open: `askbeforeact/web/index.html`

Replace the client ID in the meta tag:

```html
<meta name="google-signin-client_id" content="YOUR_NEW_WEB_CLIENT_ID.apps.googleusercontent.com">
```

**Example:**
```html
<meta name="google-signin-client_id" content="1001926999690-abc123xyz456.apps.googleusercontent.com">
```

### Step 6: Enable Google Sign-In in Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Authentication** → **Sign-in method**
4. Click on **Google**
5. **Enable** it
6. **Web SDK configuration** section:
   - **Web client ID:** Paste your new Web client ID here
   - **Web client secret:** Paste the client secret (from Step 4)
7. Add your **support email**
8. Click **Save**

### Step 7: Restart Your App

```bash
# Stop the app (Ctrl+C)
flutter run -d chrome
```

---

## Quick Reference: What You Need

From your Firebase config, your project details are:
- **Project ID:** `askbeforeact-f5326`
- **Project Number:** `282557061599`
- **Auth Domain:** `askbeforeact-f5326.firebaseapp.com`

Your **Web Client ID** should look like:
```
1001926999690-XXXXXXXXXXXXXXXX.apps.googleusercontent.com
```

Where `1001926999690` is your project number and the rest is auto-generated.

---

## Visual Guide

### In Google Cloud Console → Credentials:

You should see multiple OAuth 2.0 Client IDs:
- ✅ **Web client (auto created by Google Service)** ← Use this one!
- ❌ iOS client (auto created by Google Service) ← Don't use this
- ❌ Android client (auto created by Google Service) ← Don't use this

If you don't see a Web client, create one following the steps above.

---

## Common Mistakes to Avoid

❌ **Using iOS Client ID** → Error: "NATIVE_IOS client type"
❌ **Using Android Client ID** → Error: "NATIVE_ANDROID client type"
❌ **Wrong redirect URIs** → Error: "redirect_uri_mismatch"
❌ **Missing localhost** → Can't test locally

✅ **Use Web Application Client ID** → Works!
✅ **Add all redirect URIs** → No errors
✅ **Include localhost variants** → Local testing works

---

## Testing After Configuration

1. ✅ Restart your Flutter app
2. ✅ Click "Sign In"
3. ✅ Click "Continue with Google"
4. ✅ Google popup should open
5. ✅ Select your account
6. ✅ You should be signed in successfully!

---

## Troubleshooting

### Error: "redirect_uri_mismatch"
**Solution:** Add the redirect URI shown in the error to your OAuth client's authorized redirect URIs

### Error: "Access blocked"
**Solution:** Make sure you're using a **Web application** client type, not iOS/Android

### Error: "popup_closed_by_user"
**Solution:** User closed the popup - this is normal, just try again

### Still not working?
1. Check that you're using the **Web client ID**, not iOS/Android
2. Verify all redirect URIs are added
3. Clear browser cache and try in incognito mode
4. Check browser console for specific error messages

---

## Alternative: Use Existing Web Client

If you already have a Web client ID in Google Cloud Console:

1. Go to **APIs & Services** → **Credentials**
2. Look for **Web client (auto created by Google Service)**
3. Click on it to view details
4. Copy the **Client ID**
5. Update your `index.html` with this Client ID
6. Make sure the authorized URIs include localhost

---

## Summary

**What you need to do:**

1. ✅ Create a **Web application** OAuth client in Google Cloud Console
2. ✅ Add authorized JavaScript origins (localhost, your domain)
3. ✅ Add authorized redirect URIs (/__/auth/handler)
4. ✅ Copy the Web Client ID
5. ✅ Update `web/index.html` with the Web Client ID
6. ✅ Configure it in Firebase Console → Authentication → Google
7. ✅ Restart your app
8. ✅ Test Google Sign-In

**The key is using a Web client ID, not iOS/Android!** 🔑
