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

Add-Type -AssemblyName System


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
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object userCertificate
    }
    else {
        $Message = Get-ADUser -Identity Administrator -Properties * | Select-Object userCertificate
    }
}
else {
    $Property, $sAMAccountName = $RequestArgs.split("=")
	  $searchentry = $sAMAccountName
	  $server = 'dc1.f5lab.local'
	  $exportcert = 'c:\infra\ps.cer'
	  $searchtype = 'SamAccountNameOrCN'
	

 
<#
 .SYNOPSIS
 get user certificate(s) from contact or user object from an AD
 look for a certificate in usercert, usercertificate, usersmimecertificate attributes for object contact and user
 
 .DESCRIPTION
 Require RSAT if used on non Domain Controller environment.
 You can use several search type entry : distinguishedName or SamAccountName/CN or Mail
 you can search in another forest/domain using parameter "server" (by default take the current domain for logged on user)
 you can export the certificates found in file using "exportcert" parameter (require a file with full path)
 
 .EXAMPLE
 Get-ADUserCertificate -searchtype distinguishedName -searchentry "CN=account,OU=testou1,OU=testou,DC=ad,DC=ad,DC=com" -exportcert "C:\test\test\test.cer"
 Get-ADUserCertificate -searchtype Mail -searchentry "user.account@test.com"
 Get-ADUserCertificate -searchtype SamAccountNameOrCN -searchentry "UserAccount1" -server anotherad.ad.com
  
#>
   
         
    
    # import AD Module        
    try {
        import-module ActiveDirectory
    } catch {
        write-warning "Not able to load active directory module"
        write-warning "Please check if RSAT is installed"
        write-error "Error Type: $($_.Exception.GetType().FullName)"
        write-error "Error Message: $($_.Exception.Message)"
        return 
    }
    # get current domain if necessary
    if (-not $server) {
        $server = (get-addomain -current loggedonuser).dnsroot
        $pdc = (get-addomain -current loggedonuser).PDCEmulator
    } Else {
        $pdc = (get-addomain -server $server).PDCEmulator
    }
    # prepare exportcert content
    if ($exportcert) {
        if ($exportcert -like "*.cer") {
            $exportpath = split-path -path $exportcert
            $exportfilebase = split-path -Leaf $exportcert
        } Else {
            write-warning "the file name and path provided are not containing a valid CER file with full path entry. ex : c:\temp 2\temp\test.cer"
            return
        }
    }
    # retrieve AD object based on distinguishedName, SamAccountName Or CN or mail
    switch ($searchtype) {
        "SamAccountNameOrCN" {
            If ($searchtype -eq "SamAccountNameOrCN") {
                try {
                    $searchpattern = get-adobject -Filter { ((objectclass -eq "user") -or (objectclass -eq "contact")) -and ((sAMAccountName -eq $searchentry) -or (CN -eq $searchentry))} -server $server -Properties objectClass,distinguishedname,displayName,mail,UserCertificate,UserSMIMECertificate,UserCert,sn,givenname
                } catch {
                    write-error "Error Type: $($_.Exception.GetType().FullName)"
                    write-error "Error Message: $($_.Exception.Message)"
                    return
                }
            }
        }
        #default {}
    }
    If ($searchpattern) {
        # Preparing new object
        $global:UserTemplateObject = New-Object psobject
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name ObjectClass -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name distinguishedname -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name displayName -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserSMIMECertificate -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCertificate -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCert -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name mail -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name givenname -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name sn -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserSMIMECertificateLastOriginatingChangeTime -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserSMIMECertificateLastOriginatingDeleteTime -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCertificateLastOriginatingChangeTime -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCertificateLastOriginatingDeleteTime -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCertLastOriginatingChangeTime -Value $null
        $UserTemplateObject | Add-Member -MemberType NoteProperty -Name UserCertLastOriginatingDeleteTime -Value $null
        # check the certificate presence
        If ($searchpattern.UserSMIMECertificate) {
            $cer1 = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 $searchpattern.UserSMIMECertificate
            $cer1metadata = Get-ADReplicationAttributeMetadata $searchpattern.distinguishedName -properties usersmimecertificate -Server $pdc
        } Else {
            write-warning "no certificate in UserSMIMECertificate attribute for object $($searchpattern.distinguishedname)"
        }
        If ($searchpattern.UserCertificate) {    
            $cer2 = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 $searchpattern.UserCertificate
            $cer2metadata = Get-ADReplicationAttributeMetadata $searchpattern.distinguishedName -properties usercertificate -Server $pdc
        } Else {
            write-warning "no certificate in UserCertificate attribute for object $($searchpattern.distinguishedname)"
        }
        If ($searchpattern.UserCert) {    
            $cer3 = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 $searchpattern.UserCert
            $cer3metadata = Get-ADReplicationAttributeMetadata $searchpattern.distinguishedName -properties usercert -Server $pdc
        } Else {
            write-warning "no certificate in UserCert attribute for object $($searchpattern.distinguishedname)"
        }
        #building new object with content
        $ObjCertUser = $UserTemplateObject | Select-Object *
        $ObjCertUser.ObjectClass = $searchpattern.ObjectClass
        $ObjCertUser.distinguishedname = $searchpattern.distinguishedname
        $ObjCertUser.displayName = $searchpattern.displayName
        if($cer1) {
            $ObjCertUser.UserSMIMECertificate = $cer1
            $ObjCertUser.UserSMIMECertificateLastOriginatingChangeTime = $cer1metadata.LastOriginatingChangeTime
            $ObjCertUser.UserSMIMECertificateLastOriginatingDeleteTime = $cer1metadata.LastOriginatingDeleteTime
            if ($exportcert) {
                $exportfile1 = $exportfilebase -replace ".cer","_$($searchentry).cer"
                $exportcertfn = join-path ($exportpath) ($exportfile1)
                if (-not (test-path $exportcertfn)) {
                    $cer1.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                } Else {
					Remove-Item "$($exportcertfn)"
					$cer1.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                   
                }
            }
        }
        if ($cer2) {
            $ObjCertUser.UserCertificate = $cer2
            $ObjCertUser.UserCertificateLastOriginatingChangeTime = $cer2metadata.LastOriginatingChangeTime
            $ObjCertUser.UserCertificateLastOriginatingDeleteTime = $cer2metadata.LastOriginatingDeleteTime
            if ($exportcert) {
                $exportfile2 = $exportfilebase -replace ".cer","_$($searchentry).cer"
                $exportcertfn = join-path ($exportpath) ($exportfile2)
                if (-not (test-path $exportcertfn)) {
                    $cer2.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                } Else {
					Remove-Item "$($exportcertfn)"
					$cer2.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                    
                }
            }
        }
        if ($cer3) {
            $ObjCertUser.UserCert = $cer3
            $ObjCertUser.UserCertLastOriginatingChangeTime = $cer3metadata.LastOriginatingChangeTime
            $ObjCertUser.UserCertLastOriginatingDeleteTime = $cer3metadata.LastOriginatingDeleteTime
            if ($exportcert) {
                $exportfile2 = $exportfilebase -replace ".cer","_$($searchentry).cer"
                $exportcertfn = join-path ($exportpath) ($exportfile2)
				Remove-Item "$($exportcertfn)"
                if (-not (test-path $exportcertfn)) {
                    $cer2.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                } Else {
					Remove-Item "$($exportcertfn)"
					$cer2.rawdata | set-content "$($exportcertfn)" -Encoding Byte
                    
                }
            }
        }
        $ObjCertUser.mail = $searchpattern.mail
        $ObjCertUser.givenname = $searchpattern.givenname
        $ObjCertUser.sn = $searchpattern.sn
      
		
		$cert = get-content -path "c:\infra\$exportfile2" -Encoding Byte
		$b64cert = [System.Convert]::ToBase64String($cert, 'InsertLineBreaks')
		$content = "-----BEGIN CERTIFICATE-----`r`n" + $b64cert + "`r`n-----END CERTIFICATE-----"
	
	$jsoncert =1 | Select-Object -Property certificate
	$jsoncert.certificate = $content
	

	$content | Out-File -FilePath "c:\infra\$exportfile2" -Encoding ASCII
	

	$jsoncert =1 | Select-Object -Property certificate
	$jsoncert.certificate = $content	
		
		$Message = $jsoncert
		

		
    } Else {
        write-warning "no user or contact AD object found with your criteria : $($searchentry)"
        return 
    }

	
    
	
}

return $Message 


