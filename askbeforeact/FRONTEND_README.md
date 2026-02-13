# AskBeforeAct Frontend

## Design Philosophy

This frontend is designed with **simplicity and accessibility** in mind, specifically targeting users aged 50-70 who may not be tech-savvy. The design balances modern aesthetics with user-friendly interfaces.

## Key Design Principles

### 1. **Large, Readable Text**
- Base font size: 16-20px
- Headings: 24-56px
- High contrast for better readability
- Clear visual hierarchy

### 2. **Generous Spacing**
- Ample padding and margins
- Clear separation between elements
- Reduced visual clutter
- Easy-to-tap buttons (minimum 56px height)

### 3. **Simple Color Palette**
- **Primary Blue**: `#3B82F6` - Trust and security
- **Success Green**: `#10B981` - Safe/low risk
- **Warning Orange**: `#F59E0B` - Medium risk
- **Error Red**: `#EF4444` - High risk/danger
- **Neutral Grays**: Soft backgrounds and text

### 4. **Clear Visual Feedback**
- Large icons (24-40px)
- Color-coded risk levels
- Loading states
- Success/error messages

### 5. **Intuitive Navigation**
- Tab-based interface for analysis types
- Clear labels and instructions
- Prominent call-to-action buttons
- Breadcrumb navigation

## Screen Breakdown

### Landing Screen (`landing_screen.dart`)
**Purpose**: Welcome users and explain the service

**Features**:
- Hero section with clear value proposition
- Feature cards explaining each analysis type
- Step-by-step "How It Works" section
- Call-to-action buttons
- Simple navigation header

**Design Notes**:
- Uses large headings (56px) for main title
- Soft background colors (`#F8FAFC`)
- Clear visual hierarchy
- Minimal animations

### Analysis Screen (`analyze_screen.dart`)
**Purpose**: Main fraud detection interface

**Features**:
- Three tabs: Screenshot Upload, Text Input, URL Check
- Drag-and-drop file upload
- Large text input areas
- Clear instructions for each method
- Prominent "Analyze" buttons

**Design Notes**:
- Tab icons + text labels for clarity
- Generous padding (32px)
- Large input fields
- Visual feedback on file selection
- Disabled state for buttons when no input

### Results Screen (`results_screen.dart`)
**Purpose**: Display analysis results clearly

**Features**:
- Large risk score display with color coding
- Risk level indicator (Low/Medium/High)
- Circular progress bar
- Warning signs list with bullet points
- Numbered recommendations
- Action buttons (Share, New Analysis)

**Design Notes**:
- Color-coded risk levels:
  - Green (0-30%): Low risk
  - Orange (31-70%): Medium risk
  - Red (71-100%): High risk
- Large icons (56px) for risk indicators
- Clear sectioning with cards
- High contrast text
- Numbered steps for recommendations

## Color System

```dart
// Primary Colors
Primary Blue:     #3B82F6
Primary Dark:     #2563EB
Primary Light:    #60A5FA

// Risk Colors
Low Risk:         #10B981 (Green)
Medium Risk:      #F59E0B (Orange)
High Risk:        #EF4444 (Red)

// Neutral Colors
Background:       #F5F7FA
Surface:          #FFFFFF
Text Primary:     #1E293B
Text Secondary:   #64748B
Border:           #E2E8F0
```

## Typography

**Font Family**: System default (San Francisco on iOS/macOS, Roboto on Android/Web)

**Font Sizes**:
- Display Large: 56px (Hero headings)
- Display Medium: 40px (Section headings)
- Title Large: 28px (Card titles)
- Title Medium: 22px (Subtitles)
- Body Large: 18px (Primary text)
- Body Medium: 16px (Secondary text)
- Caption: 14px (Helper text)

**Font Weights**:
- Bold: 700 (Headings)
- Semi-bold: 600 (Buttons, emphasis)
- Medium: 500 (Labels)
- Regular: 400 (Body text)

## Spacing System

```dart
XS:   4px   // Tight spacing
SM:   8px   // Small spacing
MD:   16px  // Default spacing
LG:   24px  // Section spacing
XL:   32px  // Large spacing
XXL:  48px  // Extra large spacing
XXXL: 64px  // Maximum spacing
```

## Component Guidelines

### Buttons
- **Height**: 56px (easy to tap)
- **Padding**: 24px horizontal, 16px vertical
- **Border Radius**: 12px (soft, friendly)
- **Font Size**: 18px
- **Font Weight**: 600 (semi-bold)

### Input Fields
- **Height**: 56px minimum
- **Padding**: 20px
- **Border**: 1.5px solid
- **Border Radius**: 12px
- **Font Size**: 17px

### Cards
- **Padding**: 28-32px
- **Border Radius**: 16px
- **Shadow**: Soft (0px 4px 24px rgba(0,0,0,0.04))
- **Border**: 2px solid for emphasis

### Icons
- **Standard**: 24px
- **Large**: 32px
- **Extra Large**: 40-56px (for main indicators)

## Accessibility Features

1. **High Contrast**: All text meets WCAG AA standards (4.5:1 ratio)
2. **Large Touch Targets**: Minimum 44x44px (56px for primary actions)
3. **Clear Labels**: All inputs have visible labels
4. **Semantic HTML**: Proper heading hierarchy
5. **Keyboard Navigation**: All interactive elements are keyboard accessible
6. **Screen Reader Support**: Semantic widgets with proper labels

## Responsive Design

### Breakpoints
- **Mobile**: < 640px
- **Tablet**: 640px - 1024px
- **Desktop**: > 1024px

### Layout Strategy
- **Mobile**: Single column, stacked cards
- **Tablet**: Two columns where appropriate
- **Desktop**: Max width 1200px, centered content

## Animation & Transitions

**Principle**: Minimal, purposeful animations

- **Button Hover**: Subtle color change (no animation)
- **Loading States**: Simple spinner (2.5px stroke)
- **Page Transitions**: None (instant for clarity)
- **Focus States**: 2px border highlight

## Best Practices for Senior Users

1. ✅ **Use Large Text** - Never below 16px
2. ✅ **High Contrast** - Easy to read in any lighting
3. ✅ **Clear Instructions** - Tell users exactly what to do
4. ✅ **Forgiving Inputs** - Large click areas, clear error messages
5. ✅ **Consistent Layout** - Same patterns throughout
6. ✅ **No Jargon** - Plain language everywhere
7. ✅ **Visual Feedback** - Confirm every action
8. ✅ **No Time Pressure** - No auto-dismissing messages

## Future Enhancements

- [ ] Voice input for text analysis
- [ ] Larger font size option in settings
- [ ] Tutorial/onboarding flow
- [ ] Keyboard shortcuts guide
- [ ] Print-friendly results page

## Development Notes

### Running the App
```bash
# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Build for production
flutter build web --release
```

### File Structure
```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/              # Colors, spacing, strings
│   └── theme/                  # App theme configuration
├── views/
│   ├── home/
│   │   └── landing_screen.dart # Landing page
│   └── analysis/
│       ├── analyze_screen.dart # Analysis input
│       └── results_screen.dart # Results display
└── widgets/
    └── common/
        └── custom_button.dart  # Reusable button
```

## Design Credits

- Inspired by accessible design principles from WCAG 2.1
- Color palette optimized for readability
- Layout patterns from Material Design 3
- Senior-friendly UX patterns from Nielsen Norman Group research

---

**Last Updated**: February 13, 2026
**Version**: 1.0
**Status**: Ready for Development
