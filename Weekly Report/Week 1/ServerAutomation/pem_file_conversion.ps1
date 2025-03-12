# Script to convert PEM to PPK using PuTTYgen

# Set variables
$pemFilePath = "$env:USERPROFILE\Desktop\yourkey.pem" # Replace with your PEM file path
$ppkFilePath = "$env:USERPROFILE\Desktop\yourkey.ppk" # Replace with your desired PPK file path
$puttygenPath = "C:\Program Files\PuTTY\puttygen.exe" # Default PuTTYgen path

# Check if PuTTYgen exists
if (-not (Test-Path $puttygenPath)) {
    Write-Error "PuTTYgen not found at '$puttygenPath'. Please install PuTTY or adjust the path."
    return
}

# Check if the PEM file exists
if (-not (Test-Path $pemFilePath)) {
    Write-Error "PEM file not found at '$pemFilePath'."
    return
}

# Convert PEM to PPK
try {
    & $puttygenPath $pemFilePath -o $ppkFilePath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PEM file converted to PPK successfully: '$ppkFilePath'"
    } else {
        Write-Error "PuTTYgen returned an error (Exit Code: $($LASTEXITCODE))."
    }

} catch {
    Write-Error "An error occurred during conversion: $($_.Exception.Message)"
}