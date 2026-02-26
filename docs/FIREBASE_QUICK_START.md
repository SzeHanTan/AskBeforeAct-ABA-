# Firebase Quick Start Checklist
## AskBeforeAct Backend Setup

**Project ID:** `askbeforeact-f5326`

---

## ✅ Step-by-Step Checklist

### 1. Authentication Setup (5 minutes)

- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Select project: `askbeforeact-f5326`
- [ ] Click **Authentication** → **Get started**
- [ ] Enable **Email/Password** (Sign-in method tab)
- [ ] Enable **Google** (add your support email)
- [ ] Enable **Anonymous**

**Verification:** You should see 3 enabled providers in the Sign-in method tab.

---

### 2. Cloud Firestore Setup (10 minutes)

- [ ] Click **Firestore Database** → **Create database**
- [ ] Select **"Start in production mode"**
- [ ] Choose location (recommend: `us-central1` or closest to you)
- [ ] Click **Enable**

**Create Collections:**

- [ ] Create collection: `users` (with test document)
- [ ] Create collection: `analyses` (with test document)
- [ ] Create collection: `communityPosts` (with test document)
- [ ] Create collection: `educationContent` (with 5 documents)

**Verification:** You should see 4 collections in Firestore.

---

### 3. Firebase Storage Setup (3 minutes)

- [ ] Click **Storage** → **Get started**
- [ ] Accept default security rules
- [ ] Choose **same location** as Firestore
- [ ] Click **Done**
- [ ] Create folder: `screenshots`

**Verification:** You should see the `screenshots/` folder in Storage.

---

### 4. Firebase CLI Setup (5 minutes)

Open PowerShell and run:

```powershell
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Navigate to project
cd C:\Users\tzeha\Desktop\AskBeforeAct-ABA-

# Initialize Firebase
firebase init hosting
```

**Answer prompts:**
- Use existing project: `askbeforeact-f5326`
- Public directory: `build/web`
- Single-page app: `y`
- GitHub deploys: `n`

**Verification:** You should see `firebase.json` and `.firebaserc` files created.

---

### 5. Deploy Security Rules (2 minutes)

The `firestore.rules` and `storage.rules` files are already created in your project.

```powershell
# Deploy rules
firebase deploy --only firestore:rules,storage:rules
```

**Verification:** You should see "✔ Deploy complete!" message.

---

### 6. Get Firebase Configuration (5 minutes)

#### Option A: Web Configuration (for reference)

- [ ] Go to Firebase Console → **Project Settings** (gear icon)
- [ ] Scroll to **"Your apps"**
- [ ] Click **Add app** → **Web** (</> icon)
- [ ] App nickname: `AskBeforeAct Web`
- [ ] Check **"Also set up Firebase Hosting"**
- [ ] Click **Register app**
- [ ] Copy the `firebaseConfig` object (save for later)

#### Option B: FlutterFire Configuration (recommended)

```powershell
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure for Flutter
flutterfire configure --project=askbeforeact-f5326
```

**Verification:** You should see `lib/firebase_options.dart` created.

---

### 7. Seed Education Content (10 minutes)

Go to Firestore Database and create these 5 documents in `educationContent`:

#### Document 1: `phishing`
```
id: "phishing"
title: "Phishing Emails"
description: "Fraudulent emails designed to steal personal information"
icon: "🎣"
warningSigns: ["Urgent language", "Suspicious sender", "Generic greetings", "Spelling errors"]
preventionTips: ["Verify sender email", "Don't click suspicious links", "Check URL carefully", "Enable 2FA"]
example: "Your account will be closed unless you verify immediately. Click here to verify."
order: 1
```

#### Document 2: `romance`
```
id: "romance"
title: "Romance Scams"
description: "Fake romantic relationships to steal money"
icon: "💔"
warningSigns: ["Too good to be true", "Moves too fast", "Asks for money", "Avoids video calls"]
preventionTips: ["Never send money to strangers", "Do reverse image search", "Be skeptical of sob stories", "Meet in person before trusting"]
example: "I love you so much. I need $500 for an emergency. I'll pay you back next week."
order: 2
```

#### Document 3: `payment`
```
id: "payment"
title: "Payment Fraud"
description: "Fraudulent payment requests and fake invoices"
icon: "💳"
warningSigns: ["Unexpected payment request", "Unusual payment method", "Pressure to pay quickly", "No invoice details"]
preventionTips: ["Verify payment requests directly", "Use secure payment methods", "Check invoice details", "Don't pay via gift cards"]
example: "Your invoice is overdue. Pay $1,000 via wire transfer immediately to avoid legal action."
order: 3
```

#### Document 4: `job`
```
id: "job"
title: "Job Scams"
description: "Fake job offers to steal money or information"
icon: "💼"
warningSigns: ["Too high salary", "No interview required", "Upfront payment requested", "Vague job description"]
preventionTips: ["Research company thoroughly", "Never pay for a job", "Verify job posting", "Be wary of work-from-home offers"]
example: "Congratulations! You're hired. Send $200 for equipment and training materials."
order: 4
```

#### Document 5: `tech_support`
```
id: "tech_support"
title: "Tech Support Scams"
description: "Fake tech support to gain access to your computer"
icon: "💻"
warningSigns: ["Unsolicited contact", "Claims of virus/problem", "Requests remote access", "Demands immediate payment"]
preventionTips: ["Never give remote access to strangers", "Hang up on unsolicited calls", "Contact companies directly", "Use official support channels"]
example: "This is Microsoft. Your computer has a virus. Give us remote access to fix it for $299."
order: 5
```

**Verification:** You should see 5 documents in `educationContent` collection.

---

### 8. Test Your Setup (5 minutes)

#### Test Authentication:
- [ ] Go to Authentication tab
- [ ] Verify 3 providers are enabled

#### Test Firestore:
- [ ] Go to Firestore Database
- [ ] Try reading a document from `educationContent`
- [ ] Check Rules tab to see your deployed rules

#### Test Storage:
- [ ] Go to Storage
- [ ] Verify `screenshots/` folder exists
- [ ] Check Rules tab to see your deployed rules

---

## 🎉 Setup Complete!

Your Firebase backend is now ready for development!

### Next Steps:

1. **Get Gemini API Key:**
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create API key
   - Save it securely

2. **Create .env file:**
   ```
   GEMINI_API_KEY=your_api_key_here
   ```

3. **Start building your Flutter app:**
   - Implement authentication service
   - Create Firestore service layer
   - Build storage service
   - Integrate Gemini AI

Refer to `05_BACKEND_STRUCTURE.md` for complete code implementation.

---

## 📋 Configuration Summary

| Service | Status | Configuration |
|---------|--------|---------------|
| **Authentication** | ✅ | Email, Google, Anonymous |
| **Firestore** | ✅ | 4 collections, security rules |
| **Storage** | ✅ | Screenshots folder, security rules |
| **Hosting** | ✅ | Firebase CLI configured |
| **Security Rules** | ✅ | Deployed |

---

## 🆘 Need Help?

- **Firebase Console:** https://console.firebase.google.com/
- **Firebase Documentation:** https://firebase.google.com/docs
- **FlutterFire Documentation:** https://firebase.flutter.dev/

If you encounter issues, check `FIREBASE_SETUP_GUIDE.md` for detailed troubleshooting.

---

**Last Updated:** February 14, 2026  
**Status:** ✅ Ready for Development
