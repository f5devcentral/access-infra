<#
    .DESCRIPTION
        This script will creates a user Account
    .EXAMPLE
        .\Post-Create-ADUser.ps1 -Body '{"Username":"Testuser", "employeeNumber":"100", "GivenName":"Jason", "Surname":"Wilburn", "UPN":"12890@f5lab.local", "OU":"IT", "Password":"letmein", "emailaddress":"wilburn@acme.com"}'
    .NOTES
    	This will return the SameAccount name and UserAccount of that account once created.  66048 means the account is enabled and the user never needs to change their password.
#>

param(
#    $RequestArgs,
    $Body
)


# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$sAMAccountName = $newbody.Username
#Write-Host " UserName $sAMAccountName"
$employeeNumber = $newbody.employeeNumber
#Write-Host " Enumber $employeeNumber"
$Name = $newbody.GivenName + " " + $newbody.Surname
#Write-Host " Full Name $Name"
$GivenName = $newbody.GivenName
#Write-Host " Firstname $GivenName"
$Surname = $newbody.Surname
#Write-Host " Lastname $Surname"
$UserPrincipalName = $newbody.UserPrincipalName
Write-Host " UPN $UserPrincipalName"
$OU = $newbody.OU
#Write-Host " OU $OU"
$Password = $newbody.Password
#Write-Host " Password $Password"
$email = $newbody.email
#Write-Host " email $email"
$app_spn = $newbody.app_spn
#Write-Host " email $email"


   if ($newbody.username) {
        New-ADUser `
        -SamAccountName $sAMAccountName `
		-Name $sAMAccountName `
		-DisplayName $Name `
		-GivenName $GivenName `
		-Surname $Surname `
		-UserPrincipalName "$UserPrincipalName" `
		-Path "OU=$OU,DC=F5LAB,DC=LOCAL" `
		-PasswordNeverExpires $True `
		-ChangePasswordAtLogon $False `
		-EmployeeNumber $employeeNumber `
        -Emailaddress $email `
		-Enabled $true
		
		if ($app_spn) {
		  
		
			$SPN = $UserPrincipalName -split "@"
			Write-Host "SPN :" $SPN[0]
			Set-ADUser -Identity $sAMAccountName -ServicePrincipalNames @{Add=$SPN[0]}
			Set-ADAccountControl -Identity $sAMAccountName -TrustedToAuthForDelegation $True
			Set-ADUser -Identity $sAMAccountName -Add @{'msDS-AllowedToDelegateTo'= @("$app_spn")}
		}
    }
   if ($newbody.Username) {
        Add-ADGroupMember `
            -Identity $OU `
            -Members $sAMAccountName

        Add-ADGroupMember `
            -Identity "Website Admin" `
            -Members $sAMAccountName
    }
     if ($newbody.Username) {
        Set-ADAccountPassword `
            -Identity $sAMAccountName `
            -Reset `
            -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)
			
		
	
    
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, userAccountControl
    }
    else {
        $Message = Get-ADUser -Identity admin -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber
	}


return $Message



