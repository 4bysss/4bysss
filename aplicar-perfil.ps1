[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$RepoPath
)

$ErrorActionPreference = "Stop"
$PackagePath = $PSScriptRoot
$ResolvedRepo = (Resolve-Path $RepoPath).Path

if (-not (Test-Path (Join-Path $ResolvedRepo ".git") -PathType Container)) {
    throw "La ruta indicada no parece un repositorio Git: $ResolvedRepo"
}

Write-Host "Aplicando el perfil en: $ResolvedRepo"

# Elimina únicamente los workflows antiguos relacionados con Snake.
$SnakeFiles = @(
    (Join-Path $ResolvedRepo "Snake.yml"),
    (Join-Path $ResolvedRepo ".github\workflows\Snake.yml"),
    (Join-Path $ResolvedRepo ".github\workflows\snake.yml")
)

foreach ($File in $SnakeFiles) {
    if (Test-Path $File) {
        Remove-Item $File -Force
        Write-Host "Eliminado: $File"
    }
}

# Crea las carpetas necesarias antes de copiar.
New-Item -ItemType Directory -Force -Path (Join-Path $ResolvedRepo ".github\workflows") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ResolvedRepo "scripts") | Out-Null

Copy-Item (Join-Path $PackagePath "README.md") (Join-Path $ResolvedRepo "README.md") -Force
Copy-Item (Join-Path $PackagePath "AGENTS.md") (Join-Path $ResolvedRepo "AGENTS.md") -Force
Copy-Item (Join-Path $PackagePath "llms.txt") (Join-Path $ResolvedRepo "llms.txt") -Force
Copy-Item (Join-Path $PackagePath "scripts\gen-pacman.mjs") (Join-Path $ResolvedRepo "scripts\gen-pacman.mjs") -Force
Copy-Item (Join-Path $PackagePath ".github\workflows\profile-art.yml") (Join-Path $ResolvedRepo ".github\workflows\profile-art.yml") -Force

Write-Host ""
Write-Host "Archivos copiados. Revisa los cambios con:"
Write-Host "  cd `"$ResolvedRepo`""
Write-Host "  git status"
Write-Host "  git diff"
Write-Host ""
Write-Host "Después ejecuta:"
Write-Host "  git add ."
Write-Host "  git commit -m `"Revamp GitHub profile with Pac-Man and professional stack`""
Write-Host "  git push origin main"
