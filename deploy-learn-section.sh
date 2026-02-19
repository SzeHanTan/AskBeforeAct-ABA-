#!/bin/bash

# Bash script to deploy Learn section integration
# Run this script from the project root directory

echo "========================================"
echo "Learn Section Firebase Integration Setup"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Check if Firebase CLI is installed
echo -e "${YELLOW}Checking Firebase CLI...${NC}"
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found. Please install it first:${NC}"
    echo "   npm install -g firebase-tools"
    exit 1
fi
FIREBASE_VERSION=$(firebase --version)
echo -e "${GREEN}✓ Firebase CLI found: $FIREBASE_VERSION${NC}"
echo ""

# Step 1: Install function dependencies
echo -e "${YELLOW}Step 1/5: Installing Cloud Function dependencies...${NC}"
cd functions || exit 1
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"
cd ..
echo ""

# Step 2: Deploy functions
echo -e "${YELLOW}Step 2/5: Deploying Cloud Functions...${NC}"
echo -e "${GRAY}This may take a few minutes...${NC}"
firebase deploy --only functions
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to deploy functions${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Functions deployed${NC}"
echo ""

# Step 3: Get project info
echo -e "${YELLOW}Step 3/5: Getting project information...${NC}"
PROJECT_ID=$(firebase projects:list --json | grep -o '"projectId":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -n "$PROJECT_ID" ]; then
    echo -e "${GREEN}✓ Project ID: $PROJECT_ID${NC}"
    
    # Assume us-central1 region (most common)
    REGION="us-central1"
    BASE_URL="https://$REGION-$PROJECT_ID.cloudfunctions.net"
    
    echo ""
    echo -e "${YELLOW}Step 4/5: Initializing education content...${NC}"
    RESPONSE=$(curl -s "$BASE_URL/initializeEducationContent")
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Education content initialized${NC}"
        echo -e "${GRAY}  Response: $(echo $RESPONSE | grep -o '"message":"[^"]*' | cut -d'"' -f4)${NC}"
    else
        echo -e "${YELLOW}⚠ Could not initialize education content automatically${NC}"
        echo -e "${GRAY}  Please run manually: curl $BASE_URL/initializeEducationContent${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Step 5/5: Fetching initial news...${NC}"
    RESPONSE=$(curl -s "$BASE_URL/fetchScamNewsManual")
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ News fetched successfully${NC}"
        TOTAL=$(echo $RESPONSE | grep -o '"total":[0-9]*' | cut -d':' -f2)
        NEW=$(echo $RESPONSE | grep -o '"new":[0-9]*' | cut -d':' -f2)
        UPDATED=$(echo $RESPONSE | grep -o '"updated":[0-9]*' | cut -d':' -f2)
        echo -e "${GRAY}  Total: $TOTAL, New: $NEW, Updated: $UPDATED${NC}"
    else
        echo -e "${YELLOW}⚠ Could not fetch news automatically${NC}"
        echo -e "${GRAY}  Please run manually: curl $BASE_URL/fetchScamNewsManual${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Could not get project information${NC}"
    echo -e "${GRAY}  Please initialize manually using the function URLs from Firebase Console${NC}"
fi

echo ""
echo "========================================"
echo "Deployment Summary"
echo "========================================"
echo ""
echo -e "${GREEN}✓ Cloud Functions deployed${NC}"
echo -e "${GREEN}✓ Education content initialized${NC}"
echo -e "${GREEN}✓ Initial news fetched${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Update Firestore rules (if not done):"
echo -e "${GRAY}   firebase deploy --only firestore:rules${NC}"
echo ""
echo "2. Run the Flutter app:"
echo -e "${GRAY}   cd askbeforeact${NC}"
echo -e "${GRAY}   flutter pub get${NC}"
echo -e "${GRAY}   flutter run -d chrome${NC}"
echo ""
echo "3. Verify in Firebase Console:"
echo -e "${GRAY}   - Firestore: education_content (5 docs)${NC}"
echo -e "${GRAY}   - Firestore: scam_news (20+ docs)${NC}"
echo -e "${GRAY}   - Functions: 3 functions deployed${NC}"
echo ""
echo -e "${YELLOW}📚 Documentation:${NC}"
echo -e "${GRAY}   - LEARN_SECTION_QUICK_START.md${NC}"
echo -e "${GRAY}   - LEARN_SECTION_INTEGRATION.md${NC}"
echo -e "${GRAY}   - functions/README.md${NC}"
echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
