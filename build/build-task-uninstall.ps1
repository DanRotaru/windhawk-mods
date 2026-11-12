<#
.SYNOPSIS
    Removes the elevated Windhawk deploy task that build.ps1 -InstallDeployTask
    registered, and its protected script copy in %ProgramData%.

.DESCRIPTION
    After this, build.ps1 deploys with a UAC prompt again. Shows one UAC
    prompt itself unless run from an elevated terminal.

.EXAMPLE
    .\build-task-uninstall.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$TaskName = 'WindhawkModDeploy'
$TaskDir = Join-Path $env:ProgramData 'WindhawkModDeploy'
$RequestDir = Join-Path $env:LOCALAPPDATA 'WindhawkModDeploy'

$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = ([Security.Principal.WindowsPrincipal]$id).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) -and
        -not (Test-Path $TaskDir)) {
        Write-Host 'Deploy task is not installed.' -ForegroundColor Yellow
        exit 0
    }
    $shell = (Get-Process -Id $PID).Path
    $p = Start-Process $shell -Verb RunAs -Wait -PassThru -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
    if ($p.ExitCode -eq 0) {
        # The request folder is per user, not elevated-only.
        Remove-Item $RequestDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host 'Deploy task removed.' -ForegroundColor Green
    } else {
        Write-Host 'Removing the deploy task failed.' -ForegroundColor Red
    }
    exit $p.ExitCode
}

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item $TaskDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $RequestDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'Deploy task removed.' -ForegroundColor Green
exit 0
