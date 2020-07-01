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
  Start-RestPSListener -Port 81 
}

# If Action parameter is "Stop"
if ($Action -eq "stop") {
    
    Invoke-RestMethod -Uri "http://localhost:81/endpoint/shutdown" -Method Get 
}

# If Action parameter is "Test"
if ($Action -eq "test") {
    
    Invoke-RestMethod -Uri "http://localhost:81/aduser/get?useridentity=Administrator" -Method Get 
}

if ($Action -eq "create") {
    
    Invoke-RestMethod -Uri  "http://localhost:81/aduser/create?userIdentity=smith&employeeNumber=100&Name='Bob A. Smith'&Givenname=Bob&Surname=Smith&UserPrincipalName=smith@f5lab.local&OU=IT&Password=F@k3P@assw0rd&email=b.smith@acme.com"  -Method Get -Certificate $UserCert
}

if ($Action -eq "cert") {
   Invoke-RestMethod -Uri "http://localhost:81/aduser/cert?useridentity=user1" -Method Get 
}

if (!$Action) { Write-Host -ForegroundColor Red "Error: The Action param is not specified. Exit."; exit }