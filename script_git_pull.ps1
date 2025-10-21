# Detiene la ejecución si ocurre un error no controlado
$ErrorActionPreference = "Stop"

# --- CONFIGURACIÓN DE RUTAS ---
$RutaDirectorioBase = "D:\Pruebas\Repositorio"
$RutaLogErrores = "D:\Pruebas\Scripts\git_pull_errores.txt"
$GitExecutable = "C:\Program Files\Git\cmd\git.exe"
# ------------------------------

# Limpia el log solo si existía antes (para no acumular inicios exitosos)
if (Test-Path $RutaLogErrores) {
    Remove-Item $RutaLogErrores -Force
}

# Marca de tiempo inicial en consola
$FechaHoraInicio = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$FechaHoraInicio] --- INICIANDO PROCESO DE PULL MASIVO ---" -ForegroundColor Yellow

# --- OBTENER REPOSITORIOS GIT ---
$Repositorios = Get-ChildItem -Path $RutaDirectorioBase -Directory -Recurse |
    Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git") }

if (-not $Repositorios) {
    Write-Host "❌ No se encontraron repositorios Git en '$RutaDirectorioBase'." -ForegroundColor Red
    exit 1
}

# --- PROCESAR CADA REPOSITORIO ---
foreach ($Repo in $Repositorios) {
    $RutaActual = $Repo.FullName
    Write-Host "`n---> Procesando: $($Repo.Name)" -ForegroundColor Cyan

    Set-Location -Path $RutaActual -ErrorAction Stop

    Write-Host "Ejecutando git pull..." -ForegroundColor Cyan

    $ResultadoGit = & "$GitExecutable" pull 2>&1 | Out-String
    $CodigoSalida = $LASTEXITCODE

    # --- Validación de error real ---
    if ($CodigoSalida -eq 0 -and $ResultadoGit -notmatch "fatal") {
        if ($ResultadoGit -match "Already up to date") {
            Write-Host "✅ Repositorio ya actualizado." -ForegroundColor Green
        }
        elseif ($ResultadoGit -match "Updating" -or $ResultadoGit -match "Fast-forward") {
            Write-Host "🎉 Repositorio actualizado con éxito." -ForegroundColor Green
        }
        else {
            Write-Host "✅ Operación finalizada correctamente." -ForegroundColor Green
        }
    }
    else {
        # --- REGISTRA SOLO SI HAY ERROR REAL ---
        $FechaHoraError = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $MensajeError = "[$FechaHoraError] ERROR en $($Repo.Name): No se pudo realizar el 'git pull'."
        $Detalle = "Detalle: $ResultadoGit"
        Add-Content -Path $RutaLogErrores -Value "$MensajeError`n$Detalle`n--------------------------------------------------"
        Write-Host "❌ ERROR. Revisar log en: $RutaLogErrores" -ForegroundColor Red
    }
}

# --- FINALIZACIÓN ---
$FechaHoraFin = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "`n[$FechaHoraFin] --- PROCESO COMPLETADO ---" -ForegroundColor Yellow
