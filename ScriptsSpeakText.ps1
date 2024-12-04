Write-Host "Débogage : Le script a été lancé"

# Supprime la fonction existante si elle est déjà définie
if (Get-Command Speak-Text -ErrorAction SilentlyContinue) {
    Write-Host "La fonction Speak-Text est déjà disponible. Réinstallation en cours..."
    Remove-Item -Path Function:Speak-Text -ErrorAction SilentlyContinue
}

Write-Host "Installation de la fonction Speak-Text..."
# function Global:Speak-Text {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$Text,

#         [Parameter(Mandatory = $false)]
#         [string]$Voice,

#         [Parameter(Mandatory = $false)]
#         [ValidateRange(0, 100)]
#         [int]$Volume = 100,

#         [Parameter(Mandatory = $false)]
#         [ValidateRange(-10, 10)]
#         [int]$Rate = 0
#     )

#     # Importer le namespace pour la synthèse vocale
#     Add-Type -AssemblyName System.Speech

#     $synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
#     if ($Voice) {
#         $synthesizer.SelectVoice($Voice)
#     }
#     $synthesizer.Volume = $Volume
#     $synthesizer.Rate = $Rate

#     # Lire le texte
#     $synthesizer.Speak($Text)

#     $synthesizer.Dispose()
# }
function Global:Speak-Text {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $false)]
        [string]$Voice,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 100)]
        [int]$Volume = 100,

        [Parameter(Mandatory = $false)]
        [ValidateRange(-10, 10)]
        [int]$Rate = 0
    )

    process {
        # Importer le namespace pour la synthèse vocale
        Add-Type -AssemblyName System.Speech

        $synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
        if ($Voice) {
            $synthesizer.SelectVoice($Voice)
        }
        $synthesizer.Volume = $Volume
        $synthesizer.Rate = $Rate

        # Lire le texte
        $synthesizer.Speak($Text)

        $synthesizer.Dispose()
    }
}


Write-Host "La fonction Speak-Text a été installée."


# Créer un alias global pour Speak-Text
if (Test-Path Alias:spk) {
    Write-Host "L'alias 'spk' existe déjà. Réinstallation en cours..."
    Remove-Item -Path Alias:spk -ErrorAction SilentlyContinue
}

Set-Alias -Name spk -Value Speak-Text -Scope Global
Write-Host "L'alias 'spk' a été créé. Vous pouvez utiliser 'spk \"votre texte\"'."

# Créer une fonction pour convertir la sortie en chaîne et la lire
function Global:tospk {
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $InputObject
    )

    process {
        # Convertir l'entrée en texte lisible
        $Text = $InputObject | Out-String
        # Envoyer le texte à Speak-Text
        spk $Text
    }
}

Write-Host "La fonction 'tospk' a été installée. Utilisez-la pour lire des commandes via le pipeline."