# AskBeforeAct (ABA) - MVP Edition
## AI-Powered Fraud Detection Web Application

**Version:** 2.0 (MVP)  
**Development Timeline:** 2 Weeks  
**Target Launch:** February 2026  

---

## Executive Summary

AskBeforeAct (ABA) is an AI-powered web application that helps users detect online fraud by analyzing screenshots, text messages, and URLs. This MVP focuses on the core fraud detection feature with basic community sharing and educational resources, designed for rapid development and $0/month operational costs.

---

## 1. Project Overview

### 1.1 Problem Statement

Online fraud is increasingly sophisticated, with users lacking accessible tools to verify suspicious content in real-time. Most people don't know how to identify phishing emails, romance scams, or fraudulent payment requests until it's too late.

### 1.2 MVP Solution

AskBeforeAct provides instant AI-powered fraud analysis through:
- **Multi-format input support** (screenshots, text, URLs)
- **Real-time AI analysis** using Gemini 1.5 Flash
- **Risk scoring** with actionable recommendations
- **Simple community platform** for sharing experiences
- **Basic fraud education** library

### 1.3 Target Users

- **Primary:** Individuals aged 30-70 concerned about online security
- **Secondary:** Anyone receiving suspicious messages or emails
- **Tertiary:** Small business owners and family protectors

---

## 2. Core Features (MVP Scope)

### 2.1 AI Fraud Detection ⭐ (Core Feature)

**Input Methods:**
- Screenshot upload (JPG, PNG)
- Text paste (emails, messages)
- URL input for website checking

**Analysis Output:**
- Risk score (0-100%) with color coding:
  - 🟢 Low Risk (0-30%)
  - 🟡 Medium Risk (31-70%)
  - 🔴 High Risk (71-100%)
- List of detected red flags
- Scam type classification
- 3-5 actionable recommendations

**Processing:**
- Gemini 1.5 Flash analyzes content
- Returns structured JSON response
- Stores analysis in Firebase Firestore

### 2.2 Analysis History

- View past 30 analyses (most recent first)
- Quick cards showing: date, risk level, scam type
- Tap to view full analysis details
- Simple statistics: total scans, high-risk count

### 2.3 Community Platform (Simplified)

**Features:**
- Post scam experiences (text only, max 500 chars)
- View community feed (chronological)
- Simple upvote system (helpful/not helpful)
- Filter by scam type (phishing, romance, payment, job, other)
- No comments in MVP (to reduce complexity)

**Moderation:**
- Manual review by admin (you)
- Users can report inappropriate posts

### 2.4 Education Hub (Basic)

**Content:**
- 5 fraud type guides (static content):
  1. Phishing Emails
  2. Romance Scams
  3. Payment Fraud
  4. Job Scams
  5. Tech Support Scams
- Each guide includes:
  - Description
  - Warning signs (3-5 bullet points)
  - Prevention tips (3-5 bullet points)
  - Real example (text-based)

**No official alerts in MVP** (requires external API integration)

### 2.5 User Authentication

- Email/password sign-up and login
- Google Sign-In (Firebase Auth)
- Anonymous usage (limited to 3 analyses)
- Basic profile (name, email, join date)

---

## 3. Technical Architecture

### 3.1 Tech Stack Overview

| Layer | Technology | Cost |
|-------|-----------|------|
| **Frontend** | Flutter Web | $0 |
| **Backend** | Firebase (Firestore, Auth, Storage) | $0 (free tier) |
| **AI** | Google Gemini 1.5 Flash API | $0 (free tier: 15 RPM) |
| **Hosting** | Vercel | $0 (hobby plan) |
| **Total** | | **$0/month** |

### 3.2 Frontend (Flutter Web)

**Why Flutter?**
- Single codebase for web (and future mobile apps)
- Fast development with hot reload
- Beautiful Material Design components
- Strong typing with Dart
- Easy Firebase integration

**Key Packages:**
- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Database operations
- `firebase_storage` - File uploads
- `google_generative_ai` - Gemini API client
- `provider` - State management
- `go_router` - Navigation
- `image_picker_web` - Screenshot uploads
- `url_launcher` - Open external links
- `intl` - Date formatting

**Architecture Pattern:**
- **MVVM (Model-View-ViewModel)** pattern
- **Provider** for state management
- **Repository pattern** for data layer

### 3.3 Backend (Firebase)

**Firebase Services Used:**

1. **Firebase Authentication**
   - Email/password authentication
   - Google OAuth
   - Anonymous authentication
   - User session management

2. **Cloud Firestore (Database)**
   - NoSQL document database
   - Real-time updates
   - Offline support
   - Free tier: 50K reads, 20K writes/day

3. **Firebase Storage**
   - Store uploaded screenshots
   - Free tier: 5GB storage, 1GB/day downloads
   - Automatic CDN distribution

4. **Firebase Hosting** (Optional backup to Vercel)
   - Static site hosting
   - SSL included
   - Free tier: 10GB storage, 360MB/day transfer

**Database Schema:**

```
users/
  {userId}/
    - email: string
    - displayName: string
    - createdAt: timestamp
    - analysisCount: number

analyses/
  {analysisId}/
    - userId: string
    - type: "screenshot" | "text" | "url"
    - content: string (URL to storage or text)
    - riskScore: number (0-100)
    - scamType: string
    - redFlags: array<string>
    - recommendations: array<string>
    - createdAt: timestamp

communityPosts/
  {postId}/
    - userId: string
    - userName: string
    - scamType: string
    - content: string
    - upvotes: number
    - downvotes: number
    - createdAt: timestamp
    - reported: boolean

educationContent/
  {scamTypeId}/
    - title: string
    - description: string
    - warningSigns: array<string>
    - preventionTips: array<string>
    - example: string
```

### 3.4 AI Integration (Gemini 1.5 Flash)

**API Configuration:**
- Model: `gemini-1.5-flash`
- Free tier: 15 requests/minute, 1 million tokens/minute
- Multimodal: Supports text and images

**Prompt Engineering:**

For each analysis, send structured prompt:

```
You are a fraud detection expert. Analyze the following content for potential fraud indicators.

Content Type: [screenshot/text/url]
Content: [user input]

Provide a JSON response with:
1. riskScore (0-100)
2. scamType (phishing/romance/payment/job/tech_support/other)
3. redFlags (array of specific indicators found)
4. recommendations (array of 3-5 actionable steps)
5. confidence (low/medium/high)

Be specific and cite evidence from the content.
```

**Response Parsing:**
- Parse JSON from Gemini response
- Validate structure
- Store in Firestore
- Display to user

---

## 4. Development Plan (2 Weeks)

### Week 1: Core Infrastructure & AI Detection

**Days 1-2: Setup & Authentication**
- Initialize Flutter project
- Set up Firebase project
- Implement authentication (email + Google)
- Create basic app structure and routing

**Days 3-4: AI Detection Engine**
- Integrate Gemini 1.5 Flash API
- Build analysis service
- Implement screenshot upload
- Test AI responses and refine prompts

**Days 5-7: Analysis UI & History**
- Create analysis input page
- Build results display page
- Implement analysis history
- Add risk score visualization

### Week 2: Community, Education & Polish

**Days 8-9: Community Platform**
- Build community post creation
- Implement feed view
- Add upvote/downvote functionality
- Create filtering by scam type

**Days 10-11: Education Hub**
- Create education content (5 guides)
- Build education library UI
- Add navigation and detail pages

**Days 12-14: Testing & Deployment**
- End-to-end testing
- Bug fixes
- UI/UX polish
- Deploy to Vercel
- Write basic documentation

---

## 5. MVP Scope Decisions

### ✅ Included in MVP

- AI fraud detection (core feature)
- Screenshot, text, URL analysis
- Analysis history (last 30)
- Basic community posts
- 5 fraud type guides
- Email + Google authentication
- Responsive web design

### ❌ Excluded from MVP (Future Versions)

- Official government alerts (requires external APIs)
- PDF report downloads
- Email/SMS notifications
- Comments on community posts
- Expert verification badges
- Advanced analytics dashboard
- Multi-language support
- Mobile apps (using Flutter Web only)
- Browser extension
- Sharing analysis results

---

## 6. Success Metrics (MVP)

### Week 1 Post-Launch:
- 50+ registered users
- 200+ analyses performed
- 10+ community posts
- <5 second average analysis time

### Month 1 Post-Launch:
- 500+ registered users
- 2,000+ analyses performed
- 50+ community posts
- 85%+ user satisfaction (informal feedback)

---

## 7. Cost Breakdown (MVP)

| Service | Free Tier Limits | Estimated Usage | Cost |
|---------|-----------------|-----------------|------|
| **Vercel Hosting** | 100GB bandwidth | ~5GB/month | $0 |
| **Firebase Auth** | Unlimited | ~500 users | $0 |
| **Firestore** | 50K reads, 20K writes/day | ~1K reads, 500 writes/day | $0 |
| **Firebase Storage** | 5GB, 1GB/day transfer | ~500MB, 100MB/day | $0 |
| **Gemini 1.5 Flash** | 15 RPM, 1M tokens/min | ~500 requests/day | $0 |
| **Domain** | N/A | Use Vercel subdomain | $0 |
| **Total** | | | **$0/month** |

**Scaling Considerations:**
- If exceeding free tiers, costs would be ~$25-50/month
- Gemini paid tier: $0.075 per 1M input tokens
- Firebase Blaze plan: Pay-as-you-go

---

## 8. Risk Mitigation

### Technical Risks

| Risk | Mitigation |
|------|-----------|
| Gemini API rate limits | Implement request queuing, show "busy" message |
| Firebase free tier exceeded | Monitor usage dashboard, upgrade if needed |
| AI accuracy issues | Refine prompts based on user feedback |
| Slow analysis time | Optimize image compression, use caching |

### User Experience Risks

| Risk | Mitigation |
|------|-----------|
| False positives | Show confidence level, allow user feedback |
| Low community engagement | Seed with initial posts, promote sharing |
| Confusing UI | User testing with 3-5 people before launch |

---

## 9. Post-MVP Roadmap

### Version 1.1 (Month 2)
- Comments on community posts
- PDF report downloads
- Share analysis results
- User profile pages

### Version 1.2 (Month 3)
- Official fraud alerts (FTC, FBI feeds)
- Email notifications
- Advanced analytics dashboard
- Export analysis history

### Version 2.0 (Month 4-6)
- Mobile apps (iOS/Android) using same Flutter codebase
- Browser extension
- Premium tier ($4.99/month)
- API access for developers

---

## 10. Getting Started Checklist

### Before Development:
- [ ] Create Firebase project
- [ ] Get Gemini API key (Google AI Studio)
- [ ] Set up Vercel account
- [ ] Install Flutter SDK
- [ ] Set up code repository (GitHub)

### Development Environment:
- [ ] Flutter 3.16+ installed
- [ ] VS Code or Android Studio
- [ ] Firebase CLI installed
- [ ] Git configured

### Design Assets:
- [ ] Logo (simple, recognizable)
- [ ] Color scheme (use Material Design)
- [ ] 5 fraud type icons

---

## 11. Conclusion

This MVP focuses on delivering the core value proposition—AI-powered fraud detection—with minimal complexity and zero operational costs. By using Flutter for rapid development, Firebase for backend infrastructure, and Gemini for AI capabilities, we can launch a functional product in 2 weeks.

The simplified community and education features provide additional value without requiring complex development. This approach allows for quick user feedback and iterative improvement based on real usage patterns.

**Next Steps:**
1. Review and approve this PRD
2. Set up development environment
3. Create detailed user flow document
4. Begin Week 1 development tasks

---

**Document Version:** 2.0 (MVP)  
**Last Updated:** February 13, 2026  
**Status:** Ready for Development
