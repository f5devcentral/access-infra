<#
	.DESCRIPTION
		This script is designed to provide a convenient way to control the RestAPI demo server.
	.EXAMPLE
        Control-RestServer.ps1 -Action start -ServerCertSubj "f5lab.local"
	.PARAMS
        -Action
            Specifies the action to be performed: Start, Stop, Test
        -ServerCertSubj
            Specifies computer certificate subject to be used by HTTPS listener
        -UserCertSubj
            Specifies user certificate subject to be used for communication with RestServer (Stop or Test)
#>
param(
[Parameter(Mandatory=$True)]
[ValidateNotNull()]
$Action,
$ServerCertSubj="f5lab.local",
$UserCertSubj="apiadmin"
)

# Bypass SSL verification if RestServer uses untrusted certificate.
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

# Test if RSAT-AD-PowerShell feature is installed. It will be installed if not.
if ((Get-WindowsFeature RSAT-AD-PowerShell).installed) {
    Write-Host -ForegroundColor Green "Test: RSAT PowerShell Active Directory module is installed."
} else {
    Write-Host -ForegroundColor Green "Test: RSAT PowerShell Active Directory module is NOT installed. Installation..."
    Install-WindowsFeature RSAT-AD-PowerShell
}
Import-Module ActiveDirectory

# If Action parameter is "Start"
if ($Action -eq "start") {
    $ServerCert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -Match ".*$ServerCertSubj*"}
    if (!$ServerCert) { Write-Host -ForegroundColor Red "Error: The computer certificate with subject $ServerCertSubj not found!"; exit }
    Start-RestPSListener -Port 8443 -SSLThumbprint $ServerCert.Thumbprint -VerificationType VerifyRootCA

}

# If Action parameter is "Stop"
if ($Action -eq "stop") {
    $UserCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Subject -Match ".*$UserCertSubj*"}
    if (!$UserCert) { Write-Host -ForegroundColor Red "Error: The user certificate with subject $UserCertSubj not found!"; exit }
    Invoke-RestMethod -Uri "https://localhost:8443/endpoint/shutdown" -Method Get -Certificate $UserCert
}

# If Action parameter is "Test"
if ($Action -eq "test") {
    $UserCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Subject -Match ".*$UserCertSubj*"}
    if (!$UserCert) { Write-Host -ForegroundColor Red "Error: The user certificate with subject $UserCertSubj not found!"; exit }
    Invoke-RestMethod -Uri "https://localhost:8443/aduser/get?useridentity=Administrator" -Method Get -Certificate $UserCert
}

if ($Action -eq "create") {
    $UserCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Subject -Match ".*$UserCertSubj*"}
    if (!$UserCert) { Write-Host -ForegroundColor Red "Error: The user certificate with subject $UserCertSubj not found!"; exit }
    Invoke-RestMethod -Uri  "https://localhost:8443/aduser/create?userIdentity=smith&employeeNumber=100&Name='Bob A. Smith'&Givenname=Bob&Surname=Smith&UserPrincipalName=smith@f5lab.local&OU=IT&Password=F@k3P@assw0rd&email=b.smith@acme.com"  -Method Get -Certificate $UserCert
}

if ($Action -eq "cert") {
    $UserCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Subject -Match ".*$UserCertSubj*"}
    if (!$UserCert) { Write-Host -ForegroundColor Red "Error: The user certificate with subject $UserCertSubj not found!"; exit }
    Invoke-RestMethod -Uri  "https://localhost:8443/aduser/cert?userIdentity=user1"  -Method Get -Certificate $UserCert
}

if (!$Action) { Write-Host -ForegroundColor Red "Error: The Action param is not specified. Exit."; exit }