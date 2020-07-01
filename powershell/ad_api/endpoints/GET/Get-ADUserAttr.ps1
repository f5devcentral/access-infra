<#
	.DESCRIPTION
		This script will return the body passed to the RestEndpoint.
	.EXAMPLE
        Get-ADUserAttr.ps1 -RequestArgs "UserIdentity=Administrator"
	.NOTES
        This will return a json object with sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber attributes
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
    $sAMAccountName = $RequestObj.Identity
    if ($RequestObj.Identity) {
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object DistinguishedName, Name, SID, UserPrincipalName, userAccountControl
    }
    else {
        $Message = Get-ADUser -Identity Administrator -Properties * | Select-Object DistinguishedName, Name, SID, UserPrincipalName, userAccountControl
    }
}
else {
    $Property, $sAMAccountName = $RequestArgs.split("=")
    $userexist = Get-ADUser -Identity $sAMAccountName -Properties *
	if ($userexist) {
		$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, DistinguishedName, Name, SID, UserPrincipalName, employeeNumber, userAccountControl, memberOf
	}
	else {
		$Message = "User Not found"
	}
	
}

return $Message