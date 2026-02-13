# AskBeforeAct (ABA)

AI-powered fraud detection web application built with Flutter and Firebase.

## 🚀 Features

- 🤖 AI-powered fraud detection using Gemini 1.5 Flash
- 📸 Analyze screenshots, text, and URLs
- 📊 Instant risk scoring and recommendations
- 👥 Community platform for sharing experiences
- 📚 Educational resources about fraud types

## 🛠️ Tech Stack

- **Frontend:** Flutter Web
- **Backend:** Firebase (Auth, Firestore, Storage)
- **AI:** Google Gemini 1.5 Flash
- **Hosting:** Vercel
- **State Management:** Provider (MVVM pattern)

## 📁 Project Structure

```
lib/
├── core/               # Core utilities and constants
│   ├── constants/     # Colors, strings, routes
│   ├── theme/         # App theme configuration
│   ├── utils/         # Validators, formatters, helpers
│   ├── config/        # Environment configuration
│   └── exceptions/    # Custom exceptions
├── models/            # Data models
├── services/          # External services (Firebase, AI)
├── repositories/      # Data access layer
├── viewmodels/        # Business logic (MVVM)
├── views/             # UI screens
└── widgets/           # Reusable widgets
```

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **View:** UI components (`views/` and `widgets/`)
- **ViewModel:** Business logic and state management (`viewmodels/`)
- **Model:** Data layer (`models/`, `repositories/`, `services/`)

## 🚦 Getting Started

### Prerequisites

- Flutter SDK 3.16+
- Dart SDK 3.2+
- Firebase account
- Gemini API key

### Installation

1. Clone the repository
```bash
git clone <repo-url>
cd askbeforeact
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase
```bash
flutterfire configure
```

4. Create `.env` file
```bash
cp .env.example .env
# Add your Gemini API key
```

5. Run the app
```bash
flutter run -d chrome
```

## 📝 Development Timeline

- **Week 1:** Core infrastructure + AI detection
- **Week 2:** Community, education, polish & deployment

## 📚 Documentation

See the root directory for detailed documentation:
- `01_PRD_MVP.md` - Product Requirements
- `02_USER_FLOW.md` - User flows and page structure
- `03_TECH_STACK.md` - Technical specifications
- `04_FRONTEND_GUIDELINES.md` - Coding standards
- `05_BACKEND_STRUCTURE.md` - Backend architecture
- `06_FILE_STRUCTURE.md` - Project organization

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widgets/

# Run integration tests
flutter test integration_test/
```

## 🚀 Deployment

### Build for production
```bash
flutter build web --release
```

### Deploy to Vercel
```bash
vercel --prod
```

## 📄 License

MIT License

## 👨‍💻 Author

Your Name - [GitHub](https://github.com/yourusername)
