$LMSURL     = "https://your.learn.tld"
$key        = "yourappkey"
$secret     = "yourappsecret"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $key,$secret)))

$body = "grant_type=client_credentials"
$apiuri = "$LMSURL/learn/api/public/v1/oauth2/token"
try {
    $response = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -body $body -Uri $apiuri -Method Post
}
catch {
    write-host "Error calling API at $apiuri`n$_"
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
}

$token = $response.access_token

$apiuri = "$LMSURL/learn/api/public/v1/users/_6_1"
$apimethod = "PATCH"
$item = @{ name=@{given = "The"
                    family = "Gr8Babu"}
}
$apibody = $item | ConvertTo-JSON
try {
    $response = Invoke-RestMethod -Headers @{Authorization=("Bearer $token")} `
             -Uri $apiuri -Method $apimethod -Body $apibody -ContentType 'application/json'
} catch {
    write-host "Error calling API at $apiuri`n$_"
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
}

if($response.results -is [array]) {
    foreach($r in $response.results) { $r }
    "Returned {0} users`n" -f $response.results.count
} else {
    $response
}
