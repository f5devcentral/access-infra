
<#
	.DESCRIPTION
		This script create an IIS Website
	.EXAMPLES
				.\create-website.ps1 -Body '{"site_name":"testapp.acme.com", "http_port":"80", "https_port":"443", "computer_ip":"10.1.20.6", "authentication": "none", "template_number": "2"  }'

	.NOTES
		Supports basic,saml, anonymous, and Kerberos configurations.
       
#>



param(
    $body
    
)

import-module webadministration



 Function Copy-WebsiteTemplate($websitebase, $site_name, $template_number) {
 


 	if(Test-Path $websitebase\$site_name) {
				Stop-WebSite -Name $site_name
				Remove-Item $websitebase\$site_name -Recurse -Force
				if((Test-Path $websitebase\$template_number) -And (!$template_number -ne $null)) {
					Copy-Item -Path $websitebase\$template_number -Destination $websitebase\$site_name -Recurse
						return $true
					} else {
						return $false
			
					}
		} else {
			
				if((Test-Path $websitebase\$template_number) -And ($template_number -ne $null)) {
					
					Copy-Item -Path $websitebase\$template_number -Destination $websitebase\$site_name -Recurse
						return $true
					} else {
	
						return $false
			
					}
				
		}
	
		Start-Sleep -Seconds 3
 
 }
 
 
 Function Create-Site ($websitebase, $site_name, $http_port, $https_port, $computer_ip, $template_number) {
 
	
		Switch ($template_number)

		{ 

			"1" {
				New-WebSite -Name $site_name -Port $http_port -HostHeader $site_name -PhysicalPath $websitebase\$site_name\www -IPAddress $computer_ip -ApplicationPool $site_name -Force
				New-WebBinding -Name $site_name -HostHeader $site_name -IP $computer_ip -Port $https_port -Protocol https
				return $true
			
			}
			default {
				New-WebSite -Name $site_name -Port $http_port -HostHeader $site_name -PhysicalPath $websitebase\$site_name -IPAddress $computer_ip -ApplicationPool $site_name -Force
				New-WebBinding -Name $site_name -HostHeader $site_name -IP $computer_ip -Port $https_port -Protocol https
				return $true
			}
		
		}
}
 
 Function Modify-Background ($websitebase, $site_name, $background) {
 

		(Get-Content $websitebase\$site_name\index.php).replace("SITECOLOR", $background) | Set-Content $websitebase\$site_name\index.php
		return $true
		
	}
	
	Function Modify-Sitename ($websitebase, $site_name) {
 

		(Get-Content $websitebase\$site_name\index.php).replace("SITENAME", $site_name) | Set-Content $websitebase\$site_name\index.php
		return $true
		
	}
 
 Function Modify-saml ($websitebase, $site_name, $nameidppolicy, $idp_entityid, $idp_hostname) {
		(Get-Content $websitebase\$site_name\config\authsources.php).replace("SITENAME", $site_name) | Set-Content $websitebase\$site_name\config\authsources.php
		(Get-Content $websitebase\$site_name\config\authsources.php).replace("NAMEPOLICY", $nameidpolicy) | Set-Content $websitebase\$site_name\config\authsources.php
		(Get-Content $websitebase\$site_name\config\authsources.php).replace("IDPENTITYID", $idp_entityid) | Set-Content $websitebase\$site_name\config\authsources.php
		(Get-Content $websitebase\$site_name\metadata\saml20-idp-remote.php).replace("IDPENTITYID", $idp_entityid) | Set-Content $websitebase\$site_name\metadata\saml20-idp-remote.php
		(Get-Content $websitebase\$site_name\metadata\saml20-idp-remote.php).replace("IDPHOSTNAME", $idp_hostname) | Set-Content $websitebase\$site_name\metadata\saml20-idp-remote.php
		(Get-Content $websitebase\$site_name\metadata\saml20-idp-remote.php).replace("NAMEPOLICY", $nameidpolicy) | Set-Content $websitebase\$site_name\metadata\saml20-idp-remote.php
		return $true
 }
 
 

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$site_name = $newbody.site_name
#Write-Host "Sitename: $site_name"
$http_port = $newbody.http_port
#Write-Host " http_port: $http_port"
$https_port = $newbody.https_port
#Write-Host "https_port: $https_port"
$computer_ip = $newbody.computer_ip
#Write-Host "Computer IP: $computer_ip"
$authentication = $newbody.authentication
#Write-Host "Authentication: $authentication"
$template_number = $newbody.template_number
#Write-Host "Template: $template_number"







$websitebase = "c:\infra\websites"


	$copystatus = Copy-WebsiteTemplate $websitebase $site_name $template_number
		
		if ($copystatus) {
		
			 if(Test-Path IIS:\AppPools\$site_name)
				{

				} else {

					New-WebAppPool $site_name -Force
				}
		
			Create-Site $websitebase $site_name $http_port $https_port $computer_ip $template_number
		} else {
			$status = "Invalid Template"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$Message = $jsonresponse | Select-Object status
		    return $message
		}


Switch ($authentication)

{ 

	"none" {
						
			Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name Enabled -Value True -PSPath IIS:\ -Location "$site_name"
			
		}
	"kerberos" {
	

		
			Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name Enabled -Value True -PSPath IIS:\ -Location $site_name 
			Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name useKernelMode -Value False -PSPath IIS:\ -Location $site_name 
			Remove-WebConfigurationProperty -filter system.webServer/security/authentication/windowsAuthentication/providers -name "." -PSPath IIS:\ -Location $site_name
			Add-WebConfiguration -Filter system.webServer/security/authentication/windowsAuthentication/providers  -Value Negotiate:Kerberos -PSPath IIS:\ -Location $site_name
			Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/anonymousAuthentication -Name Enabled -Value False -PSPath IIS:\ -Location $site_name 
					
	}	
	"basic" {
	
			
			Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name Enabled -Value False -PSPath IIS:\ -Location "$site_name" 
			Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/basicAuthentication" -Name Enabled -Value True -PSPath IIS:\ -Location "$site_name"
			Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/basicAuthentication" -Name defaultLogonDomain -Value f5lab.local -PSPath IIS:\ -Location "$site_name"
			Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/basicAuthentication" -Name realm -Value F5LAB.LOCAL -PSPath IIS:\ -Location "$site_name"
		
	}
	"saml" {
		$idp_hostname = $newbody.saml.idp_hostname
		#Write-Host "idp_hostname: $idp_hostname"
		$idp_entityid = $newbody.saml.idp_entityid
		#Write-Host "idp_entityid: $idp_entityid"
		$nameidpolicy = $newbody.saml.nameidpolicy
		#Write-Host "namepolicyid: $namepolicyid"
	
		Modify-saml -Websitebase $websitebase -site_name $site_name -nameidpolicy $nameidppolicy -idp_entityid $idp_entityid -idp_hostname $idp_hostname		
		
		Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name Enabled -Value True -PSPath IIS:\ -Location "$site_name" 
		

	}	




}


Switch ($template_number)

{ 

	"1" {
	
	}
	
	"2" {
	$background = $newbody.customization.background
	Modify-Background -Websitebase $websitebase -site_name $site_name  -background $background 
	Modify-Sitename -Websitebase $websitebase -site_name $site_name  
	}
	"3" {
	Modify-Sitename -Websitebase $websitebase -site_name $site_name  
	}
	
}



 
 Start-WebSite -Name $site_name
 
 #Sets the error message based on success or failure 
 
 if ($?) {
 	$status = "Success"
    $jsonresponse = New-Object -TypeName psobject
	$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	$jsonresponse| Add-Member -MemberType NoteProperty -Name site_name -Value $site_name
    $jsonresponse| Add-Member -MemberType NoteProperty -Name http_port -Value $http_port
	$jsonresponse| Add-Member -MemberType NoteProperty -Name https_port -Value $https_port
    $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	$jsonresponse| Add-Member -MemberType NoteProperty -Name authentication -Value $authentication
 
 	$Message = $jsonresponse | Select-Object status, site_name, http_port, https_port, computer_ip, authentication
 
    
 } else {


	$status = "Fail"
	$jsonresponse = New-Object -TypeName psobject
	$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	$jsonresponse| Add-Member -MemberType NoteProperty -Name site_name -Value $site_name
    $jsonresponse| Add-Member -MemberType NoteProperty -Name http_port -Value $http_port
	$jsonresponse| Add-Member -MemberType NoteProperty -Name https_port -Value $https_port
    $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	$jsonresponse| Add-Member -MemberType NoteProperty -Name authentication -Value $authentication
 
 	$Message = $jsonresponse | Select-Object status, site_name, http_port, https_port, computer_ip, authentication
 }
 
 return $message
 





