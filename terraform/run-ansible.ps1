# Script PowerShell pour exécuter Ansible sur Windows
# Usage: .\run-ansible.ps1

Write-Host "=== Exécution d'Ansible Playbook ===" -ForegroundColor Green

# Configuration des variables d'environnement
$env:ANSIBLE_HOST_KEY_CHECKING = "False"
$env:ANSIBLE_SSH_RETRIES = "3"
$env:ANSIBLE_TIMEOUT = "30"

# Chemins
$inventoryPath = "../ansible/inventory.yml"
$playbookPath = "../ansible/playbooks/site.yml"

Write-Host "Vérification des fichiers..." -ForegroundColor Yellow
if (-not (Test-Path $inventoryPath)) {
    Write-Host "ERREUR: Fichier d'inventaire non trouvé: $inventoryPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $playbookPath)) {
    Write-Host "ERREUR: Playbook non trouvé: $playbookPath" -ForegroundColor Red
    exit 1
}

Write-Host "Inventaire: $inventoryPath" -ForegroundColor Cyan
Write-Host "Playbook: $playbookPath" -ForegroundColor Cyan

# Tentative d'installation d'Ansible si nécessaire
try {
    Write-Host "Vérification d'Ansible..." -ForegroundColor Yellow
    
    # Essayer avec WSL (Windows Subsystem for Linux) si disponible
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        Write-Host "WSL détecté, utilisation d'Ansible via WSL..." -ForegroundColor Green
        
        # Copier les fichiers vers WSL si nécessaire
        wsl ansible-playbook --version
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Exécution du playbook via WSL..." -ForegroundColor Green
            wsl ansible-playbook -i $inventoryPath $playbookPath
            exit $LASTEXITCODE
        }
    }
    
    # Fallback: exécution manuelle
    Write-Host "Ansible n'est pas disponible ou compatible." -ForegroundColor Yellow
    Write-Host "Pour exécuter manuellement:" -ForegroundColor White
    Write-Host "1. Installer Ansible via WSL ou Docker" -ForegroundColor White
    Write-Host "2. Ou configurer les serveurs manuellement" -ForegroundColor White
    
    Write-Host "`nContenu de l'inventaire généré:" -ForegroundColor Cyan
    Get-Content $inventoryPath
    
} catch {
    Write-Host "Erreur lors de l'exécution d'Ansible: $_" -ForegroundColor Red
    Write-Host "Vous devrez configurer les serveurs manuellement." -ForegroundColor Yellow
    exit 1
}
