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

# This section Parses the RequestArgs Parameter
<#
if ($RequestArgs -like '*&*') {
    # Split the Argument Pairs by the '&' character
    $ArgumentPairs = $RequestArgs.split('&')
    $RequestObj = New-Object System.Object
    foreach ($ArgumentPair in $ArgumentPairs) {
        # Split the Pair data by the '=' character
        $Property, $Value = $ArgumentPair.split('=')
        $RequestObj | Add-Member -MemberType NoteProperty -Name $Property -value $Value
    }

    # Edit the Area below to utilize the Values of the new Request Object
    $ProcessName = $RequestObj.Name
    $WindowTitle = $RequestObj.MainWindowTitle
    if ($RequestObj.Name) {
        $Message = Get-Process -Name $ProcessName | Where-Object {$_.Name -like "*$ProcessName*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
    else {
        $Message = Get-Process -Name $WindowTitle | Where-Object {$_.WindowTitle -like "*$WindowTitle*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
}
else {
    $Property, $ProcessName = $RequestArgs.split("=")
    $Message = Get-Process -Name $ProcessName | Select-Object ProcessName, Id, MainWindowTitle
}
#>

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$sAMAccountName = $newbody.Username
#Write-Host " UserName $sAMAccountName"
$employeeNumber = $newbody.employeeNumber
#Write-Host " Enumber $employeeNumber"
$Name = $newbody.Firstname + " " + $newbody.Lastname
#Write-Host " Full Name $Name"
$GivenName = $newbody.Firstname
#Write-Host " Firstname $GivenName"
$Surname = $newbody.Lastname
#Write-Host " Lastname $Surname"
$UserPrincipalName = $newbody.UPN
#Write-Host " UPN $UserPrincipalName"
$OU = $newbody.OU
#Write-Host " OU $OU"
$Password = $newbody.Password
#Write-Host " Password $Password"
$email = $newbody.email
#Write-Host " email $email"


   if ($newbody.Username) {
        New-ADUser `
        -SamAccountName $sAMAccountName `
		-Name $sAMAccountName `
        -DisplayName $Name `
	    -GivenName $GivenName `
		-Surname $Surname `
		-UserPrincipalName $UserPrincipalName `
		-Path "OU=$OU,DC=F5LAB,DC=LOCAL" `
		-PasswordNeverExpires $True `
		-ChangePasswordAtLogon $False `
		-EmployeeNumber $employeeNumber `
        -Emailaddress $email `
        -Description "F5 HTTP Connector created me" `
		-Enabled $true
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

    
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, employeeNumber, userAccountControl
    }
    else {
        $Message = Get-ADUser -Identity admin -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber
	}


return $Message