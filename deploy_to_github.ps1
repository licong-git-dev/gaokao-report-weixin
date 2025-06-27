# PowerShell script to deploy the website to GitHub

# --- Instructions ---
# 1. Right-click on this file in your file explorer.
# 2. Select "Run with PowerShell".
# 3. A terminal window will open and execute the commands.
# 4. You might be prompted to log in to your GitHub account in a new window.
# 5. After the script finishes, your files will be on GitHub.
# --------------------

# Set text color for green for better readability of instructions
Write-Host "--- GitHub Deployment Script ---" -ForegroundColor Green
Write-Host "This script will upload your website files to GitHub." -ForegroundColor Green
Write-Host "Please follow any on-screen prompts, especially for logging in." -ForegroundColor Green
Write-Host "------------------------------------------------------------"

# 1. Set user identity for Git
# This is a necessary step for making a commit.
Write-Host "Step 1: Configuring Git user..."
git config --global user.name "licong-git-dev"
git config --global user.email "licong-git-dev@users.noreply.github.com"
Write-Host "Git user configured." -ForegroundColor Green

# 2. Add all files to the staging area
Write-Host "Step 2: Adding files to commit..."
git add .
Write-Host "Files added." -ForegroundColor Green

# 3. Commit the files
# We check if there's anything to commit first.
$git_status = git status --porcelain
if ($git_status) {
    Write-Host "Step 3: Committing files..."
    git commit -m "Initial commit: Add report website files"
    Write-Host "Files committed." -ForegroundColor Green
} else {
    Write-Host "Step 3: No changes to commit, skipping commit." -ForegroundColor Yellow
}

# 4. Rename the default branch to 'main'
Write-Host "Step 4: Setting default branch to 'main'..."
git branch -M main
Write-Host "Branch renamed." -ForegroundColor Green

# 5. Connect to the remote GitHub repository
# We first remove any existing 'origin' to avoid errors on re-runs.
$remote_exists = git remote | Where-Object { $_ -eq "origin" }
if ($remote_exists) {
    Write-Host "Removing existing remote 'origin'..."
    git remote remove origin
}
Write-Host "Step 5: Connecting to your GitHub repository using SSH..."
git remote add origin git@github.com:licong-git-dev/gaokao-report.git
Write-Host "Connected to GitHub repository." -ForegroundColor Green

# 6. Push the files to GitHub
Write-Host "Step 6: Pushing files to GitHub... This may require you to log in."
git push -u origin main

Write-Host "------------------------------------------------------------"
Write-Host "Deployment complete!" -ForegroundColor Cyan
Write-Host "Your files should now be in your GitHub repository." -ForegroundColor Cyan
Write-Host "You can now set up GitHub Pages in your repository settings to get a public link." -ForegroundColor Cyan
Read-Host "Press Enter to exit" 