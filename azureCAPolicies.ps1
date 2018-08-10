Import-Module Azure

# This is the ID of your Tenant. You may replace the value with your Tenant Domain
$Global:tenantId = "common"

# Basic OAuth Variables for acquiring the token
$clientId = "1950a258-227b-4e31-a9cf-717495945fc2" # PowerShell clientId
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
$MSGraphURI = "https://graph.microsoft.com"
# 
#### DO NOT MODIFY BELOW LINES ####
###################################
Function Get-Headers {
    param( $token )
    $requestid  = [SYstem.guid]::NewGuid()
    Return @{
        "accept-encoding"="gzip, deflate, br";
        "accept-language"="en"; 
        "x-ms-effective-locale"="en.en-us"
        "Authorization" = ("Bearer {0}" -f $token);
        "scheme"="https"; 
        "x-ms-client-request-id"="$($requestid.guid)";
        "accept"="*/*";
        "x-requested-with"="XMLHttpRequest"; 
        "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36";
        "method"="GET" 
    }
}

#builds the token.
Function Get-AzureAccessToken
{
    param(
        [string]$clientId = "1950a258-227b-4e31-a9cf-717495945fc2", # PowerShell clientId
        [string]$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    )
    $audgid = "74658136-14ec-4630-ad9b-26e160ff0fc6"
    $authority = "https://login.microsoftonline.com/$($Global:tenantId)"
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
    $authResult = $authContext.AcquireToken($audgid, $clientId, $redirectUri, "Always")
    $token = $authResult.AccessToken
    return $token;
}
function Get-AzureADConditionalAccessPolicies {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ParameterSetName='CAPolicies')]
        [PSCustomObject]$AuthHeaders
        )
        $policies = "https://main.iam.ad.ext.azure.com/api/Policies/Policies?top=100&nextLink=null&appId=&includeBaseline=true"
        $results = Invoke-restmethod -Uri $policies -Headers $authheaders -ContentType "application/json"
    $policyDetails = @()
    foreach($result in $results.items){
        $policyUri = "https://main.iam.ad.ext.azure.com/api/Policies/$($result.policyId)"
        $policyDetails += Invoke-restmethod -Uri $policyuri -Headers $authheaders -ContentType "application/json"
        
    }
    return $policyDetails;
}

$token = Get-AzureAccessToken  -clientId $clientId -redirectUri $redirectUri
$headers = Get-Headers -token $token
$policies= Get-AzureADConditionalAccessPolicies -AuthHeaders $headers
$policies

