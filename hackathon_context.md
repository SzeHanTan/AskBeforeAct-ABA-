# Project Background for Hackathon
- **Project Name**: AskBeforeAct
- **Core Concept**: An AI-powered fraud detection web app targeting high-risk demographics (like the elderly). It analyzes suspicious text messages, URLs, and screenshots. It also features a "Learn Section" for digital literacy and a "Community Section" for sharing scam alerts.
- **Testing Story**: We tested the prototype with our relatives during Lunar New Year gatherings using Google Forms.
- **Tech Stack**: Firebase (Hosting, Analytics, Backend), Google AI (Gemini for analysis), Flutter (Frontend).
- **Pre-answered questions**: 
- How did you validate your solution with real users?
To overcome the strict hackathon timeframe, I conducted agile, guerrilla-style usability testing during the Lunar New Year gatherings. This presented a unique and highly relevant opportunity, as my relatives—particularly the elderly—represent the exact high-risk demographic for digital fraud that this app aims to protect.

I set up my prototype on my laptop and invited 20 relatives across different age groups to interact with the platform. I asked them to test the core features by analyzing suspicious texts and URLs they had actually received. To ensure the feedback was structured and measurable, I collected their responses and satisfaction ratings using a standardized Google Form immediately after their testing session.

- What three changes did you make based on user input?
1. Audio-Based Community Summaries (AI Podcast)

The Feedback: Users stated they found the community scam alerts helpful but simply did not have the time or patience to read through a long feed of individual text posts.

What I Modified: I developed an "AI Audio Briefing" (Podcast) feature that aggregates and summarizes community posts based on user-selected timeframes (Today, Last 3 Days, Weekly, or Monthly) into a concise, listenable audio track.

The Result: Drastically reduced friction for content consumption. Users (especially the elderly or those commuting) can now passively listen to the latest scam trends, significantly increasing their engagement with community warnings.

2. Actionable Evidence Export (PDF Generation)

The Feedback: Users wanted a way to save the AI's analysis results, specifically expressing the need to show this proof to someone else if they actually fell for a scam.

What I Modified: I implemented a "Download Report" button at the end of every analysis. This compiles the AI’s threat assessment, and the explanation into a cleanly formatted, downloadable document.

The Result: Transformed the app from a mere "detection tool" into an "actionable security utility." Users are now empowered to hand over structured, credible evidence directly to local authorities, banks, or family members.

3. Dynamic & Interactive Digital Literacy (Real-time News + Chatbot)

The Feedback: Users felt the original "Learn Section" was too static, noting that reading generic, textbook definitions of old scam types wasn't helpful for recognizing new, evolving tactics.

What I Modified: I completely overhauled the section by integrating the Google News API to fetch real-time, trending articles on local scams. Furthermore, I embedded an AI Chatbot directly into the news feed to summarize lengthy articles and answer specific user questions about scams.

The Result: The educational aspect is now highly dynamic and relevant. Instead of reading boring definitions, users are warned about scams happening right now, and can interactively ask the AI for advice on how to protect themselves against these specific new threats.

- How do you measure your solution's success?
We measure success through a combination of performance, user satisfaction, and real-world impact metrics:

Performance Metric (< 5-second average analysis time): Speed is critical in fraud prevention. The AI must return a verdict before a user loses patience and clicks the malicious link.

User Metric (85%+ User Satisfaction): Measured via our testing phase and Google Forms, this tracks the app's ease of use, interface clarity, and the trust users place in the AI's verdicts.

Impact Metric (Actionable Threat Detection Rate): How to prove the efficiency of the AI Fraud Detecting System/ Community Impact?

- What Google technologies power your analytics?
We utilize a unified Google ecosystem to power both our deployment and data tracking:

Google Forms: Utilized for rapid qualitative data collection and initial baseline metrics during our prototype usability testing.

Firebase Hosting & Firebase Analytics (Google Analytics): The Web App is seamlessly hosted on Firebase. We have integrated Firebase Analytics to track core user journeys.

Expected Cause-and-Effect: Because the app is freshly deployed, we are establishing our data baseline. Moving forward, we expect to use Firebase Analytics to track event triggers (e.g., clicks on the "Analyze" button vs. time spent in the "Learn" section). We anticipate a positive correlation: as user engagement in the Learn Section increases, the community will submit more sophisticated scam examples, ultimately enriching our Community Section's database.

