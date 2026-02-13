# Gemini Integration - Test Examples

## Quick Test Cases

### 1. High-Risk Phishing Text

**Test Input (Text Tab):**
```
URGENT: Your bank account has been compromised!

We detected suspicious activity on your account. You must verify your identity 
immediately or your account will be locked within 24 hours.

Click here to verify: http://secure-bank-verify.xyz/login

Enter your:
- Full name
- Social Security Number
- Account number
- PIN code
- Mother's maiden name

Act now to prevent account closure!

Customer Service Team
```

**Expected Results:**
- Risk Score: 85-95 (High)
- Scam Type: Phishing
- Red Flags:
  - Urgency tactics ("URGENT", "within 24 hours")
  - Suspicious domain (xyz TLD)
  - Requests sensitive information (SSN, PIN)
  - Threats (account closure)
  - Generic greeting
- Recommendations:
  - Do not click the link
  - Contact bank directly using official number
  - Report as phishing
  - Never share sensitive information via email

---

### 2. Romance Scam Text

**Test Input (Text Tab):**
```
My dearest love,

I know we've only been talking for 2 weeks, but I feel such a deep connection 
with you. You are the love of my life!

I have wonderful news - I've inherited $5 million from my uncle in Nigeria! 
But there's a small problem... I need $2,000 to pay the legal fees to release 
the funds. Once I get the money, I'll fly to meet you and we can start our 
life together.

Can you help me with a wire transfer? I promise to pay you back 10x when I 
get my inheritance. We can finally be together!

All my love,
[Name]
```

**Expected Results:**
- Risk Score: 90-100 (High)
- Scam Type: Romance
- Red Flags:
  - Quick emotional attachment
  - Nigerian inheritance story
  - Request for money
  - Unrealistic promises
  - Wire transfer request
- Recommendations:
  - Stop all communication
  - Do not send money
  - Block the sender
  - Report to authorities

---

### 3. Job Scam Text

**Test Input (Text Tab):**
```
Congratulations! You've been selected for a Work-From-Home position!

Position: Data Entry Specialist
Salary: $5,000/week for just 2 hours of work per day!

No experience needed! No interview required!

To get started, you just need to:
1. Pay a one-time $299 training fee
2. Provide your bank account for direct deposit
3. Purchase our special software package ($499)

Start earning TODAY! Limited spots available!

Reply with your credit card information to secure your position.
```

**Expected Results:**
- Risk Score: 85-95 (High)
- Scam Type: Job
- Red Flags:
  - Unrealistic salary
  - No interview process
  - Upfront payment required
  - Requests financial information
  - High pressure tactics
- Recommendations:
  - Do not pay any fees
  - Research company thoroughly
  - Legitimate jobs don't require payment
  - Report to job platform

---

### 4. Tech Support Scam Text

**Test Input (Text Tab):**
```
WINDOWS SECURITY ALERT

Your computer has been infected with 23 viruses!

Your personal data, photos, and banking information are at risk!

Call our certified technicians immediately: 1-800-FAKE-TECH

DO NOT turn off your computer! This will cause permanent data loss!

Our technicians will remotely access your computer to remove the viruses.
Service fee: $299 (special discount from $999)

WARNING: Failure to act within 1 hour will result in complete system failure!
```

**Expected Results:**
- Risk Score: 90-100 (High)
- Scam Type: Tech Support
- Red Flags:
  - Fake virus warnings
  - Urgency and threats
  - Request for remote access
  - Overpriced "service"
  - Scare tactics
- Recommendations:
  - Do not call the number
  - Use legitimate antivirus software
  - Microsoft doesn't send unsolicited alerts
  - Report as scam

---

### 5. Legitimate Low-Risk Text

**Test Input (Text Tab):**
```
Hi Sarah,

Thanks for your email yesterday. I wanted to follow up on the project timeline 
we discussed.

Can we schedule a meeting for next Tuesday at 2 PM to review the quarterly 
reports? Please let me know if that works for you, or suggest an alternative time.

Also, I've attached the draft proposal for your review. Feel free to add any 
comments or suggestions.

Best regards,
John Smith
Marketing Manager
ABC Company
john.smith@abccompany.com
```

**Expected Results:**
- Risk Score: 5-15 (Low)
- Scam Type: Other or None
- Red Flags: None or minimal
- Recommendations:
  - Appears legitimate
  - Verify sender if unknown
  - Standard business communication

---

### 6. Suspicious URLs to Test

**Test Input (URL Tab):**

**High Risk URLs:**
```
http://paypa1.com/verify
https://amaz0n-security.xyz/login
http://g00gle.com/signin
https://micros0ft-support.info/update
http://secure-bank-login.tk/account
https://app1e-id.com/unlock
```

**Low Risk URLs:**
```
https://www.google.com
https://www.amazon.com
https://www.microsoft.com
https://www.github.com
https://www.wikipedia.org
```

**Expected Results for High Risk:**
- Risk Score: 70-95
- Scam Type: Phishing
- Red Flags:
  - Typosquatting (paypa1, amaz0n, g00gle)
  - Suspicious TLDs (.xyz, .tk, .info)
  - Missing HTTPS (some cases)
  - Brand impersonation
- Recommendations:
  - Do not visit the site
  - Verify official domain
  - Report phishing attempt

**Expected Results for Low Risk:**
- Risk Score: 0-10
- Scam Type: None
- Red Flags: None
- Recommendations: Site appears legitimate

---

### 7. Investment Scam Text

**Test Input (Text Tab):**
```
🚀 EXCLUSIVE CRYPTO INVESTMENT OPPORTUNITY 🚀

Turn $500 into $50,000 in just 30 days!

Our AI-powered trading bot has a 99.9% success rate!

Limited time offer - only 10 spots remaining!

✅ Guaranteed returns
✅ No risk
✅ Instant withdrawals
✅ Celebrity endorsed

Join now and receive a FREE $1,000 bonus!

Send Bitcoin to: [wallet address]

Don't miss out on this life-changing opportunity!

"I made $100,000 in my first week!" - Totally Real Person
```

**Expected Results:**
- Risk Score: 95-100 (High)
- Scam Type: Investment
- Red Flags:
  - Unrealistic returns
  - "Guaranteed" profits
  - No risk claims
  - High pressure tactics
  - Cryptocurrency payment
  - Fake testimonials
- Recommendations:
  - Do not invest
  - No legitimate investment guarantees returns
  - Research thoroughly
  - Consult financial advisor
  - Report as fraud

---

### 8. Lottery Scam Text

**Test Input (Text Tab):**
```
CONGRATULATIONS!!!

You have won the MEGA INTERNATIONAL LOTTERY!

Prize amount: $2,500,000.00 USD

Your winning ticket number: 23-45-67-89-12

To claim your prize, you must:
1. Pay processing fee: $500
2. Provide passport copy
3. Send bank account details
4. Pay tax advance: $5,000

Claim within 48 hours or prize will be forfeited!

Contact: lottery.claims@free-email.com
```

**Expected Results:**
- Risk Score: 90-100 (High)
- Scam Type: Lottery
- Red Flags:
  - Didn't enter lottery
  - Upfront fees required
  - Requests personal documents
  - Time pressure
  - Free email address
  - Tax advance request
- Recommendations:
  - Ignore the message
  - Do not pay any fees
  - Legitimate lotteries don't require payment
  - Report as scam

---

## Testing Workflow

1. **Open the App**
   - Navigate to Analyze screen
   - Select appropriate tab (Screenshot/Text/URL)

2. **Enter Test Data**
   - Copy one of the test examples above
   - Paste into the input field

3. **Run Analysis**
   - Click "Analyze" button
   - Wait for AI processing (2-5 seconds)

4. **Review Results**
   - Check risk score matches expected range
   - Verify scam type is correctly identified
   - Review red flags for accuracy
   - Confirm recommendations are helpful

5. **Test Edge Cases**
   - Empty input (should show error)
   - Very long text (should handle gracefully)
   - Multiple analyses in succession (rate limiting)
   - Network errors (error handling)

---

## Screenshot Testing

For screenshot analysis, create test images containing:

1. **Phishing Email Screenshots**
   - Fake bank emails
   - Fake PayPal/Amazon notifications
   - Suspicious login requests

2. **Social Media Scam Screenshots**
   - Fake giveaways
   - Impersonation accounts
   - Too-good-to-be-true offers

3. **Text Message Screenshots**
   - Package delivery scams
   - IRS/tax scams
   - Prize/lottery notifications

4. **Legitimate Screenshots** (Low Risk)
   - Normal emails
   - Real company communications
   - Genuine notifications

---

## Performance Benchmarks

**Expected Response Times:**
- Text Analysis: 2-3 seconds
- URL Analysis: 2-4 seconds
- Image Analysis: 3-5 seconds

**Rate Limits:**
- 15 requests per minute
- 1,500 requests per day

**Accuracy Expectations:**
- High-risk scams: 90%+ detection rate
- Medium-risk content: 75%+ accuracy
- Low-risk content: 95%+ accuracy

---

## Troubleshooting Test Issues

**If analysis fails:**
1. Check internet connection
2. Verify API key is valid
3. Check console for error messages
4. Try with simpler test case
5. Verify rate limits not exceeded

**If results seem inaccurate:**
1. Test with multiple examples
2. Check if input is clear and complete
3. Try rephrasing or adding more context
4. Review confidence level in results

**If app crashes:**
1. Check for null values
2. Verify image format is supported
3. Check memory usage for large images
4. Review error logs

---

**Ready to Test!** 🚀

Start with the high-risk examples to see the AI in action, then test with low-risk examples to verify accuracy across the spectrum.
