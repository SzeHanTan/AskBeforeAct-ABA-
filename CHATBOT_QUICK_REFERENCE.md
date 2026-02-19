# AI Chatbot - Quick Reference

## 🚀 Quick Start

### No Setup Required!
The chatbot is automatically available when you run the app.

```bash
cd askbeforeact
flutter run -d chrome
```

Navigate to Learn section → Tap "🤖 Ask AI"

---

## 🎯 How to Use

### Opening the Chatbot (3 ways)

1. **Floating Button**: Tap "🤖 Ask AI" (bottom right)
2. **App Bar Icon**: Tap robot icon (top right)
3. **AI Summary**: Tap "AI Summary" button in Latest News tab

### Asking Questions

1. **Use Suggested Questions**: Tap a chip to ask quickly
2. **Type Your Own**: Use the text field at bottom
3. **Press Send**: Tap send button or press Enter

### Getting News Summary

1. Go to "Latest News" tab
2. Tap "AI Summary" button
3. Chatbot opens with automatic summary
4. Ask follow-up questions if needed

---

## 💬 Example Questions

### About Scams
- "How can I identify phishing emails?"
- "What are romance scam warning signs?"
- "How do I protect myself from payment fraud?"
- "What are job scam red flags?"
- "How do tech support scams work?"

### About News
- "Summarize the latest scam news"
- "What are the current scam trends?"
- "Which scams are most common right now?"
- "What regions are affected by scams?"

### Scenario Analysis
- "Is this a scam? [describe situation]"
- "Someone asked me to... [describe]"
- "I received a message saying... [describe]"

### Getting Help
- "What should I do if I've been scammed?"
- "How do I report a scam?"
- "Where can I get help?"

---

## 🎨 UI Elements

### Chatbot Header
```
🤖 Scam Prevention Assistant    [🔄] [✕]
   Powered by Gemini AI
```

### Message Bubbles

**User Message (Right, Blue):**
```
                    ┌─────────────────────┐
                    │ Your question here  │
                    │ 14:30              │ 👤
                    └─────────────────────┘
```

**AI Message (Left, Gray):**
```
🤖  ┌─────────────────────┐
    │ AI response here    │
    │ 14:30              │
    └─────────────────────┘
```

**Summary Message (Left, Light Blue):**
```
🤖  ┌─────────────────────────┐
    │ 📊 News Summary         │
    │ ─────────────────────── │
    │ Summary content here... │
    │ 14:30                   │
    └─────────────────────────┘
```

### Suggested Questions
```
💡 Summarize latest news  💡 Phishing tips  💡 Romance scams
```

### Input Area
```
┌──────────────────────────────────────┐ [📤]
│ Ask about scams and fraud...         │
└──────────────────────────────────────┘
```

---

## 🎯 Features at a Glance

| Feature | Description | How to Access |
|---------|-------------|---------------|
| **News Summary** | AI summarizes all news | Tap "AI Summary" button |
| **Q&A** | Ask any scam-related question | Type in chat |
| **Scenario Analysis** | Check if something is a scam | Describe situation |
| **Tips** | Get prevention tips | Ask for specific scam type |
| **Suggested Questions** | Quick start questions | Tap suggestion chips |
| **Clear Chat** | Reset conversation | Tap refresh icon |

---

## 🔑 Key Capabilities

### ✅ What It Can Do
- Summarize scam news
- Answer questions about scams
- Analyze scenarios
- Provide prevention tips
- Reference education content
- Cite news articles
- Maintain conversation context

### ❌ What It Cannot Do
- Provide legal advice
- Provide financial advice
- Access your personal data
- Report scams for you
- Take actions on your behalf

---

## 💡 Pro Tips

1. **Be Specific**: "How to identify phishing?" → "What are the signs of a phishing email from a bank?"

2. **Provide Context**: "Is this a scam?" → "I received a WhatsApp message from someone claiming to be from my bank asking for my PIN. Is this a scam?"

3. **Ask Follow-ups**: After getting an answer, ask for more details or examples

4. **Use Summary**: Start with news summary to understand current trends

5. **Clear Chat**: Use refresh button to start fresh conversation

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Chatbot not opening | Check if app is running, refresh page |
| No response | Check internet, verify API key |
| Error message | Tap retry, check console logs |
| Slow response | Wait 5-10 seconds, normal for summaries |
| Empty summary | Ensure news is loaded first |

---

## 📊 Response Time Guide

| Action | Expected Time |
|--------|---------------|
| Simple question | 1-3 seconds |
| Complex question | 3-5 seconds |
| News summary | 5-10 seconds |
| Scenario analysis | 3-5 seconds |

---

## 🎨 Keyboard Shortcuts

- **Enter**: Send message
- **Esc**: Close chatbot (if modal)
- **Ctrl+R**: Refresh chat (via button)

---

## 📱 Mobile vs Desktop

### Mobile
- Full-screen modal
- Draggable sheet
- Touch-optimized buttons
- Responsive layout

### Desktop
- Centered modal (max 900px)
- Mouse hover effects
- Keyboard shortcuts
- Larger text

---

## ✨ Tips for Best Results

### Good Questions ✅
- "How can I verify if a job offer is legitimate?"
- "What are the red flags in this scenario: [detailed description]"
- "Summarize the latest scam news and tell me the top 3 threats"

### Poor Questions ❌
- "Scam?" (too vague)
- "Help" (not specific)
- "?" (no context)

---

## 🔄 Workflow Examples

### Workflow 1: Learn About Phishing
```
1. Open chatbot
2. Tap "How can I identify phishing emails?"
3. Read AI response
4. Ask follow-up: "What about SMS phishing?"
5. Get additional details
```

### Workflow 2: Analyze Suspicious Message
```
1. Open chatbot
2. Type: "Is this a scam? [paste message]"
3. AI analyzes and responds
4. Follow AI's recommendations
5. Report if confirmed scam
```

### Workflow 3: Stay Updated
```
1. Go to Latest News tab
2. Tap "AI Summary"
3. Read summary of all news
4. Ask: "Which scam is most dangerous?"
5. Get detailed explanation
```

---

## 📞 Quick Support

**Common Issues:**

1. **"Failed to get response"**
   → Check internet connection

2. **"Unable to generate summary"**
   → Ensure news is loaded (refresh news tab)

3. **Slow responses**
   → Normal for complex questions, wait 5-10 seconds

4. **Chat not opening**
   → Refresh app, check console for errors

---

## 🎉 You're Ready!

The AI chatbot is ready to help you learn about scams and stay protected. Just tap the "🤖 Ask AI" button and start chatting!

**Remember:**
- Be specific with questions
- Use news summary for trends
- Analyze suspicious scenarios
- Always report confirmed scams
- Stay informed and stay safe! 🛡️

---

**Quick Access:**
- Floating Button: Bottom right
- App Bar Icon: Top right
- AI Summary: Latest News tab

**Documentation:**
- Full Guide: `CHATBOT_FEATURE.md`
- Learn Section: `LEARN_SECTION_INTEGRATION.md`
