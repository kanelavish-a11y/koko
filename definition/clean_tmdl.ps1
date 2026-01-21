# Remove the linguisticMetadata section from database.tmdl
$filePath = "c:\Users\home\MicrosoftWorkspace\PowerBI-Projects\2026-01-AttritionReport\definition\database.tmdl"

# Read all lines
$lines = Get-Content $filePath

Write-Host "Total lines before: $($lines.Count)"

# Keep only lines 1-2095 (index 0-2094) - this removes the cultureInfo section
$newLines = $lines[0..2094]

Write-Host "Total lines after: $($newLines.Count)"

# Write back
$newLines | Set-Content $filePath -Encoding UTF8

Write-Host "File updated successfully"
