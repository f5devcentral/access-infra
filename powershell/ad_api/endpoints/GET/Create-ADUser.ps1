<#
	.DESCRIPTION
		This script changes the "EmployeeNumber" attribute for specific sAMAccountName
	.EXAMPLE
        New-CreateUser.ps1 -RequestArgs "UserIdentity=Administrator&DriverLicense=Y3334444"
	.NOTES
        This will return a json object with sAMAccountName and employeeNumber attributes
#>

param(
    $RequestArgs
    
)
Add-Type -AssemblyName System.Web
$DecodedArgs = [System.Web.HttpUtility]::UrlDecode($RequestArgs)
#$DecodedArgs | Out-File c:\RestPS\error.log
 
if ($DecodedArgs -like '*&*') {
    # Split the Argument Pairs by the '&' character
    $ArgumentPairs = $DecodedArgs.split('&')
    $RequestObj = New-Object System.Object
    foreach ($ArgumentPair in $ArgumentPairs) {
        # Split the Pair data by the '=' character
        $Property, $Value = $ArgumentPair.split('=')
        $RequestObj | Add-Member -MemberType NoteProperty -Name $Property -value $Value
    }

    # Edit the Area below to utilize the Values of the new Request Object
    $sAMAccountName = $RequestObj.userIdentity
    $employeeNumber = $RequestObj.employeeNumber
	$Name = $RequestObj.Name
	$GivenName = $RequestObj.GivenName
	$Surname = $RequestObj.Surname
	$UserPrincipalName = $RequestObj.UserPrincipalName
	$OU = $RequestObj.OU
	$Password = $RequestObj.Password
    $emailaddress = $RequestObj.email
	
    if ($RequestObj.userIdentity) {
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
        -EmailAddress $email `
        -Description "F5 HTTP Connector created me" `
		-Enabled $true
    }
   if ($RequestObj.userIdentity) {
        Add-ADGroupMember `
            -Identity $OU `
            -Members $sAMAccountName

        Add-ADGroupMember `
            -Identity "Website Admin" `
            -Members $sAMAccountName
    }
     if ($RequestObj.userIdentity) {
        Set-ADAccountPassword `
            -Identity $sAMAccountName `
            -Reset `
            -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)

    
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, employeeNumber, userAccountControl
    }
    else {
        $Message = Get-ADUser -Identity admin -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber
	}
}
else {
    $Property, $sAMAccountName = $RequestArgs.split("=")
    $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber
}

return $Message