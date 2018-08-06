Import-Module Azure

# This is the ID of your Tenant. You may replace the value with your Tenant Domain
$Global:tenantId = "common"

# You can add or change filters here
$MSGraphURI = "https://graph.microsoft.com/";

# 
#### DO NOT MODIFY BELOW LINES ####
###################################
Function Get-Headers {
    param( $token )

    Return @{
        "Authorization" = ("Bearer {0}" -f $token);
        "Content-Type" = "application/json";
    }
}

#builds the token.
Function Get-AzureAccessToken
{
    param(
# Parameter help description
[Parameter(Mandatory=$true, ParameterSetName="Token")]
[string]
$clientId,
# Parameter help description
[Parameter(Mandatory=$true, ParameterSetName="Token")]
[string]
$redirectUri,
# Parameter help description
[Parameter(Mandatory=$true, ParameterSetName="Token")]
[string]
$Resource
    )

    $authority = "https://login.microsoftonline.com/$($Global:tenantId)"
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
    $authResult = $authContext.AcquireToken($audgid, $clientId, $redirectUri, "Always")
    $token = $authResult.AccessToken
    return $token;
}

$audgid = "74658136-14ec-4630-ad9b-26e160ff0fc6"
# $aud = "https://main.iam.ad.ext.azure.com/user_impersonation"; 

$clientId = "1950a258-227b-4e31-a9cf-717495945fc2" # PowerShell clientId
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    
$token = Get-AzureAccessToken -clientId $clientId -redirectUri $redirectUri -Resource $audgid

    $requestid  = [SYstem.guid]::NewGuid()
    
    $headers = @{
        "accept-encoding"="gzip, deflate, br";
        "accept-language"="en"; 
        "x-ms-effective-locale"="en.en-us"
        "authorization"="Bearer $($token)"; #$authResult.Result.AccessToken)";
        "scheme"="https"; 
        "x-ms-client-request-id"="$($requestid.guid)";
        "accept"="*/*";
        "x-requested-with"="XMLHttpRequest"; 
        "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36";
        "method"="GET" 
}
$policiesUrl = "https://main.iam.ad.ext.azure.com/api/Policies/Policies?top=100&nextLink=null&appId=&includeBaseline=true"
$Policies = Invoke-restmethod -Uri $policiesUrl -Headers $headers -ContentType "application/json"
$policies