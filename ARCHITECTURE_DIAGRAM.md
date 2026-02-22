# AskBeforeAct - System Architecture Diagram

## Interactive Mermaid Flowchart

Copy this code into your README.md or use https://mermaid.live to render it:

```mermaid
graph TB
    %% ============================================
    %% FRONTEND & USER INTERACTION ZONE
    %% ============================================
    subgraph Frontend["🎨 Frontend & User Interaction Layer"]
        User["👤 Vulnerable User<br/>(Elderly/General Public)"]
        FlutterApp["📱 Flutter Web App<br/>(Material Design UI)"]
        
        ActionA["🔍 Action A:<br/>Input Suspicious Content<br/>(Text/URL/Screenshot)"]
        ActionB["👥 Action B:<br/>Browse Community<br/>Scam Alerts"]
        ActionC["📚 Action C:<br/>Access Dynamic<br/>Learn Section"]
        
        User --> FlutterApp
        FlutterApp --> ActionA
        FlutterApp --> ActionB
        FlutterApp --> ActionC
    end

    %% ============================================
    %% CORE PROCESSING & AI ORCHESTRATION ZONE
    %% ============================================
    subgraph Processing["🧠 Core Processing & AI Orchestration (The Brains)"]
        direction TB
        
        %% Action A Flow - Fraud Detection
        Gateway["⚡ Firebase Cloud Functions<br/>(API Gateway + Orchestration)"]
        GeminiAnalysis["🤖 Gemini 2.5 Flash<br/>Multilingual OCR +<br/>Intent Analysis +<br/>Risk Scoring"]
        ThreatUI["🚨 Risk Assessment UI<br/>(Red/Yellow/Green)<br/>+ Red Flags List"]
        PDFGen["📄 PDF Report Generator<br/>(Official Evidence<br/>for Authorities)"]
        
        %% Action B Flow - Community Intelligence
        CommunityData["💬 Community Posts<br/>Aggregation"]
        GeminiSummarize["🤖 Gemini 2.5 Flash<br/>Podcast Script<br/>Generation"]
        AudioGen["🎙️ Gemini TTS<br/>AI Audio/Podcast<br/>Generator"]
        
        %% Action C Flow - Dynamic Education
        NewsAPI["📰 Google News API<br/>(Real-time Scam News<br/>Malaysia/Chinese)"]
        GeminiChatbot["🤖 Gemini 2.5 Flash<br/>Conversational Chatbot<br/>+ News Summarization"]
        InteractiveUI["💡 Interactive Q&A UI<br/>+ Article Summaries"]
        
        %% Connections for Action A
        Gateway --> GeminiAnalysis
        GeminiAnalysis --> ThreatUI
        GeminiAnalysis --> PDFGen
        
        %% Connections for Action B
        CommunityData --> GeminiSummarize
        GeminiSummarize --> AudioGen
        
        %% Connections for Action C
        NewsAPI --> GeminiChatbot
        GeminiChatbot --> InteractiveUI
    end

    %% ============================================
    %% DATA & INFRASTRUCTURE LAYER
    %% ============================================
    subgraph Infrastructure["💾 Data & Infrastructure Layer (Google Cloud)"]
        Firestore["🗄️ Firebase Firestore<br/>(NoSQL Database)<br/>• User Profiles<br/>• Analysis History<br/>• Community Posts<br/>• Podcasts"]
        Storage["📦 Firebase Storage<br/>(CDN + File Storage)<br/>• Screenshots<br/>• PDF Reports<br/>• Audio Files"]
        Analytics["📊 Firebase Analytics<br/>(Usage Tracking)<br/>• User Journeys<br/>• Feature Adoption<br/>• Threat Detection Metrics"]
        CloudScheduler["⏰ Cloud Scheduler<br/>(Automated Jobs)<br/>• News Fetching (6h)<br/>• Podcast Generation"]
    end

    %% ============================================
    %% CROSS-LAYER CONNECTIONS
    %% ============================================
    
    %% Action A to Infrastructure
    ActionA -->|"📤 Multimodal Input<br/>(Text/URL/Image)"| Gateway
    Gateway -->|"💾 Save Analysis"| Firestore
    Gateway -->|"📸 Store Screenshot"| Storage
    ThreatUI -->|"📥 Display Results"| FlutterApp
    PDFGen -->|"💾 Store PDF"| Storage
    PDFGen -->|"⬇️ Download to User"| FlutterApp
    
    %% Action B to Infrastructure
    ActionB -->|"📡 Fetch Posts"| Firestore
    Firestore -->|"📝 Community Data"| CommunityData
    AudioGen -->|"🎵 Store Audio"| Storage
    AudioGen -->|"🔊 Stream to User"| FlutterApp
    
    %% Action C to Infrastructure
    ActionC -->|"🔍 Request News"| CloudScheduler
    CloudScheduler -->|"📰 Fetch Articles"| NewsAPI
    CloudScheduler -->|"💾 Cache News"| Firestore
    InteractiveUI -->|"💬 Display Chat"| FlutterApp
    
    %% Analytics Connections
    FlutterApp -.->|"📈 Track Events"| Analytics
    GeminiAnalysis -.->|"📊 Log Performance"| Analytics
    
    %% Styling
    classDef userStyle fill:#E3F2FD,stroke:#1976D2,stroke-width:3px,color:#000
    classDef flutterStyle fill:#02569B,stroke:#01579B,stroke-width:3px,color:#fff
    classDef actionStyle fill:#FFF9C4,stroke:#F57F17,stroke-width:2px,color:#000
    classDef geminiStyle fill:#4285F4,stroke:#1967D2,stroke-width:4px,color:#fff,font-weight:bold
    classDef firebaseStyle fill:#FFCA28,stroke:#F57C00,stroke-width:3px,color:#000
    classDef dataStyle fill:#C8E6C9,stroke:#388E3C,stroke-width:3px,color:#000
    classDef uiStyle fill:#F8BBD0,stroke:#C2185B,stroke-width:2px,color:#000
    
    class User userStyle
    class FlutterApp flutterStyle
    class ActionA,ActionB,ActionC actionStyle
    class GeminiAnalysis,GeminiSummarize,GeminiChatbot,AudioGen geminiStyle
    class Gateway,CloudScheduler firebaseStyle
    class Firestore,Storage,Analytics dataStyle
    class ThreatUI,PDFGen,InteractiveUI uiStyle
```

---

## Simplified Version (For Presentations)

If you need a cleaner, more compact version for slides:

```mermaid
graph LR
    %% User Journey
    User["👤 User"] --> Flutter["📱 Flutter Web"]
    
    %% Three Main Flows
    Flutter -->|"🔍 Analyze Content"| Gemini1["🤖 Gemini<br/>Fraud Detection"]
    Flutter -->|"👥 Community"| Gemini2["🤖 Gemini<br/>Podcast Gen"]
    Flutter -->|"📚 Learn"| Gemini3["🤖 Gemini<br/>Chatbot"]
    
    %% Results
    Gemini1 --> Results["🚨 Risk Report<br/>+ PDF"]
    Gemini2 --> Audio["🎙️ Audio<br/>Summary"]
    Gemini3 --> Chat["💬 Interactive<br/>Q&A"]
    
    %% Storage
    Gemini1 & Gemini2 & Gemini3 --> Firebase["💾 Firebase<br/>(Firestore + Storage)"]
    
    %% Styling
    classDef ai fill:#4285F4,stroke:#1967D2,stroke-width:3px,color:#fff
    classDef storage fill:#FFCA28,stroke:#F57C00,stroke-width:3px,color:#000
    
    class Gemini1,Gemini2,Gemini3 ai
    class Firebase storage
```

---

## Alternative: Horizontal Flow (Left-to-Right Story)

Perfect for wide presentations or documentation:

```mermaid
graph LR
    %% ============================================
    %% ZONE 1: USER INTERACTION
    %% ============================================
    subgraph Z1["🎨 User Interaction"]
        direction TB
        U["👤 Vulnerable<br/>User"]
        F["📱 Flutter<br/>Web App"]
        U --> F
    end
    
    %% ============================================
    %% ZONE 2: USER ACTIONS
    %% ============================================
    subgraph Z2["⚡ User Actions"]
        direction TB
        A1["🔍 Analyze<br/>Suspicious<br/>Content"]
        A2["👥 Browse<br/>Community<br/>Alerts"]
        A3["📚 Access<br/>Learn<br/>Section"]
    end
    
    %% ============================================
    %% ZONE 3: AI PROCESSING
    %% ============================================
    subgraph Z3["🧠 AI Processing (Gemini 2.5 Flash)"]
        direction TB
        G1["🤖 Fraud<br/>Detection<br/>+ OCR"]
        G2["🤖 Podcast<br/>Script<br/>Generation"]
        G3["🤖 Chatbot<br/>+ News<br/>Summary"]
    end
    
    %% ============================================
    %% ZONE 4: OUTPUTS
    %% ============================================
    subgraph Z4["📤 User Outputs"]
        direction TB
        O1["🚨 Risk Score<br/>+ PDF Report"]
        O2["🎙️ Audio<br/>Podcast"]
        O3["💬 Interactive<br/>Q&A"]
    end
    
    %% ============================================
    %% ZONE 5: INFRASTRUCTURE
    %% ============================================
    subgraph Z5["💾 Firebase Infrastructure"]
        direction TB
        DB["🗄️ Firestore<br/>(Database)"]
        ST["📦 Storage<br/>(Files)"]
        AN["📊 Analytics<br/>(Metrics)"]
    end
    
    %% Connections
    F --> A1 & A2 & A3
    A1 --> G1
    A2 --> G2
    A3 --> G3
    G1 --> O1
    G2 --> O2
    G3 --> O3
    O1 & O2 & O3 --> F
    G1 & G2 & G3 --> DB
    G1 --> ST
    F -.-> AN
    
    %% Styling
    classDef aiNode fill:#4285F4,stroke:#1967D2,stroke-width:4px,color:#fff
    classDef dbNode fill:#FFCA28,stroke:#F57C00,stroke-width:3px,color:#000
    classDef userNode fill:#E3F2FD,stroke:#1976D2,stroke-width:2px,color:#000
    
    class G1,G2,G3 aiNode
    class DB,ST,AN dbNode
    class U,F userNode
```

---

## Data Flow Sequence Diagram

For showing the exact sequence of operations:

```mermaid
sequenceDiagram
    participant User as 👤 User
    participant Flutter as 📱 Flutter App
    participant Firebase as ⚡ Cloud Functions
    participant Gemini as 🤖 Gemini AI
    participant DB as 💾 Firestore
    participant Storage as 📦 Storage
    
    %% Fraud Detection Flow
    User->>Flutter: Upload suspicious screenshot
    Flutter->>Firebase: Send image + metadata
    Firebase->>Storage: Store screenshot
    Storage-->>Firebase: Return image URL
    Firebase->>Gemini: Analyze image (OCR + Intent)
    Gemini-->>Firebase: Risk score + red flags
    Firebase->>DB: Save analysis result
    Firebase->>Flutter: Return threat assessment
    Flutter->>User: Display risk level + PDF option
    
    %% PDF Generation
    User->>Flutter: Request PDF report
    Flutter->>Firebase: Generate PDF
    Firebase->>Storage: Store PDF
    Storage-->>Flutter: Download link
    Flutter->>User: Download PDF evidence
    
    %% Community Podcast Flow
    User->>Flutter: Request community summary
    Flutter->>DB: Fetch recent posts
    DB-->>Firebase: Community data
    Firebase->>Gemini: Generate podcast script
    Gemini-->>Firebase: Conversational script
    Firebase->>Gemini: Convert to audio (TTS)
    Gemini-->>Storage: Audio file
    Storage-->>Flutter: Stream audio
    Flutter->>User: Play podcast
```

---

## Technology Stack Visualization

```mermaid
graph TB
    subgraph Frontend["Frontend Layer"]
        F1["Flutter Web<br/>(Dart)"]
        F2["Provider<br/>(State Management)"]
        F3["Material Design<br/>(UI Components)"]
    end
    
    subgraph Backend["Backend Layer"]
        B1["Firebase Cloud Functions<br/>(Serverless API)"]
        B2["Firebase Firestore<br/>(NoSQL Database)"]
        B3["Firebase Storage<br/>(File Storage + CDN)"]
        B4["Firebase Auth<br/>(Email + Google OAuth)"]
    end
    
    subgraph AI["AI/ML Layer"]
        A1["Gemini 2.5 Flash<br/>(Fraud Detection)"]
        A2["Gemini 2.5 Flash<br/>(Content Generation)"]
        A3["Gemini TTS<br/>(Text-to-Speech)"]
    end
    
    subgraph External["External Services"]
        E1["Google News API<br/>(Real-time Scam News)"]
        E2["Cloud Scheduler<br/>(Automated Jobs)"]
    end
    
    Frontend --> Backend
    Backend --> AI
    Backend --> External
    
    classDef frontendStyle fill:#02569B,stroke:#01579B,stroke-width:3px,color:#fff
    classDef backendStyle fill:#FFCA28,stroke:#F57C00,stroke-width:3px,color:#000
    classDef aiStyle fill:#4285F4,stroke:#1967D2,stroke-width:4px,color:#fff
    classDef externalStyle fill:#34A853,stroke:#0F9D58,stroke-width:3px,color:#fff
    
    class F1,F2,F3 frontendStyle
    class B1,B2,B3,B4 backendStyle
    class A1,A2,A3 aiStyle
    class E1,E2 externalStyle
```

---

## How to Use These Diagrams

### 1. **In GitHub README.md**
Simply paste the mermaid code blocks directly into your README:

````markdown
## System Architecture

```mermaid
graph TB
    [paste the mermaid code here]
```
````

### 2. **In Hackathon Submission Documents**
- Copy the code to https://mermaid.live
- Click "Export" → PNG or SVG
- Insert the image into your submission PDF/slides

### 3. **In Presentations**
- Use the "Simplified Version" for overview slides
- Use the "Detailed Version" for technical deep-dives
- Use the "Sequence Diagram" to explain user journeys

### 4. **For Documentation**
- The detailed version works great in technical documentation
- The horizontal flow is perfect for wide-format docs

---

## Customization Tips

**To change colors**, modify the `classDef` lines:
```mermaid
classDef myStyle fill:#YOUR_COLOR,stroke:#BORDER_COLOR,stroke-width:3px
```

**To add more details**, insert new nodes:
```mermaid
NewNode["📌 Your Feature<br/>(Description)"]
```

**To change layout direction**:
- `graph TB` = Top to Bottom
- `graph LR` = Left to Right
- `graph TD` = Top Down (same as TB)

---

## Pro Tips for Hackathon Judges

1. **Use the detailed version** in your technical documentation
2. **Use the simplified version** in your pitch deck
3. **Use the sequence diagram** to explain user flows
4. **Export as SVG** for crisp, scalable images
5. **Add your brand colors** to match your app theme

The diagrams clearly show:
✅ Multi-modal AI capabilities (Gemini handling text, images, audio)
✅ Real-time data processing (Firebase integration)
✅ User-centric design (three distinct user actions)
✅ Scalable architecture (serverless Firebase backend)
✅ Complete data flow (from input to output)

Perfect for demonstrating technical sophistication to judges! 🚀
