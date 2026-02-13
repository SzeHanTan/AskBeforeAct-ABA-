# AskBeforeAct (ABA) - User Flow Document
## Complete Page-by-Page Application Flow

**Version:** 1.0  
**Last Updated:** February 13, 2026  

---

## Table of Contents

1. [User Journey Overview](#1-user-journey-overview)
2. [Page-by-Page Breakdown](#2-page-by-page-breakdown)
3. [Navigation Structure](#3-navigation-structure)
4. [User Flows by Scenario](#4-user-flows-by-scenario)
5. [Interaction Patterns](#5-interaction-patterns)

---

## 1. User Journey Overview

### 1.1 Primary User Journeys

```
New User Journey:
Landing Page → Sign Up → Onboarding → Analysis → Results → History

Returning User Journey:
Login → Dashboard → Analysis → Results → Community

Anonymous User Journey:
Landing Page → Analysis (limited) → Sign Up Prompt
```

### 1.2 User Types

| User Type | Access Level | Limitations |
|-----------|-------------|-------------|
| **Anonymous** | Limited | 3 analyses max, no history, no community posts |
| **Registered** | Full | Unlimited analyses, full history, community access |
| **Admin** | Full + Moderation | All features + content moderation |

---

## 2. Page-by-Page Breakdown

### Page 1: Landing Page (`/`)

**Purpose:** Introduce the app and encourage sign-up or immediate analysis

**Components:**

1. **Hero Section**
   - App logo and name: "AskBeforeAct"
   - Tagline: "Detect Online Fraud Before It's Too Late"
   - Primary CTA: "Analyze Now" (blue button)
   - Secondary CTA: "Sign Up Free" (outlined button)
   - Hero image: Illustration of person with phone and shield

2. **How It Works** (3 steps)
   - Step 1: Upload screenshot, paste text, or enter URL
   - Step 2: AI analyzes content in seconds
   - Step 3: Get risk score and recommendations
   - Each step has icon + short description

3. **Feature Highlights** (3 cards)
   - 🤖 AI-Powered Detection
   - 📊 Instant Risk Scoring
   - 👥 Community Insights

4. **Example Analysis Preview**
   - Show sample analysis result (blurred)
   - "See how it works" button → scrolls to demo

5. **Trust Indicators**
   - "Powered by Google Gemini AI"
   - "100% Free to Use"
   - "Your Privacy Protected"

6. **Footer**
   - Links: About, Privacy Policy, Terms of Service
   - Social media icons (if applicable)
   - Copyright notice

**Actions:**
- Click "Analyze Now" → Navigate to `/analyze` (if logged in) or `/login` (if not)
- Click "Sign Up Free" → Navigate to `/signup`
- Scroll down to explore features

**Navigation Bar:**
- Logo (left) → Home
- Links: Home | Analyze | Community | Education
- Right side: "Login" | "Sign Up" buttons

---

### Page 2: Sign Up Page (`/signup`)

**Purpose:** Create new user account

**Components:**

1. **Sign Up Form**
   - Page title: "Create Your Account"
   - Subtitle: "Start protecting yourself from online fraud"
   
2. **Input Fields:**
   - Full Name (text input)
   - Email Address (email input)
   - Password (password input, show/hide toggle)
   - Confirm Password (password input)
   
3. **Password Requirements:**
   - Minimum 8 characters
   - At least one number
   - At least one uppercase letter
   - Visual indicators (✓/✗) as user types

4. **Social Sign-Up:**
   - "Or sign up with:"
   - Google button (with Google logo)
   
5. **Terms Acceptance:**
   - Checkbox: "I agree to the Terms of Service and Privacy Policy"
   - Links open in new tab

6. **Submit Button:**
   - "Create Account" (disabled until form valid)

7. **Alternative Action:**
   - "Already have an account? Log in"

**Actions:**
- Fill form → Click "Create Account" → Navigate to `/onboarding`
- Click "Sign up with Google" → Google OAuth → Navigate to `/onboarding`
- Click "Log in" link → Navigate to `/login`

**Validation:**
- Real-time email format validation
- Password strength indicator
- Matching password confirmation
- Show error messages below fields

---

### Page 3: Login Page (`/login`)

**Purpose:** Authenticate existing users

**Components:**

1. **Login Form**
   - Page title: "Welcome Back"
   - Subtitle: "Log in to continue protecting yourself"

2. **Input Fields:**
   - Email Address
   - Password (with show/hide toggle)

3. **Additional Options:**
   - "Remember me" checkbox
   - "Forgot password?" link (right-aligned)

4. **Social Login:**
   - "Or log in with:"
   - Google button

5. **Submit Button:**
   - "Log In"

6. **Alternative Action:**
   - "Don't have an account? Sign up"

7. **Anonymous Option:**
   - "Continue as Guest" link (bottom)
   - Small text: "Limited to 3 analyses"

**Actions:**
- Enter credentials → Click "Log In" → Navigate to `/dashboard`
- Click "Sign in with Google" → Google OAuth → Navigate to `/dashboard`
- Click "Sign up" link → Navigate to `/signup`
- Click "Continue as Guest" → Navigate to `/analyze` (anonymous mode)
- Click "Forgot password?" → Navigate to `/reset-password`

**Error Handling:**
- Invalid credentials: Show error banner
- Account not found: Suggest sign up
- Too many attempts: Temporary lockout message

---

### Page 4: Onboarding (`/onboarding`)

**Purpose:** Welcome new users and explain key features

**Components:**

1. **Welcome Screen (Slide 1)**
   - "Welcome to AskBeforeAct! 👋"
   - Brief introduction
   - User's name displayed
   - "Next" button

2. **Feature Tour (Slides 2-4)**
   - Slide 2: "Analyze Suspicious Content"
     - Screenshot of analysis page
     - "Upload screenshots, paste text, or check URLs"
   
   - Slide 3: "Get Instant Results"
     - Screenshot of results page
     - "AI-powered risk scoring and recommendations"
   
   - Slide 4: "Join the Community"
     - Screenshot of community page
     - "Share experiences and learn from others"

3. **Progress Indicators:**
   - Dots showing current slide (1/4, 2/4, etc.)
   - "Skip" button (top right)

4. **Final Screen:**
   - "You're All Set! 🎉"
   - "Get Started" button

**Actions:**
- Click "Next" → Advance to next slide
- Click "Skip" → Navigate to `/dashboard`
- Click "Get Started" → Navigate to `/dashboard`

**Note:** Show only once per user (store in Firestore)

---

### Page 5: Dashboard (`/dashboard`)

**Purpose:** Main hub for logged-in users

**Components:**

1. **Welcome Header**
   - "Welcome back, [User Name]!"
   - Current date and time

2. **Quick Stats Cards** (3 cards in row)
   - Total Analyses: [number]
   - High Risk Detected: [number]
   - Community Posts: [number]

3. **Quick Action Section**
   - Large card: "Analyze New Content"
   - Three buttons:
     - 📸 Upload Screenshot
     - 📝 Paste Text
     - 🔗 Check URL
   - Each button → Navigate to `/analyze` with pre-selected tab

4. **Recent Analyses** (List)
   - Title: "Your Recent Analyses"
   - Show last 5 analyses
   - Each item shows:
     - Risk badge (colored)
     - Scam type
     - Date (relative: "2 hours ago")
     - Preview text (truncated)
   - Click item → Navigate to `/analysis/[id]`
   - "View All" link → Navigate to `/history`

5. **Community Highlights**
   - Title: "Latest from Community"
   - Show 3 recent posts
   - Click post → Navigate to `/community/post/[id]`
   - "View All" link → Navigate to `/community`

**Navigation:**
- Top app bar with navigation menu
- Bottom navigation (mobile): Home | Analyze | Community | Profile

**Actions:**
- Click analysis card → View details
- Click "Analyze New Content" → Navigate to `/analyze`
- Click community post → View post details

---

### Page 6: Analysis Page (`/analyze`)

**Purpose:** Input content for fraud detection

**Components:**

1. **Page Header**
   - Title: "Analyze Suspicious Content"
   - Subtitle: "Upload, paste, or enter content to check for fraud"

2. **Tab Selector** (3 tabs)
   - 📸 Screenshot
   - 📝 Text
   - 🔗 URL

3. **Tab 1: Screenshot Upload**
   - Drag-and-drop zone
     - "Drag and drop your screenshot here"
     - "or click to browse"
   - Supported formats: JPG, PNG (max 5MB)
   - Preview thumbnail after upload
   - "Remove" button to clear
   - "Analyze" button (blue, prominent)

4. **Tab 2: Text Input**
   - Large text area (8 rows)
   - Placeholder: "Paste the suspicious email, message, or content here..."
   - Character count: [X]/5000
   - "Clear" button
   - "Analyze" button

5. **Tab 3: URL Input**
   - Single text input field
   - Placeholder: "https://suspicious-website.com"
   - URL format validation
   - "Analyze" button

6. **Loading State**
   - Show spinner overlay when analyzing
   - "Analyzing content..." message
   - "This may take 5-10 seconds"
   - Animated progress indicator

7. **Anonymous User Banner** (if not logged in)
   - "You have [X] analyses remaining"
   - "Sign up for unlimited analyses"
   - Dismiss button

**Actions:**
- Select tab → Switch input method
- Upload file → Show preview
- Click "Analyze" → Send to AI → Navigate to `/results/[id]`
- If anonymous and limit reached → Show modal with sign-up prompt

**Validation:**
- Screenshot: Check file size and format
- Text: Minimum 20 characters
- URL: Valid URL format
- Show error messages if validation fails

---

### Page 7: Results Page (`/results/[id]`)

**Purpose:** Display fraud analysis results

**Components:**

1. **Risk Score Header** (Large, prominent)
   - Circular progress indicator (0-100%)
   - Color-coded:
     - Green (0-30%): "Low Risk"
     - Yellow (31-70%): "Medium Risk"
     - Red (71-100%): "High Risk"
   - Large percentage number
   - Risk level text

2. **Scam Type Badge**
   - Icon + label
   - Examples: "Phishing Email", "Romance Scam", "Payment Fraud"

3. **Red Flags Section**
   - Title: "⚠️ Red Flags Detected"
   - Numbered list of specific indicators
   - Each item with brief explanation
   - Example: "1. Urgent language demanding immediate action"

4. **Recommendations Section**
   - Title: "✅ What You Should Do"
   - Numbered list of actionable steps
   - Priority ordered (most important first)
   - Example: "1. Do not click any links in this message"

5. **Content Preview**
   - Title: "Analyzed Content"
   - Show original content (truncated if long)
   - For screenshots: Show thumbnail
   - "View Full Content" expandable section

6. **Confidence Indicator**
   - "AI Confidence: High/Medium/Low"
   - Small info icon with tooltip

7. **Action Buttons** (Bottom)
   - 💾 "Save to History" (if not auto-saved)
   - 🔄 "Analyze Another"
   - 📤 "Share Results" (future feature, grayed out)

8. **Feedback Section**
   - "Was this analysis helpful?"
   - 👍 Helpful | 👎 Not Helpful
   - Optional text: "Tell us more" (expandable)

**Actions:**
- Click "Analyze Another" → Navigate to `/analyze`
- Click "View Full Content" → Expand section
- Click feedback buttons → Submit feedback to Firestore
- Auto-save to history (if logged in)

**Edge Cases:**
- If analysis fails: Show error message with retry button
- If low confidence: Show disclaimer

---

### Page 8: History Page (`/history`)

**Purpose:** View all past analyses

**Components:**

1. **Page Header**
   - Title: "Analysis History"
   - Subtitle: "View your past fraud checks"

2. **Summary Stats Bar**
   - Total Analyses: [number]
   - High Risk: [number] ([percentage]%)
   - Most Common Type: [scam type]

3. **Filter Controls**
   - Dropdown: "All Types" | Phishing | Romance | Payment | Job | Other
   - Date range: "Last 7 days" | "Last 30 days" | "All time"
   - Search box: "Search analyses..."

4. **Analysis List** (Cards)
   - Each card shows:
     - Risk badge (colored circle with percentage)
     - Scam type icon + label
     - Date and time
     - First 100 characters of content
     - "View Details" button
   - Sort: Most recent first
   - Pagination: 10 per page

5. **Empty State** (if no analyses)
   - Illustration
   - "No analyses yet"
   - "Start by analyzing suspicious content"
   - "Analyze Now" button → Navigate to `/analyze`

**Actions:**
- Click card → Navigate to `/analysis/[id]` (detail view)
- Change filter → Reload list with filtered results
- Click "Analyze Now" → Navigate to `/analyze`

**Data Loading:**
- Show skeleton loaders while fetching
- Infinite scroll or pagination

---

### Page 9: Analysis Detail Page (`/analysis/[id]`)

**Purpose:** View full details of a specific past analysis

**Components:**

1. **Back Button**
   - "← Back to History"

2. **Content Layout:**
   - Same as Results Page (Page 7)
   - Additional info: "Analyzed on [date]"

3. **Delete Option**
   - "Delete Analysis" button (bottom, red text)
   - Confirmation modal: "Are you sure?"

**Actions:**
- Click "Back" → Navigate to `/history`
- Click "Delete" → Show confirmation → Delete from Firestore → Navigate to `/history`

---

### Page 10: Community Page (`/community`)

**Purpose:** View and share scam experiences

**Components:**

1. **Page Header**
   - Title: "Community"
   - Subtitle: "Share and learn from others' experiences"

2. **Create Post Button** (Floating Action Button)
   - "+" icon
   - Fixed position (bottom right)
   - Click → Open post creation modal

3. **Filter Tabs**
   - All | Phishing | Romance | Payment | Job | Other
   - Active tab highlighted

4. **Post Feed** (List of cards)
   - Each post card shows:
     - User name (or "Anonymous User")
     - Scam type badge
     - Post content (max 500 chars)
     - Timestamp (relative: "3 hours ago")
     - Upvote/downvote buttons with counts
     - 🚩 Report button (small, right side)
   - Sort: Most recent first
   - Load more on scroll

5. **Empty State** (if no posts)
   - "No posts yet in this category"
   - "Be the first to share your experience"

**Actions:**
- Click "+" → Open create post modal
- Click upvote → Increment count (one per user)
- Click downvote → Decrement count
- Click report → Show report modal
- Filter by tab → Reload feed

---

### Page 11: Create Post Modal (`/community` - modal)

**Purpose:** Submit new community post

**Components:**

1. **Modal Header**
   - Title: "Share Your Experience"
   - Close button (X)

2. **Form Fields:**
   - Scam Type dropdown
     - Options: Phishing | Romance | Payment | Job | Tech Support | Other
   - Text area (500 char limit)
     - Placeholder: "Describe what happened and how you identified it as a scam..."
   - Character counter: [X]/500

3. **Anonymous Option**
   - Checkbox: "Post anonymously"
   - Info tooltip: "Your name won't be shown"

4. **Guidelines** (collapsible)
   - "Community Guidelines"
   - Brief rules (3-4 bullet points)

5. **Action Buttons**
   - "Cancel" (gray)
   - "Post" (blue, disabled until valid)

**Actions:**
- Fill form → Click "Post" → Submit to Firestore → Close modal → Refresh feed
- Click "Cancel" → Close modal without saving
- Click outside modal → Close modal

**Validation:**
- Minimum 50 characters
- Scam type must be selected
- Show error messages

---

### Page 12: Education Page (`/education`)

**Purpose:** Learn about different fraud types

**Components:**

1. **Page Header**
   - Title: "Fraud Education"
   - Subtitle: "Learn to identify and prevent online scams"

2. **Search Bar**
   - "Search fraud types..."
   - Filter guides as user types

3. **Fraud Type Cards** (Grid layout, 2-3 columns)
   - 5 cards total:
     1. Phishing Emails
     2. Romance Scams
     3. Payment Fraud
     4. Job Scams
     5. Tech Support Scams
   
   - Each card shows:
     - Icon
     - Title
     - Brief description (1 sentence)
     - "Learn More" button

4. **Featured Tips Section**
   - "Quick Tips to Stay Safe"
   - 3-4 general tips (bullet points)

**Actions:**
- Click card → Navigate to `/education/[scamType]`
- Search → Filter visible cards

---

### Page 13: Education Detail Page (`/education/[scamType]`)

**Purpose:** Detailed information about specific fraud type

**Components:**

1. **Back Button**
   - "← Back to Education"

2. **Header**
   - Large icon
   - Title (e.g., "Phishing Emails")
   - Brief description paragraph

3. **Warning Signs Section**
   - Title: "⚠️ Warning Signs"
   - Bullet list (5-7 items)
   - Each with brief explanation

4. **Prevention Tips Section**
   - Title: "🛡️ How to Protect Yourself"
   - Numbered list (5-7 items)
   - Actionable advice

5. **Real Example Section**
   - Title: "📧 Real Example"
   - Text box with example scam message
   - Annotations highlighting red flags

6. **Related Resources**
   - Links to other fraud types
   - External resources (FBI, FTC)

7. **Action Button**
   - "Analyze Suspicious Content" → Navigate to `/analyze`

**Actions:**
- Click "Back" → Navigate to `/education`
- Click related resource → Navigate to that guide
- Click external link → Open in new tab

---

### Page 14: Profile Page (`/profile`)

**Purpose:** View and edit user profile

**Components:**

1. **Profile Header**
   - Avatar (initials or uploaded image)
   - User name
   - Email address
   - Member since date

2. **Statistics Section**
   - Total Analyses: [number]
   - Community Posts: [number]
   - Helpful Votes Received: [number]

3. **Account Settings**
   - Edit Name (text input)
   - Change Email (text input)
   - Change Password button → Modal
   - "Save Changes" button

4. **Preferences**
   - Email notifications toggle (future feature)
   - Theme: Light/Dark (future feature)

5. **Danger Zone**
   - "Delete Account" button (red)
   - Confirmation required

6. **Logout Button**
   - "Log Out" (bottom)

**Actions:**
- Edit fields → Click "Save" → Update Firestore
- Click "Change Password" → Open password change modal
- Click "Delete Account" → Show confirmation → Delete user data
- Click "Log Out" → Sign out → Navigate to `/`

---

### Page 15: Password Reset Page (`/reset-password`)

**Purpose:** Reset forgotten password

**Components:**

1. **Header**
   - Title: "Reset Password"
   - Subtitle: "Enter your email to receive reset instructions"

2. **Form**
   - Email input
   - "Send Reset Link" button

3. **Success State**
   - "Check your email!"
   - "We've sent password reset instructions"
   - "Back to Login" link

4. **Error State**
   - "Email not found"
   - "Please check and try again"

**Actions:**
- Enter email → Click "Send" → Firebase sends reset email → Show success
- Click "Back to Login" → Navigate to `/login`

---

## 3. Navigation Structure

### 3.1 Top Navigation Bar (Desktop)

```
[Logo] AskBeforeAct    Home | Analyze | Community | Education    [Login] [Sign Up]
                                                                   (or [Profile] [Logout] if logged in)
```

### 3.2 Bottom Navigation (Mobile)

```
[🏠 Home]  [🔍 Analyze]  [👥 Community]  [👤 Profile]
```

### 3.3 Hamburger Menu (Mobile)

- Home
- Analyze
- History
- Community
- Education
- Profile
- Logout

---

## 4. User Flows by Scenario

### Scenario 1: First-Time User Analyzing Content

```
1. Land on homepage (/)
2. Click "Analyze Now"
3. Redirected to /login with message "Sign up to continue"
4. Click "Sign Up"
5. Fill registration form (/signup)
6. Complete onboarding (/onboarding)
7. Arrive at dashboard (/dashboard)
8. Click "Analyze New Content"
9. Upload screenshot (/analyze)
10. View results (/results/[id])
11. Results auto-saved to history
```

### Scenario 2: Anonymous User (Quick Analysis)

```
1. Land on homepage (/)
2. Click "Analyze Now"
3. Click "Continue as Guest" on login page
4. Upload content (/analyze)
5. View results (/results/[id])
6. See banner: "2 analyses remaining"
7. After 3rd analysis: Modal "Sign up to continue"
```

### Scenario 3: Returning User Checking History

```
1. Navigate to site
2. Auto-login (if remembered)
3. Arrive at dashboard (/dashboard)
4. Click "View All" under Recent Analyses
5. Browse history (/history)
6. Filter by "High Risk"
7. Click specific analysis
8. View details (/analysis/[id])
```

### Scenario 4: User Sharing Community Experience

```
1. Navigate to Community (/community)
2. Click "+" floating button
3. Modal opens
4. Select scam type: "Romance"
5. Write experience (300 chars)
6. Click "Post"
7. Post appears at top of feed
8. Other users upvote
```

### Scenario 5: User Learning About Fraud Types

```
1. Click "Education" in nav
2. Browse fraud type cards (/education)
3. Click "Phishing Emails"
4. Read detailed guide (/education/phishing)
5. See warning signs and tips
6. Click "Analyze Suspicious Content"
7. Redirected to /analyze
```

---

## 5. Interaction Patterns

### 5.1 Loading States

- **Initial page load:** Full-page skeleton loader
- **Data fetching:** Spinner in content area
- **Button actions:** Button shows spinner, text changes to "Loading..."
- **Image upload:** Progress bar (0-100%)

### 5.2 Error Handling

- **Network errors:** Toast notification at top: "Connection lost. Retrying..."
- **Validation errors:** Red text below input field
- **API errors:** Modal with error message and "Try Again" button
- **404 errors:** Full-page "Page not found" with "Go Home" button

### 5.3 Success Feedback

- **Form submission:** Green toast: "✓ Saved successfully"
- **Post creation:** Green banner: "Post shared with community"
- **Analysis complete:** Smooth transition to results page

### 5.4 Confirmations

- **Destructive actions:** Modal with "Are you sure?" and two buttons
  - Example: Delete account, delete analysis
- **Leaving unsaved form:** Browser prompt: "You have unsaved changes"

### 5.5 Responsive Behavior

| Screen Size | Layout Changes |
|-------------|----------------|
| **Mobile (<640px)** | Single column, bottom nav, hamburger menu |
| **Tablet (640-1024px)** | Two columns for cards, top nav visible |
| **Desktop (>1024px)** | Three columns, sidebar for filters, full nav |

---

## 6. Key User Interactions Summary

| Page | Primary Action | Secondary Actions |
|------|---------------|-------------------|
| Landing | Sign Up | Analyze Now, Learn More |
| Sign Up | Create Account | Sign up with Google |
| Login | Log In | Continue as Guest, Forgot Password |
| Dashboard | Analyze New Content | View History, View Community |
| Analyze | Analyze Button | Switch tabs, Upload file |
| Results | View Recommendations | Analyze Another, Save |
| History | View Analysis | Filter, Search |
| Community | Create Post | Upvote, Filter |
| Education | Read Guide | Analyze Content |
| Profile | Save Changes | Log Out, Delete Account |

---

## 7. Navigation Flow Diagram

```
                    Landing (/)
                        |
        +---------------+---------------+
        |                               |
    Sign Up (/signup)              Login (/login)
        |                               |
    Onboarding                     Dashboard
    (/onboarding)                  (/dashboard)
        |                               |
        +---------------+---------------+
                        |
            +-----------+-----------+-----------+
            |           |           |           |
        Analyze     History    Community   Education
        (/analyze)  (/history) (/community) (/education)
            |           |           |           |
        Results     Detail      Post        Detail
        (/results)  (/analysis) (modal)     (/education/[type])
            |
        History
        (auto-save)
```

---

## 8. Mobile-Specific Considerations

### Gestures:
- **Swipe left/right:** Navigate between tabs on analyze page
- **Pull down:** Refresh community feed
- **Long press:** Show context menu (future: delete, share)

### Touch Targets:
- Minimum 44x44px for all buttons
- Adequate spacing between clickable elements
- Large input fields for easy typing

### Mobile Optimizations:
- Compress images before upload
- Lazy load community posts
- Cache recent analyses locally
- Offline mode for viewing history (future)

---

## Conclusion

This user flow document provides a complete page-by-page breakdown of the AskBeforeAct MVP application. Each page is designed for simplicity and clarity, ensuring users can quickly accomplish their goals:

1. **Analyze suspicious content** (core feature)
2. **View analysis history**
3. **Share and learn from community**
4. **Educate themselves about fraud**

The navigation is intuitive, with clear pathways between features and minimal clicks to reach any page. The responsive design ensures a consistent experience across devices.

---

**Next Steps:**
1. Create wireframes/mockups based on this flow
2. Validate flow with user testing (3-5 people)
3. Begin frontend development following this structure

**Document Version:** 1.0  
**Status:** Ready for Development
