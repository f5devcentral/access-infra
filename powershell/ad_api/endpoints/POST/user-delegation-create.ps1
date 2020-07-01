<#
    .DESCRIPTION
        This script will creates a kerberos Delegation Account
    .EXAMPLE
        .\user-delegation-create.ps1 -Body '{"Username":"kerbaccount", "UPN":"HOST/kerbaccount.f5lab.local", "ou":"IT", "Password":"kerbaccount", "app_spn": "HTTP/kerb1.acme.com"  }'
    .NOTES
    	This will return the UPN of the account and the SPN of the application requiring delegation
#>

param(
    $Body
)



# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$sAMAccountName = $newbody.Username
#Write-Host " UserName $sAMAccountName"
$UserPrincipalName = $newbody.UPN
#Write-Host " UPN $UserPrincipalName"
$OU = $newbody.ou
#Write-Host " OU $ou"
$Password = $newbody.Password
#Write-Host " Password $Password"
$app_spn = $newbody.app_spn
#Write-Host " APP SPN $app_spn"



   if ($newbody.Username) {
        New-ADUser `
        -SamAccountName $sAMAccountName `
		-Name $sAMAccountName `
		-UserPrincipalName "$UserPrincipalName@f5lab.local" `
		-ServicePrincipalNames $UserPrincipalName `
		-Path "OU=$OU,DC=F5LAB,DC=LOCAL" `
		-PasswordNeverExpires $True `
		-ChangePasswordAtLogon $False `
        -Description "Kerberos Delegation Account" `
		-Enabled $true `
		
    }

     if ($newbody.Username) {
        Set-ADAccountPassword `
            -Identity $sAMAccountName `
            -Reset `
            -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)
    
	Set-ADAccountControl -Identity $sAMAccountName -TrustedToAuthForDelegation $True
	Set-ADUser -Identity $sAMAccountName -Add @{'msDS-AllowedToDelegateTo'= @("$app_spn")}
	
	
    
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, userAccountControl, msDS-AllowedToDelegateTo
    }
	
	
    else {
        $Message = Get-ADUser -Identity admin -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName
	}


return $Message