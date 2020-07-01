<?php

/**
 * SAML 2.0 remote IdP metadata for SimpleSAMLphp.
 *
 * Remember to remove the IdPs you don't use from this file.
 *
 * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-idp-remote
 */


$metadata['IDPENTITYID'] = array (
  'entityid' => 'IDPENTITYID',
  'contacts' => 
  array (
  ),
  'metadata-set' => 'saml20-idp-remote',
  'SingleSignOnService' => 
  array (
    0 => 
    array (
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
      'Location' => 'https://IDPHOSTNAME/saml/idp/profile/redirectorpost/sso',
    ),
    1 => 
    array (
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
      'Location' => 'https://IDPHOSTNAME/saml/idp/profile/redirectorpost/sso',
    ),
  ),
  'SingleLogoutService' => 
  array (
    0 => 
    array (
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
      'Location' => 'https://IDPHOSTNAME/saml/idp/profile/post/sls',
      'ResponseLocation' => 'https://IDPHOSTNAME/saml/idp/profile/post/slr',
    ),
    1 => 
    array (
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
      'Location' => 'https://IDPHOSTNAME/saml/idp/profile/redirect/sls',
      'ResponseLocation' => 'https://IDPHOSTNAME/saml/idp/profile/redirect/slr',
    ),
  ),
  'ArtifactResolutionService' => 
  array (
  ),
  'NameIDFormats' => 
  array (
    0 => 'NAMEPOLICY',
  ),
  'keys' => 
  array (
    0 => 
    array (
      'encryption' => true,
      'signing' => true,
      'type' => 'X509Certificate',
      'X509Certificate' => 'MIIFgTCCBGmgAwIBAgITXgAAAASdfcIAI44jXAAAAAAABDANBgkqhkiG9w0BAQsFADBIMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFTATBgoJkiaJk/IsZAEZFgVmNWxhYjEYMBYGA1UEAxMPZGMxLmY1bGFiLmxvY2FsMB4XDTE5MTEyMTE5MjUxN1oXDTIxMTEyMTE5MzUxN1owFTETMBEGA1UEAwwKKi5hY21lLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOQZ1XLT/k3NMAR+eulFawTAj4mFmh9fqxjbhUdl0vjByzyWnrwjoD5VgWCWKgLYhGnzl7/AoC37L5hX/i7xZKInR2c7wTwh3Luj38aW+TRHdiudhqgiue3AxH7nuCq9MkS3QMyO8KS8P/zNhicQLJY4L6t0mrGD52bmoxxE4ItaXNqWx7EdtG8Xrc5b93dX/14hC8nogNkFMQBubTtvpOYVLhSQt/8TosFcOJONb7gHSXuB5FkGtB1aKCzjQU32k44cja9ku8txTKBioZi9bRHfSpry1pOAQ0g+FmPt0hOaR4Prgv1REPOTpuvXLJ6D/3Gvhy2YVRhSCeR+T5iO+aECAwEAAaOCApUwggKRMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIeMjBaGrP9Eg62ZKIXeqwiDssRrMYWv4SiD+qRBAgFkAgEDMBMGA1UdJQQMMAoGCCsGAQUFBwMBMA4GA1UdDwEB/wQEAwIFoDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMBMB0GA1UdDgQWBBRm1NLRQygmFXonudgqNM4sQ1EIFzAVBgNVHREEDjAMggoqLmFjbWUuY29tMB8GA1UdIwQYMBaAFNhpUMHsIixtS9g6y/FyNrayg9V6MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGgbJsZGFwOi8vL0NOPWRjMS5mNWxhYi5sb2NhbCxDTj1kYzEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9ZjVsYWIsREM9bG9jYWw/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50MIHqBggrBgEFBQcBAQSB3TCB2jCBrgYIKwYBBQUHMAKGgaFsZGFwOi8vL0NOPWRjMS5mNWxhYi5sb2NhbCxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1mNWxhYixEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAnBggrBgEFBQcwAYYbaHR0cDovL2RjMS5mNWxhYi5sb2NhbC9vY3NwMA0GCSqGSIb3DQEBCwUAA4IBAQCsf2mREYnGaLise44ArUzs1Hp4VTa5jMJQh7VoO04kceh+gCUb9KYD5z8OGADrbnlP1A8d4bjLl2+5EGhVQySwdddELoAYNuWMbfgjL6aZUOKeGgZ+eAtiOpKu24HcZ/IgcaJkBpMG10GjUPnv188JK1mwx8fRB8DyjDrg5yUGRt23FCaI5ClAwFFxpWfsrXiWWJIV/hTRwKr2O0kbEfpubT9Bw9Cu/avPVDHjVdjHobvxVOU3Xs/19cnErbR4JV/HPoWDaTsoOzF3e+oUuap26XCrzLL/KPGb4XT0YNDgz3Zvg35fg12QWWwh5f2ccg+g/8mE73+SAQHbT3yg720r',
    ),
  ),
);
