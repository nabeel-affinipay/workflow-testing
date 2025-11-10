#!/bin/bash

# Script to set up branch protection rules to require PR Evidence Check
# This will block merging if the check fails

echo "Setting up branch protection for 'main' branch..."
echo "This will require the 'PR Evidence Check / check-description' check to pass before merging."

# Create a temporary JSON file with the branch protection settings
TEMP_JSON=$(mktemp)
cat > "$TEMP_JSON" <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["PR Evidence Check / check-description"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0
  },
  "restrictions": null
}
EOF

# Apply branch protection using the JSON file
gh api repos/nabeel-affinipay/workflow-testing/branches/main/protection \
  --method PUT \
  --input "$TEMP_JSON"

EXIT_CODE=$?

# Clean up temporary file
rm -f "$TEMP_JSON"

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ Branch protection rules configured successfully!"
  echo "The 'PR Evidence Check / check-description' check is now required."
  echo "PRs with failing checks will not be able to merge."
else
  echo "❌ Failed to set up branch protection. Make sure:"
  echo "   1. You have admin access to the repository"
  echo "   2. GitHub CLI is authenticated (run: gh auth login)"
fi

