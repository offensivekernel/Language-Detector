Write-Host @"
****************************************************
*    Script Name: Code Language Detector           *
*             Made by Ashutosh Yadav               *
*       Website: www.offensivekernel.com           *
*            GitHub: offensivekernel               *
****************************************************
"@

$folder = Read-Host "Enter the folder path"

if (-not (Test-Path -Path $folder -PathType Container)) {
    Write-Host "Folder does not exist."
    exit 1
}

# Define a hashtable to map file extensions to languages
$languageMap = @{
    ".java" = "Java"
    ".xml" = "XML"
    ".js" = "JavaScript"
    ".css" = "CSS"
    ".scss" = "SCSS"
    ".ts" = "TypeScript"
    ".plsql" = "PL/SQL"
    ".php" = "PHP"
    ".groovy" = "Groovy"
    ".less" = "Less"
    ".ini" = "INI"
    ".html" = "HTML"
    ".kotlin" = "Kotlin"
    ".swift" = "Swift"
    ".m" = "Objective-C"
    ".jsx" = "React JS"
    ".rb" = "Ruby"
}

$languageDetected = $false
$detectedLanguages = @{}
$codeLinesCount = @{}

# Function to count lines of code in a file
function CountCodeLines($filePath) {
    $codeLines = Get-Content -Path $filePath
    $codeLinesCount = $codeLines.Count
    return $codeLinesCount
}

# Iterate through files in the specified folder and its subfolders
Get-ChildItem -Path $folder -Recurse | ForEach-Object {
    $file = $_.Name
    $extension = $_.Extension.ToLower()

    # Check if the file extension is mapped to a language
    if ($languageMap.ContainsKey($extension)) {
        $language = $languageMap[$extension]
        $detectedLanguages[$file] = $language
        $languageDetected = $true

        # Count lines of code for the file
        $codeLinesCount[$file] = CountCodeLines($_.FullName)
    }
}

if (-not $languageDetected) {
    Write-Host "Unable to detect the Language"
} else {
    Write-Host "*********************************************************************************"
    $singleLanguageDetected = $true
    foreach ($key in $detectedLanguages.Keys) {
        if (($detectedLanguages[$key] -split ",").Count -gt 1) {
            $singleLanguageDetected = $false
            break
        }
    }
    if ($singleLanguageDetected) {
        foreach ($key in $detectedLanguages.Keys) {
            Write-Host "${key}: $($detectedLanguages[$key])"
            Write-Host "Lines of Code: $($codeLinesCount[$key])"
        }
    } else {
        foreach ($key in $detectedLanguages.Keys) {
            Write-Host "${key}: Multiple Languages Detected"
            Write-Host "Detected Languages : $($detectedLanguages[$key] -split ',')"
            Write-Host "Lines of Code: $($codeLinesCount[$key])"
        }
    }

    # Total lines of code across all files
    $totalLinesOfCode = ($codeLinesCount.Values | Measure-Object -Sum).Sum
    Write-Host "Total Lines of Code (including blank lines): $totalLinesOfCode"

    # Display all detected languages
    $allLanguages = $detectedLanguages.Values | Select-Object -Unique
    Write-Host "All Detected Languages: $($allLanguages -join ', ')"
}
