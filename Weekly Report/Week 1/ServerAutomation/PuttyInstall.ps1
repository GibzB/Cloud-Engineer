# Force TLS 1.2
# Windows Server 2016 may not have TLS 1.2 enabled by default for PowerShell's Invoke-WebRequest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # This line explicitly sets the security protocol to TLS 1.2.

# PuTTY Download URL (Official)
$puttyUrl = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-installer.msi"
$installerPath = "$env:TEMP\putty-installer.msi"

# Download PuTTY
try {
    Write-Host "Downloading PuTTY..."
    Invoke-WebRequest -Uri $puttyUrl -OutFile $installerPath
    Write-Host "Download complete."

    # Install PuTTY (silent install)
    Write-Host "Installing PuTTY..."
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn" -Wait
    Write-Host "PuTTY installation complete."

    # Clean up installer
    Remove-Item $installerPath
    Write-Host "Installer cleaned up."

} catch {
    Write-Error "Error: $($_.Exception.Message)"
}