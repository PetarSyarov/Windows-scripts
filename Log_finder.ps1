param(
    [string]$Path = "C:\",
    [int]$MinSizeMB = 5,
    [int]$OlderThanMonths = 3
)

$startTime = Get-Date
$cutoffDate = (Get-Date).AddMonths(-$OlderThanMonths)
$minSizeBytes = $MinSizeMB * 1MB

$logFolderNames = @("Log", "Logs", "LogFiles", "Logging")
$dumpExtensions = @(".dmp", ".mdmp")

$logFoldersFound = 0
$logFilesFound = 0
$dumpFoldersFound = 0
$dumpFilesFound = 0
$totalSizeBytes = 0
$accessDeniedPaths = 0

try {
    $allFolders = Get-ChildItem -Path $Path -Directory -Recurse -ErrorAction SilentlyContinue
}
catch {
    Write-Host "Failed to scan root path: $Path"
    exit 1
}

$logFolders = $allFolders | Where-Object { $logFolderNames -contains $_.Name }

foreach ($folder in $logFolders) {
    try {
        $matchingFiles = Get-ChildItem -Path $folder.FullName -File -Recurse -ErrorAction SilentlyContinue |
            Where-Object {
                $_.Length -gt $minSizeBytes -and
                $_.LastWriteTime -lt $cutoffDate
            }
    }
    catch {
        $accessDeniedPaths++
        continue
    }

    if ($matchingFiles.Count -gt 0) {
        $folderSizeBytes = ($matchingFiles | Measure-Object Length -Sum).Sum
        $folderSizeMB = [math]::Round($folderSizeBytes / 1MB, 2)

        $oldestFile = $matchingFiles |
            Sort-Object LastWriteTime |
            Select-Object -First 1

        $largestFile = $matchingFiles |
            Sort-Object Length -Descending |
            Select-Object -First 1

        $largestFileMB = [math]::Round($largestFile.Length / 1MB, 2)

        $logFoldersFound++
        $logFilesFound += $matchingFiles.Count
        $totalSizeBytes += $folderSizeBytes

        Write-Host ""
        Write-Host "LOG FOLDER REPORT"
        Write-Host "========================================="
        Write-Host "Folder       : $($folder.FullName)"
        Write-Host "Files Found  : $($matchingFiles.Count)"
        Write-Host "Total Size   : $folderSizeMB MB"
        Write-Host "Oldest File  : $($oldestFile.LastWriteTime.ToString('yyyy-MM-dd'))"
        Write-Host "Largest File : $($largestFile.Name) ($largestFileMB MB)"
        Write-Host "========================================="
    }
}

$dumpGroups = @{}

try {
    $dumpFiles = Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object {
            $dumpExtensions -contains $_.Extension.ToLower() -and
            $_.Length -gt $minSizeBytes -and
            $_.LastWriteTime -lt $cutoffDate
        }
}
catch {
    $accessDeniedPaths++
    $dumpFiles = @()
}

foreach ($dump in $dumpFiles) {
    $parent = $dump.DirectoryName

    if (-not $dumpGroups.ContainsKey($parent)) {
        $dumpGroups[$parent] = @()
    }

    $dumpGroups[$parent] += $dump
}

foreach ($folderPath in $dumpGroups.Keys) {
    $files = $dumpGroups[$folderPath]

    if ($files.Count -gt 0) {
        $folderSizeBytes = ($files | Measure-Object Length -Sum).Sum
        $folderSizeMB = [math]::Round($folderSizeBytes / 1MB, 2)

        $oldestFile = $files |
            Sort-Object LastWriteTime |
            Select-Object -First 1

        $largestFile = $files |
            Sort-Object Length -Descending |
            Select-Object -First 1

        $largestFileMB = [math]::Round($largestFile.Length / 1MB, 2)

        $dumpFoldersFound++
        $dumpFilesFound += $files.Count
        $totalSizeBytes += $folderSizeBytes

        Write-Host ""
        Write-Host "CRASH DUMP REPORT"
        Write-Host "========================================="
        Write-Host "Folder       : $folderPath"
        Write-Host "Files Found  : $($files.Count)"
        Write-Host "Total Size   : $folderSizeMB MB"
        Write-Host "Oldest File  : $($oldestFile.LastWriteTime.ToString('yyyy-MM-dd'))"
        Write-Host "Largest File : $($largestFile.Name) ($largestFileMB MB)"
        Write-Host "========================================="
    }
}

$endTime = Get-Date
$scanTime = $endTime - $startTime
$totalSizeGB = [math]::Round($totalSizeBytes / 1GB, 2)

Write-Host ""
Write-Host "SCAN SUMMARY"
Write-Host "========================================="
Write-Host "Log Folders Found   : $logFoldersFound"
Write-Host "Log Files Found     : $logFilesFound"
Write-Host "Dump Folders Found  : $dumpFoldersFound"
Write-Host "Dump Files Found    : $dumpFilesFound"
Write-Host "Total Size          : $totalSizeGB GB"
Write-Host "Access Denied Paths : $accessDeniedPaths"
Write-Host "Scan Time           : $($scanTime.ToString('hh\:mm\:ss'))"
Write-Host "========================================="