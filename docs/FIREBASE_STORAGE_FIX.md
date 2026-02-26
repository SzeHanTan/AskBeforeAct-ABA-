# Firebase Storage 403 Error - Quick Fix

## Problem
You're getting a 403 (Forbidden) error when trying to upload screenshots to Firebase Storage. This is because Firebase Storage security rules are blocking the upload.

## Solution

### Step 1: Configure Firebase Storage Rules

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **askbeforeact-f5326**
3. Click on **Storage** in the left sidebar
4. Click on the **Rules** tab
5. Replace the existing rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Screenshots folder - users can read/write their own files
    match /screenshots/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
    
    // Uploads folder - users can read/write their own files
    match /uploads/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
  }
}
```

6. Click **Publish** to save the rules

### Step 2: Verify Storage is Enabled

1. In Firebase Console → Storage
2. Make sure you see a bucket (e.g., `askbeforeact-f5326.firebasestorage.app`)
3. If you see "Get Started", click it to enable Storage

### Step 3: Test Again

1. Hot reload your app or restart it
2. Sign in with your email account
3. Try uploading a screenshot for analysis
4. It should now work!

---

## Alternative: Temporary Open Rules (FOR TESTING ONLY)

⚠️ **WARNING**: Only use this for testing. DO NOT use in production!

If you want to quickly test without authentication restrictions:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null; // Any authenticated user
    }
  }
}
```

After testing, replace with the secure rules above.

---

## What These Rules Do

### Secure Rules (Recommended):
- ✅ Users can only upload to their own folder (`screenshots/{userId}/`)
- ✅ Users can only read their own files
- ✅ Files must be under 10MB
- ✅ User must be authenticated

### File Structure:
```
storage/
├── screenshots/
│   ├── {userId1}/
│   │   ├── abc123.jpg
│   │   └── def456.jpg
│   └── {userId2}/
│       └── ghi789.jpg
└── uploads/
    └── {userId1}/
        └── file.pdf
```

---

## Troubleshooting

### Still getting 403 error?
1. **Check if you're signed in**: Make sure you're authenticated
2. **Check userId**: Verify the userId in the upload path matches your auth UID
3. **Check file size**: Make sure the image is under 10MB
4. **Wait a moment**: Rules can take a few seconds to propagate

### How to check your User ID:
Add this to your analyze screen temporarily:
```dart
print('Current User ID: ${authProvider.userId}');
```

### Check the upload path:
The path should be: `screenshots/{your-user-id}/{random-uuid}.jpg`

---

## Next Steps

After fixing Storage rules, you should also configure:

1. **Firestore Rules** (for database security)
2. **Authentication Settings** (enable Email/Password in Firebase Console)

See `SETUP_GUIDE.md` for complete setup instructions.
