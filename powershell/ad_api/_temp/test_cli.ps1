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
$usercert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Subject -eq 'CN=Administrator, CN=Users, DC=itc, DC=demo'}
Invoke-RestMethod -Uri "https://localhost:8443/aduser/get?useridentity=eric" -Method Get -Certificate $usercert

Invoke-RestMethod -Uri "https://restapi.itc.demo:8443/aduser/get?useridentity=eric" -Method Get -Certificate $usercert