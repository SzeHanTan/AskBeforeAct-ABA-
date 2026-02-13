# AskBeforeAct Design Guide

## 🎨 Visual Design System

### Color Palette

#### Primary Colors
```
🔵 Primary Blue
Hex: #3B82F6
RGB: 59, 130, 246
Use: Primary buttons, links, active states, branding

🔵 Primary Dark
Hex: #2563EB
RGB: 37, 99, 235
Use: Button hover states, emphasis

🔵 Primary Light
Hex: #60A5FA
RGB: 96, 165, 250
Use: Backgrounds, subtle highlights
```

#### Risk Level Colors
```
🟢 Low Risk (Safe)
Hex: #10B981
RGB: 16, 185, 129
Use: 0-30% risk score, success messages

🟡 Medium Risk (Caution)
Hex: #F59E0B
RGB: 245, 158, 11
Use: 31-70% risk score, warnings

🔴 High Risk (Danger)
Hex: #EF4444
RGB: 239, 68, 68
Use: 71-100% risk score, errors, critical alerts
```

#### Neutral Colors
```
⚪ Background
Hex: #F5F7FA
RGB: 245, 247, 250
Use: Page backgrounds

⚪ Surface
Hex: #FFFFFF
RGB: 255, 255, 255
Use: Card backgrounds, modals

⚫ Text Primary
Hex: #1E293B
RGB: 30, 41, 59
Use: Headings, important text

⚫ Text Secondary
Hex: #64748B
RGB: 100, 116, 139
Use: Body text, descriptions

⚫ Text Tertiary
Hex: #94A3B8
RGB: 148, 163, 184
Use: Captions, helper text

⚪ Border
Hex: #E2E8F0
RGB: 226, 232, 240
Use: Card borders, dividers
```

### Typography Scale

```
Display Large (Hero)
Size: 56px
Weight: 700 (Bold)
Line Height: 1.2
Use: Landing page hero, main headings

Display Medium
Size: 40px
Weight: 700 (Bold)
Line Height: 1.2
Use: Section headings

Title Large
Size: 28px
Weight: 700 (Bold)
Line Height: 1.3
Use: Page titles

Title Medium
Size: 22px
Weight: 600 (Semi-bold)
Line Height: 1.4
Use: Card titles, subsections

Body Large
Size: 18px
Weight: 400 (Regular)
Line Height: 1.6
Use: Primary body text, button text

Body Medium
Size: 16px
Weight: 400 (Regular)
Line Height: 1.6
Use: Secondary body text

Caption
Size: 14px
Weight: 400 (Regular)
Line Height: 1.5
Use: Helper text, timestamps
```

### Spacing System

```
XS:   4px   ▪
SM:   8px   ▪▪
MD:   16px  ▪▪▪▪
LG:   24px  ▪▪▪▪▪▪
XL:   32px  ▪▪▪▪▪▪▪▪
XXL:  48px  ▪▪▪▪▪▪▪▪▪▪▪▪
XXXL: 64px  ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
```

### Border Radius

```
Small:    8px   ⬜ (Input fields, small buttons)
Medium:   12px  ⬜ (Buttons, cards)
Large:    16px  ⬜ (Large cards, modals)
XLarge:   24px  ⬜ (Hero sections)
Circle:   50%   ⭕ (Avatars, icon buttons)
```

### Shadows

```
Small (Hover)
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04)

Medium (Cards)
box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04)

Large (Modals)
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08)
```

## 🧩 Component Specifications

### Buttons

#### Primary Button
```
Height: 56px
Padding: 24px horizontal, 16px vertical
Background: #3B82F6
Text: White, 18px, Semi-bold (600)
Border Radius: 12px
Hover: #2563EB
Disabled: #E2E8F0
```

#### Secondary Button (Outlined)
```
Height: 56px
Padding: 24px horizontal, 16px vertical
Background: Transparent
Border: 2px solid #3B82F6
Text: #3B82F6, 18px, Semi-bold (600)
Border Radius: 12px
Hover: Background #F0F9FF
```

### Input Fields

#### Text Input
```
Height: 56px
Padding: 20px
Background: #F8FAFC
Border: 1.5px solid #CBD5E1
Border Radius: 12px
Font Size: 17px
Focus Border: 2px solid #3B82F6
```

### Cards

#### Standard Card
```
Background: White
Padding: 24-32px
Border: 2px solid #E2E8F0 (optional)
Border Radius: 16px
Shadow: 0 4px 16px rgba(0, 0, 0, 0.04)
```

#### Feature Card (Landing)
```
Background: White
Padding: 32px
Border: 2px solid #E2E8F0
Border Radius: 16px
Icon Container: 80x80px, 16px radius
```

### Icons

```
Small:        20px (Inline icons)
Standard:     24px (Navigation, buttons)
Medium:       28px (Bottom nav)
Large:        40px (Feature cards)
Extra Large:  56px (Risk indicators)
Huge:         100px (Hero sections)
```

### Risk Score Display

#### Low Risk (0-30%)
```
Background: #F0FDF4 (light green)
Icon: ✓ Check circle
Icon Color: #10B981
Text: "LOW RISK"
Progress Bar: #10B981
```

#### Medium Risk (31-70%)
```
Background: #FEF3C7 (light yellow)
Icon: ⚠ Warning
Icon Color: #F59E0B
Text: "MEDIUM RISK"
Progress Bar: #F59E0B
```

#### High Risk (71-100%)
```
Background: #FEF2F2 (light red)
Icon: ⚠ Danger
Icon Color: #EF4444
Text: "HIGH RISK"
Progress Bar: #EF4444
```

## 📐 Layout Patterns

### Page Layout
```
┌─────────────────────────────────────┐
│           Header/AppBar             │
├─────────────────────────────────────┤
│                                     │
│         Content Area                │
│     (Max Width: 900-1200px)         │
│         Centered                    │
│                                     │
├─────────────────────────────────────┤
│      Bottom Navigation (Mobile)     │
└─────────────────────────────────────┘
```

### Card Layout
```
┌─────────────────────────────────────┐
│  ┌─────┐                            │
│  │Icon │  Title                     │
│  └─────┘  Description               │
│                                     │
│  Content area with proper spacing  │
│                                     │
│  [Action Button]                   │
└─────────────────────────────────────┘
```

### Analysis Results Layout
```
┌─────────────────────────────────────┐
│         Risk Score Card             │
│  ┌─────────┐                        │
│  │  Icon   │                        │
│  │ (100px) │                        │
│  └─────────┘                        │
│    HIGH RISK                        │
│   Risk Score: 85%                   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│      Warning Signs Detected         │
│  • Red flag 1                       │
│  • Red flag 2                       │
│  • Red flag 3                       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│      What You Should Do             │
│  ① Recommendation 1                 │
│  ② Recommendation 2                 │
│  ③ Recommendation 3                 │
└─────────────────────────────────────┘
```

## 🎯 Accessibility Guidelines

### Text Contrast Ratios
```
✅ Large Text (18px+):     3:1 minimum
✅ Normal Text (16px):     4.5:1 minimum
✅ Primary Text:           #1E293B on #FFFFFF = 13.6:1
✅ Secondary Text:         #64748B on #FFFFFF = 5.8:1
✅ Button Text:            #FFFFFF on #3B82F6 = 4.8:1
```

### Touch Targets
```
✅ Minimum:    44x44px
✅ Buttons:    56px height
✅ Icons:      28px minimum
✅ Spacing:    8px minimum between targets
```

### Focus States
```
Keyboard Focus:
- 2px solid border
- Color: #3B82F6
- Border Radius: matches element
- Visible on all interactive elements
```

## 📱 Responsive Breakpoints

```
Mobile:     < 640px
Tablet:     640px - 1024px
Desktop:    > 1024px

Max Content Width: 1200px (centered)
```

### Mobile Adjustments
```
- Single column layout
- Full-width cards
- Larger touch targets (56px buttons)
- Simplified navigation
- Bottom navigation bar
```

### Desktop Enhancements
```
- Multi-column layouts
- Hover states
- Larger content areas
- Side navigation (optional)
- More detailed information
```

## 🎨 Example Color Combinations

### Primary Actions
```
Background: #3B82F6
Text: #FFFFFF
Hover: #2563EB
```

### Success Messages
```
Background: #F0FDF4
Text: #10B981
Border: #10B981
```

### Warning Messages
```
Background: #FEF3C7
Text: #F59E0B
Border: #F59E0B
```

### Error Messages
```
Background: #FEF2F2
Text: #EF4444
Border: #EF4444
```

### Info Messages
```
Background: #F0F9FF
Text: #3B82F6
Border: #3B82F6
```

## 🖼️ Icon Usage

### Analysis Types
```
Screenshot: 📷 Icons.image_outlined
Text:       📝 Icons.text_fields
URL:        🔗 Icons.link
```

### Risk Levels
```
Low:        ✓ Icons.check_circle_outline
Medium:     ⚠ Icons.warning_amber_rounded
High:       ⚠ Icons.dangerous_outlined
```

### Navigation
```
Analyze:    🛡️ Icons.security
Learn:      📚 Icons.school_outlined
Community:  👥 Icons.people_outline
Profile:    👤 Icons.person_outline
```

### Actions
```
Upload:     ⬆️ Icons.cloud_upload_outlined
Analyze:    📊 Icons.analytics_outlined
Share:      ↗️ Icons.share_outlined
Refresh:    🔄 Icons.refresh
Settings:   ⚙️ Icons.settings_outlined
```

## 📏 Measurement Reference

```
4px   = 0.25rem = XS spacing
8px   = 0.5rem  = SM spacing
16px  = 1rem    = MD spacing (base)
24px  = 1.5rem  = LG spacing
32px  = 2rem    = XL spacing
48px  = 3rem    = XXL spacing
64px  = 4rem    = XXXL spacing
```

## 🎨 Design Principles Summary

1. **Clarity Over Cleverness** - Simple, straightforward design
2. **Consistency** - Same patterns throughout
3. **Accessibility First** - High contrast, large text, clear labels
4. **Generous Spacing** - Room to breathe, easy to scan
5. **Visual Hierarchy** - Clear importance levels
6. **Forgiving Design** - Large touch targets, clear feedback
7. **Plain Language** - No jargon, clear instructions
8. **Predictable Behavior** - No surprises, familiar patterns

---

**Use this guide** when creating new components or screens to maintain consistency throughout the application.

**Last Updated**: February 13, 2026
