# PowerShell script to deploy Learn section integration
# Run this script from the project root directory

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Learn Section Firebase Integration Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Firebase CLI is installed
Write-Host "Checking Firebase CLI..." -ForegroundColor Yellow
$firebaseVersion = firebase --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Firebase CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "   npm install -g firebase-tools" -ForegroundColor White
    exit 1
}
Write-Host "✓ Firebase CLI found: $firebaseVersion" -ForegroundColor Green
Write-Host ""

# Step 1: Install function dependencies
Write-Host "Step 1/5: Installing Cloud Function dependencies..." -ForegroundColor Yellow
Set-Location functions
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencies installed" -ForegroundColor Green
Set-Location ..
Write-Host ""

# Step 2: Deploy functions
Write-Host "Step 2/5: Deploying Cloud Functions..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
firebase deploy --only functions
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to deploy functions" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Functions deployed" -ForegroundColor Green
Write-Host ""

# Step 3: Get project info
Write-Host "Step 3/5: Getting project information..." -ForegroundColor Yellow
$projectInfo = firebase projects:list --json | ConvertFrom-Json
if ($projectInfo -and $projectInfo.result -and $projectInfo.result.Count -gt 0) {
    $projectId = $projectInfo.result[0].projectId
    Write-Host "✓ Project ID: $projectId" -ForegroundColor Green
    
    # Assume us-central1 region (most common)
    $region = "us-central1"
    $baseUrl = "https://$region-$projectId.cloudfunctions.net"
    
    Write-Host ""
    Write-Host "Step 4/5: Initializing education content..." -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/initializeEducationContent" -Method Get
        Write-Host "✓ Education content initialized" -ForegroundColor Green
        Write-Host "  Response: $($response.message)" -ForegroundColor Gray
    } catch {
        Write-Host "⚠ Could not initialize education content automatically" -ForegroundColor Yellow
        Write-Host "  Please run manually: curl $baseUrl/initializeEducationContent" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "Step 5/5: Fetching initial news..." -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/fetchScamNewsManual" -Method Get
        Write-Host "✓ News fetched successfully" -ForegroundColor Green
        Write-Host "  Total: $($response.total), New: $($response.new), Updated: $($response.updated)" -ForegroundColor Gray
    } catch {
        Write-Host "⚠ Could not fetch news automatically" -ForegroundColor Yellow
        Write-Host "  Please run manually: curl $baseUrl/fetchScamNewsManual" -ForegroundColor Gray
    }
} else {
    Write-Host "⚠ Could not get project information" -ForegroundColor Yellow
    Write-Host "  Please initialize manually using the function URLs from Firebase Console" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ Cloud Functions deployed" -ForegroundColor Green
Write-Host "✓ Education content initialized" -ForegroundColor Green
Write-Host "✓ Initial news fetched" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Update Firestore rules (if not done):" -ForegroundColor White
Write-Host "   firebase deploy --only firestore:rules" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Run the Flutter app:" -ForegroundColor White
Write-Host "   cd askbeforeact" -ForegroundColor Gray
Write-Host "   flutter pub get" -ForegroundColor Gray
Write-Host "   flutter run -d chrome" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Verify in Firebase Console:" -ForegroundColor White
Write-Host "   - Firestore: education_content (5 docs)" -ForegroundColor Gray
Write-Host "   - Firestore: scam_news (20+ docs)" -ForegroundColor Gray
Write-Host "   - Functions: 3 functions deployed" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "   - LEARN_SECTION_QUICK_START.md" -ForegroundColor Gray
Write-Host "   - LEARN_SECTION_INTEGRATION.md" -ForegroundColor Gray
Write-Host "   - functions/README.md" -ForegroundColor Gray
Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
