<#
	.DESCRIPTION
		This script changes the "EmployeeNumber" attribute for specific sAMAccountName
	.EXAMPLE
         Set-ADUserVulnerable.ps1 -requestArgs "useridentity=hackeduser&memberof=Domain Admins"
	.NOTES
        This will return a json object with sAMAccountName and employeeNumber attributes
#>

param(
    $RequestArgs
)

Add-Type -AssemblyName System.Web
$DecodedArgs = [System.Web.HttpUtility]::UrlDecode($RequestArgs)

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
    $cn = $RequestObj.cn
	$memberOf = $RequestObj.memberOf
	$Password = $RequestObj.Password
	$cn = $RequestObj.cn
	$telephoneNumber = $RequestObj.telephoneNumber
	$uri = $RequestObj.uri
	$inject = $RequestObj.inject
	  
	 if ($RequestObj.telephoneNumber) {
		Set-ADUser -Identity $sAMAccountName -OfficePhone $telephoneNumber
		$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, telephoneNumber
    
    }
	 if ($RequestObj.mail) {
		Set-ADUser -Identity $sAMAccountName -OfficePhone $mail
		$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, mail
		
    }
	 if ($RequestObj.uri) {
		
		$response = Invoke-WebRequest -Uri $uri 
<#		$response = Invoke-WebRequest -URI https://www.bing.com/search?q=how+many+feet+in+a+mile
			$response.InputFields | Where-Object {
			$_.name -like "* Value*"
	} | Select-Object Name, Value
	#>
	
$message = $response.content
    
    }
    elseif ($RequestObj.cn -eq "") {
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, cn
        
    }
	elseif ($RequestObj.memberOf -eq "") {
		
		$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, memberOf
    }
    elseif ($RequestObj.memberOf) {
        Add-ADGroupMember `
            -Identity $memberOf `
            -Members $sAMAccountName
		
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, memberOf
    }
	elseif ($RequestObj.password) {
        Set-ADAccountPassword `
            -Identity $sAMAccountName `
            -Reset `
            -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, userAccountControl
    }

    
    
}
else {
$Property, $value = $DecodedArgs.split("=")


if ($property -eq "inject") {

  if ($value -eq "|powershell badprogram.ps1" ) {
 
    $Message = "Attack Successful"
	}
   else {
   $Message = "Invalid Request. API Server unable to Process Request"
   }
}
elseif ($property -eq "useridentity"){
   ($value -ne "")
   

    $Message = Get-ADUser -Identity $value -Properties * | Select-Object sAMAccountName, mail, telephoneNumber
}
else {

    $Message = "Invalid Request. API Server unable to Process Request"
}
}
return $Message