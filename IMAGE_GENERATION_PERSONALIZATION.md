# Image Generation Personalization Update

## Overview
Updated the `image_generation_service.dart` to generate **personalized, story-specific** warning images instead of generic scam warnings.

## Problem
Previously, the image generation service created generic warning images based only on the scam type (e.g., "phishing", "romance", "payment"). These images didn't incorporate the **specific details** from the user's actual input, making them feel impersonal and less impactful.

## Solution
Enhanced the image generation prompts to include:

### 1. **Specific User Context**
- **Content Preview**: First 100 characters of the actual user input (screenshot text or message)
- **Main Red Flag**: The primary suspicious indicator detected in THIS specific case
- **Key Recommendation**: The top action item for THIS specific situation
- **Risk Score**: Actual numerical score (0-100) with confidence level

### 2. **Personalized Warning Images**
Each scam type now generates images that:
- Reference the **specific red flag** detected in the user's case
- Include **actual content snippets** from the user's input
- Show **personalized risk scores** and confidence levels
- Highlight the **exact suspicious elements** found

### 3. **Enhanced Social Media Cards**
Social cards now include:
- **Primary and secondary red flags** from the specific case
- **Specific recommendations** for this situation
- **Actual risk score** displayed prominently
- **Personalized warning message** based on detected threats
- "Detected by AskBeforeAct" branding

### 4. **Story-Specific Memes**
Memes are now personalized with:
- **Scammer quotes** extracted from actual red flags
- **Specific tactics** used in THIS attempt
- **Relatable scenarios** based on the user's experience
- **Context-aware humor** that references the actual scam

## Technical Implementation

### Before (Generic):
```dart
case 'phishing':
  return '''
Create a warning image for a PHISHING scam:
- Show a fishing hook with an email icon
- Text: "Don't Take the Bait!"
- Risk Level: $riskLevel
''';
```

### After (Personalized):
```dart
case 'phishing':
  return '''
Create a warning image for a PHISHING scam based on this SPECIFIC case:

SPECIFIC CONTEXT FROM USER'S CASE:
- Content Preview: "$contentSnippet"
- Main Red Flag: "$primaryRedFlag"
- Key Recommendation: "$topRecommendation"
- Risk Score: ${analysis.riskScore}/100

Visual Elements:
- Show a fishing hook with an email/message icon
- Main Text: "Don't Take the Bait!"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)

Make it clear this is about THIS specific phishing attempt.
''';
```

## New Features

### 1. Content Snippet Extraction
```dart
final contentSnippet = analysis.content.length > 100
    ? analysis.content.substring(0, 100)
    : analysis.content;
```

### 2. Scammer Quote Extraction
New helper method `_extractScammerQuote()` that:
- Analyzes the red flag text
- Extracts key scammer tactics
- Creates realistic scammer quotes for memes
- Falls back to red flag snippet if no pattern matches

### 3. Multi-Flag Support
Social cards now show:
- Primary red flag (most important)
- Secondary red flag (if available)
- Specific recommendations

## Impact

### User Experience
- **More Relatable**: Users see their actual situation reflected in the warning
- **Higher Engagement**: Personalized content is more shareable
- **Better Understanding**: Specific details help users recognize similar scams
- **Increased Trust**: Shows the AI actually analyzed THEIR specific case

### Example Scenarios

#### Scenario 1: Phishing Email
**User Input**: "Your account will be suspended! Click here immediately to verify."

**Before**: Generic "Don't Take the Bait" image

**After**: Image showing:
- "Your account will be suspended! Click..."
- Red Flag: "Creates false urgency with suspension threat"
- Risk: 85/100 (High)
- Action: "Do not click links in unsolicited emails"

#### Scenario 2: Romance Scam
**User Input**: "I love you but I need $500 for emergency"

**Before**: Generic "Love Shouldn't Cost Money" image

**After**: Image showing:
- "I love you but I need $500..."
- Red Flag: "Requests money in early relationship stage"
- Risk: 92/100 (High)
- Action: "Never send money to someone you haven't met"

## Files Modified
- `askbeforeact/lib/services/image_generation_service.dart`

## Methods Enhanced
1. `_createImagePrompt()` - Main warning images
2. `generateSocialCard()` - Social media cards
3. `_createMemePrompt()` - Educational memes
4. `_extractScammerQuote()` - NEW helper method

## Testing Recommendations

1. **Test with Real Scam Examples**
   - Upload actual phishing screenshots
   - Input real romance scam messages
   - Verify images show specific content

2. **Verify Content Truncation**
   - Test with very long messages (>100 chars)
   - Ensure snippets are readable

3. **Check All Scam Types**
   - Phishing
   - Romance
   - Payment
   - Job
   - Tech Support
   - Investment
   - Lottery
   - Impersonation

4. **Social Media Card Testing**
   - Verify 1080x1080 format
   - Check readability on mobile
   - Test shareability

## Future Enhancements

1. **Visual Content Analysis**
   - Extract text from screenshots directly
   - Show actual URLs/domains in images
   - Highlight suspicious elements with arrows

2. **Multi-Language Support**
   - Detect language in user input
   - Generate images in matching language

3. **User Customization**
   - Let users choose image style
   - Allow custom text overlays
   - Enable brand customization

4. **A/B Testing**
   - Compare engagement: generic vs. personalized
   - Track share rates
   - Measure user satisfaction

## Notes

- Content snippets are limited to 100 characters for readability
- Red flags are prioritized by order (first = most important)
- All scam types now have personalized templates
- Fallback to generic if specific details unavailable
- Maintains backward compatibility with existing code

## Conclusion

The image generation service now creates **story-specific, personalized** warning images that reflect the user's actual experience, making the warnings more impactful, relatable, and shareable.
