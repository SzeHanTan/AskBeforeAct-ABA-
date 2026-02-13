# Quick Start Guide

## 🚀 Getting Started

### Prerequisites

Make sure you have Flutter installed:
```bash
flutter --version
```

If not installed, download from: https://flutter.dev/docs/get-started/install

### Installation

1. **Navigate to the project directory:**
```bash
cd askbeforeact
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app in Chrome:**
```bash
flutter run -d chrome
```

The app should open in your default browser at `http://localhost:XXXXX`

## 📱 Available Screens

### 1. Landing Screen
- **Route**: `/` (default)
- **Description**: Welcome page with app overview
- **Features**: Hero section, features, how it works

### 2. Analysis Screen
- **Route**: `/analyze`
- **Description**: Main fraud detection interface
- **Features**: Screenshot upload, text input, URL check

### 3. Dashboard Screen
- **Description**: Main navigation hub
- **Features**: Bottom navigation with 4 tabs

### 4. Results Screen
- **Description**: Display analysis results
- **Features**: Risk score, warnings, recommendations

### 5. Education Screen
- **Description**: Learn about fraud types
- **Features**: 5 fraud type guides

### 6. Community Screen
- **Description**: Share experiences
- **Features**: Post feed, filtering

### 7. Profile Screen
- **Description**: User profile and activity
- **Features**: Stats, recent activity

## 🎨 Testing the Design

### View Different Screens

Edit `main.dart` to change the initial screen:

```dart
// Show landing page (default)
home: const LandingScreen(),

// Show analysis screen
home: const AnalyzeScreen(),

// Show dashboard with navigation
home: const DashboardScreen(),
```

### Test Responsive Design

1. **Desktop View**: Run in Chrome (default)
2. **Mobile View**: Open Chrome DevTools (F12) → Toggle device toolbar
3. **Tablet View**: Set viewport to 768px width

## 🛠️ Development Commands

```bash
# Run in Chrome
flutter run -d chrome

# Run in debug mode with hot reload
flutter run -d chrome --debug

# Build for production
flutter build web --release

# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/              # Colors, spacing, strings
│   └── theme/                  # Theme configuration
├── views/
│   ├── home/                   # Landing, dashboard
│   ├── analysis/               # Analysis screens
│   ├── education/              # Education hub
│   ├── community/              # Community feed
│   └── profile/                # User profile
└── widgets/
    └── common/                 # Reusable widgets
```

## 🎯 Key Features to Test

### Analysis Screen
1. Click on different tabs (Screenshot, Text, URL)
2. Try uploading an image
3. Type text in the text area
4. Enter a URL
5. Click "Analyze" button

### Landing Screen
1. Scroll through sections
2. Click "Get Started" button
3. Click "Learn More" button
4. View statistics

### Dashboard
1. Click bottom navigation items
2. Switch between screens
3. Test navigation flow

## 🎨 Customizing Colors

Edit `lib/core/constants/app_colors.dart`:

```dart
static const primary = Color(0xFF3B82F6);  // Change primary color
static const riskLow = Color(0xFF10B981);  // Change success color
static const riskHigh = Color(0xFFEF4444); // Change error color
```

## 📏 Adjusting Spacing

Edit `lib/core/constants/app_spacing.dart`:

```dart
static const double md = 16.0;  // Default spacing
static const double lg = 24.0;  // Large spacing
static const double xl = 32.0;  // Extra large spacing
```

## 🔤 Changing Text Sizes

Edit `lib/core/theme/text_styles.dart`:

```dart
static const displayLarge = TextStyle(
  fontSize: 56,  // Change hero text size
  fontWeight: FontWeight.w700,
);
```

## 🐛 Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Install Flutter SDK and add to PATH

### Issue: "Chrome not found"
**Solution**: Install Google Chrome or use a different browser:
```bash
flutter run -d edge  # Microsoft Edge
flutter run -d firefox  # Firefox
```

### Issue: "Package not found"
**Solution**: Run `flutter pub get` to install dependencies

### Issue: "Hot reload not working"
**Solution**: Save the file (Ctrl+S) or type 'r' in the terminal

### Issue: "Build errors"
**Solution**: Run `flutter clean` then `flutter pub get`

## 📱 Testing on Mobile Devices

### Android
```bash
flutter run -d android
```

### iOS (Mac only)
```bash
flutter run -d ios
```

### Web (Mobile browser)
1. Build the app: `flutter build web --release`
2. Serve the build folder
3. Access from mobile browser

## 🎨 Design Resources

- **Color Palette**: See `DESIGN_GUIDE.md`
- **Component Specs**: See `DESIGN_GUIDE.md`
- **Frontend Guidelines**: See `FRONTEND_README.md`
- **Implementation Summary**: See `FRONTEND_IMPLEMENTATION_SUMMARY.md`

## 📝 Next Steps

1. **Connect Backend**: Integrate Firebase and Gemini AI
2. **Add Authentication**: Implement login/signup screens
3. **Test with Users**: Get feedback from target audience (50-70 age group)
4. **Optimize Performance**: Lazy loading, caching
5. **Deploy**: Build and deploy to Vercel

## 🆘 Getting Help

- **Flutter Docs**: https://flutter.dev/docs
- **Material Design**: https://m3.material.io/
- **Accessibility**: https://www.w3.org/WAI/WCAG21/quickref/

---

**Happy Coding!** 🎉

If you encounter any issues, check the documentation files or run `flutter doctor` to diagnose problems.
