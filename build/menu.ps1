<#
.SYNOPSIS
    Pick a mod from the repo with the arrow keys, then compile and deploy it
    with build.ps1. build.bat runs this when started without arguments.

.DESCRIPTION
    Up/Down (or k/j), Home/End, 1-9 to jump, Enter to build, Esc/q to quit.
    Arguments are passed through to build.ps1 (e.g. -CompileOnly, -Release).
#>
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path $PSScriptRoot -Parent
$BuildScript = Join-Path $PSScriptRoot 'build.ps1'

# One entry per repo folder that has a *.wh.cpp, with @name/@version from its
# ==WindhawkMod== block.
function Get-Mods {
    foreach ($dir in Get-ChildItem $RepoRoot -Directory | Sort-Object Name) {
        $src = Join-Path $dir.FullName "$($dir.Name).wh.cpp"
        if (-not (Test-Path $src)) {
            $src = Get-ChildItem $dir.FullName -Filter '*.wh.cpp' -File |
                Select-Object -First 1 -ExpandProperty FullName
        }
        if (-not $src) { continue }
        $name = ''; $version = ''
        foreach ($line in Get-Content $src -TotalCount 40 -Encoding UTF8) {
            if ($line -match '^\s*//\s*@name\s+(.*?)\s*$') { $name = $Matches[1] }
            elseif ($line -match '^\s*//\s*@version\s+(.*?)\s*$') { $version = $Matches[1] }
            elseif ($line -match '==/WindhawkMod==') { break }
        }
        [pscustomobject]@{ Folder = $dir.Name; Name = $name; Version = $version }
    }
}

function Show-Menu($mods) {
    $width = ($mods | ForEach-Object { $_.Folder.Length } | Measure-Object -Maximum).Maximum
    $verWidth = ($mods | ForEach-Object { $_.Version.Length } | Measure-Object -Maximum).Maximum

    Write-Host ''
    Write-Host "  DanRotaru's Windhawk mod build" -ForegroundColor Cyan
    Write-Host '  Up/Down select   Enter build   Esc quit' -ForegroundColor DarkGray
    Write-Host ''
    # Reserve the lines first so the console has scrolled before the cursor
    # position is taken.
    foreach ($m in $mods) { Write-Host '' }
    $top = [Console]::CursorTop - $mods.Count

    $sel = 0
    $cursorWas = [Console]::CursorVisible
    [Console]::CursorVisible = $false
    try {
        while ($true) {
            $lineWidth = [Math]::Max(1, [Console]::WindowWidth - 1)
            for ($i = 0; $i -lt $mods.Count; $i++) {
                [Console]::SetCursorPosition(0, $top + $i)
                $m = $mods[$i]
                $key = if ($i -lt 9) { "$($i + 1)" } else { ' ' }
                $text = ('  {0} {1} {2}  {3}  {4}' -f
                    $(if ($i -eq $sel) { '>' } else { ' ' }), $key,
                    $m.Folder.PadRight($width), $m.Version.PadRight($verWidth), $m.Name)
                if ($text.Length -gt $lineWidth) { $text = $text.Substring(0, $lineWidth) }
                $text = $text.PadRight($lineWidth)
                if ($i -eq $sel) {
                    Write-Host $text -ForegroundColor Black -BackgroundColor Cyan -NoNewline
                } else {
                    Write-Host $text -NoNewline
                }
            }
            [Console]::SetCursorPosition(0, $top + $mods.Count)

            $k = [Console]::ReadKey($true)
            switch ($k.Key) {
                'UpArrow'   { $sel = ($sel - 1 + $mods.Count) % $mods.Count }
                'DownArrow' { $sel = ($sel + 1) % $mods.Count }
                'K'         { $sel = ($sel - 1 + $mods.Count) % $mods.Count }
                'J'         { $sel = ($sel + 1) % $mods.Count }
                'Home'      { $sel = 0 }
                'End'       { $sel = $mods.Count - 1 }
                'Enter'     { return $mods[$sel] }
                'Escape'    { return $null }
                'Q'         { return $null }
            }
            if ($k.KeyChar -ge '1' -and $k.KeyChar -le '9') {
                $n = [int][string]$k.KeyChar - 1
                if ($n -lt $mods.Count) { $sel = $n }
            }
        }
    } finally {
        [Console]::CursorVisible = $cursorWas
    }
}

$mods = @(Get-Mods)
if ($mods.Count -eq 0) {
    Write-Host "No mods (folders with a *.wh.cpp) found in $RepoRoot." -ForegroundColor Red
    exit 1
}

$choice = Show-Menu $mods
if (-not $choice) {
    Write-Host 'Cancelled.' -ForegroundColor DarkGray
    exit 0
}

Write-Host ''
Write-Host "Building $($choice.Folder)..." -ForegroundColor Cyan
Write-Host ''
try {
    & $BuildScript $choice.Folder @args
    exit $LASTEXITCODE
} catch {
    Write-Host "Build failed: $_" -ForegroundColor Red
    exit 1
}
