<#
	.DESCRIPTION
		This script changes the "EmployeeNumber" attribute for specific sAMAccountName
	.EXAMPLE
        Set-DriverLic.ps1 -RequestArgs "UserIdentity=Administrator&DriverLicense=Y3334444"
	.NOTES
        This will return a json object with sAMAccountName and employeeNumber attributes
#>

param(
    $RequestArgs
)

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
    $sAMAccountName = $RequestObj.userIdentity
    $password = $RequestObj.password
    if ($RequestObj.userIdentity) {
        Set-ADAccountPassword -Identity $sAMAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, employeeNumber
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