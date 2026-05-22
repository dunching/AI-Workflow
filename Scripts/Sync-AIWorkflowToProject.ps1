param(
    [string]$TemplateRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$ProjectRoot = (Get-Location).Path,
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $FullPath = [System.IO.Path]::GetFullPath($Path)
    return $FullPath.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
}

function Assert-PathInside {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $ResolvedPath = Resolve-FullPath $Path
    $ResolvedRoot = Resolve-FullPath $Root
    if ($ResolvedPath -ne $ResolvedRoot -and -not $ResolvedPath.StartsWith($ResolvedRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "$Label is outside expected root. path=$ResolvedPath root=$ResolvedRoot"
    }
}

function Assert-NotAIStatePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $ResolvedProjectRoot = Resolve-FullPath $ProjectRoot
    $AIStateRoot = Resolve-FullPath (Join-Path $ResolvedProjectRoot "Docs\AI_STATE")
    $ResolvedPath = Resolve-FullPath $Path
    if ($ResolvedPath -eq $AIStateRoot -or $ResolvedPath.StartsWith($AIStateRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to write into project-specific state: $ResolvedPath"
    }
}

function Copy-TemplateFile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    Assert-PathInside -Path $Source -Root $TemplateRoot -Label "Source"
    Assert-PathInside -Path $Destination -Root $ProjectRoot -Label "Destination"
    Assert-NotAIStatePath -Path $Destination

    if ($Apply) {
        $DestinationDirectory = Split-Path -Parent $Destination
        New-Item -ItemType Directory -Path $DestinationDirectory -Force | Out-Null
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        Write-Host "COPIED $Source -> $Destination"
    }
    else {
        Write-Host "DRY-RUN copy $Source -> $Destination"
    }
}

$TemplateRoot = Resolve-FullPath $TemplateRoot
$ProjectRoot = Resolve-FullPath $ProjectRoot

$Mappings = @(
    @{
        Source = Join-Path $TemplateRoot "PROJECT_README.md"
        Destination = Join-Path $ProjectRoot "Docs\README.md"
    }
)

foreach ($Mapping in $Mappings) {
    Copy-TemplateFile -Source $Mapping.Source -Destination $Mapping.Destination
}

$DirectoryMappings = @(
    @{
        SourceRoot = Join-Path $TemplateRoot "AI_ENTRY"
        DestinationRoot = Join-Path $ProjectRoot "Docs\AI_ENTRY"
    },
    @{
        SourceRoot = Join-Path $TemplateRoot "AI_WORKFLOW"
        DestinationRoot = Join-Path $ProjectRoot "Docs\AI_WORKFLOW"
    }
)

foreach ($DirectoryMapping in $DirectoryMappings) {
    $SourceRoot = Resolve-FullPath $DirectoryMapping.SourceRoot
    $DestinationRoot = Resolve-FullPath $DirectoryMapping.DestinationRoot
    Assert-PathInside -Path $SourceRoot -Root $TemplateRoot -Label "SourceRoot"
    Assert-PathInside -Path $DestinationRoot -Root $ProjectRoot -Label "DestinationRoot"
    Assert-NotAIStatePath -Path $DestinationRoot

    if (-not (Test-Path $SourceRoot)) {
        throw "Template source directory is missing: $SourceRoot"
    }

    Get-ChildItem -LiteralPath $SourceRoot -Recurse -File | ForEach-Object {
        $RelativePath = $_.FullName.Substring($SourceRoot.Length).TrimStart("\", "/")
        $Destination = Join-Path $DestinationRoot $RelativePath
        Copy-TemplateFile -Source $_.FullName -Destination $Destination
    }
}

if (-not $Apply) {
    Write-Host "Dry-run complete. Re-run with -Apply to copy files."
}

