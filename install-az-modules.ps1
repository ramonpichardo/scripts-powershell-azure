# Launch an administrative PowerShell session.
#Requires -RunAsAdministrator

# Verify this script is running in an administrator security context.
$IsAdmin=[Security.Principal.WindowsIdentity]::GetCurrent()
If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE)
{
      "`nERROR: This script will only run in an administrator context. Run this script after launching a Run As Administrator PowerShell session."
      pause
      exit
}

# Set the execution policy to RemoteSigned to run scripts and load configuration files with PowerCLI.
Set-ExecutionPolicy RemoteSigned -Confirm:$false

# As a default, PSGallery is an untrusted repository. Use Set-PSRepository to make PSGallery trusted.
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories.
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install modules at a global scope.
Install-Module -Name Az -AllowClobber

# Download and install the newest help files on your computer.
Update-Help
