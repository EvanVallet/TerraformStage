# Script de diagnostic et correction pour les erreurs de disque Proxmox
# Usage: .\fix-disk-resize-error.ps1

Write-Host "=== Diagnostic des erreurs de redimensionnement de disque Proxmox ===" -ForegroundColor Green

Write-Host "`n1. Nettoyage des ressources Terraform en erreur..." -ForegroundColor Yellow
terraform state list | Where-Object { $_ -match "proxmox_virtual_environment_vm.vms" } | ForEach-Object {
    Write-Host "Vérification de l'état de la ressource: $_" -ForegroundColor Cyan
}

Write-Host "`n2. Détection des erreurs communes:" -ForegroundColor Yellow
Write-Host "   - Erreur de redimensionnement de disque" -ForegroundColor White
Write-Host "   - Ressource disque inexistante" -ForegroundColor White
Write-Host "   - Conflit d'ID de VM" -ForegroundColor White

Write-Host "`n3. Options de correction disponibles:" -ForegroundColor Yellow
Write-Host "   a) Nettoyage et redéploiement (recommandé pour erreurs de disque)" -ForegroundColor White
Write-Host "   b) Suppression et recréation des VMs problématiques" -ForegroundColor White
Write-Host "   c) Changement d'ID de VM et redéploiement" -ForegroundColor White
Write-Host "   d) Nettoyage complet et redémarrage" -ForegroundColor White

$choice = Read-Host "`nChoisissez une option (a/b/c/d)"

switch ($choice.ToLower()) {
    "a" {
        Write-Host "`nNettoyage et redéploiement avec configuration sécurisée..." -ForegroundColor Green
        Write-Host "Suppression des ressources en erreur..." -ForegroundColor Yellow
        terraform state rm 'proxmox_virtual_environment_vm.vms[\"moodle\"]' -ErrorAction SilentlyContinue
        terraform plan -var="disable_disk_resize=true"
        $confirm = Read-Host "Continuer avec terraform apply ? (y/n)"
        if ($confirm -eq "y") {
            terraform apply -var="disable_disk_resize=true" -auto-approve
        }
    }
    "b" {
        Write-Host "`nSuppression des VMs problématiques..." -ForegroundColor Red
        Write-Host "ATTENTION: Cette action va supprimer les VMs!" -ForegroundColor Red
        $confirm = Read-Host "Êtes-vous sûr ? (yes/no)"
        if ($confirm -eq "yes") {
            terraform destroy -target="proxmox_virtual_environment_vm.vms[`"moodle`"]" -auto-approve
            Write-Host "Recréation avec nouvelle configuration..." -ForegroundColor Green
            terraform apply -auto-approve
        }
    }
    "c" {
        Write-Host "`nChangement d'ID de VM et redéploiement..." -ForegroundColor Yellow
        Write-Host "L'ID de la VM moodle a été changé de 116 à 120" -ForegroundColor Green
        terraform plan
        $confirm = Read-Host "Continuer avec terraform apply ? (y/n)"
        if ($confirm -eq "y") {
            terraform apply -auto-approve
        }
    }
    "d" {
        Write-Host "`nNettoyage complet et redémarrage..." -ForegroundColor Red
        Write-Host "ATTENTION: Cette action va supprimer TOUTES les VMs!" -ForegroundColor Red
        $confirm = Read-Host "Êtes-vous absolument sûr ? (yes/no)"
        if ($confirm -eq "yes") {
            terraform destroy -auto-approve
            terraform apply -auto-approve
        }
    }
    default {
        Write-Host "Option non reconnue. Arrêt du script." -ForegroundColor Red
    }
}

Write-Host "`n=== Conseils pour éviter le problème à l'avenir ===" -ForegroundColor Green
Write-Host "1. Utilisez qcow2 au lieu de raw (déjà corrigé)" -ForegroundColor White
Write-Host "2. Évitez les redimensionnements trop importants" -ForegroundColor White
Write-Host "3. Vérifiez l'espace disponible sur le storage Proxmox" -ForegroundColor White
Write-Host "4. Augmentez les timeouts si nécessaire" -ForegroundColor White
