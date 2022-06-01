# Automated voting script for news.sina.com.cn
# Updated: 2022-05

#cspell: disable
#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$user_agent = 
'"User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 14_8 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"'
$referer = 
'"Referer: http://comment5.news.sina.com.cn"'
$url_vote = 
'"http://comment5.news.sina.com.cn/cmnt/vote"'

[string]$target = ""
[int]$count = 0
[int]$maxInterval = 0

$target = Read-Host -Prompt "target"
if ([String]::IsNullOrEmpty($target)) {
    Exit
}

$count = Read-Host -Prompt "count (100)"
if ($count -le 0) {
    $count = 100
}

$maxInterval = Read-Host -Prompt "max interval ($maxInterval, set 0 to disable)"
$target = $target.Replace("&mid", "&parent");
$data = "$target&format=js&vote=1&domain=sina.com.cn"
    
while ($count-- -gt 0) {
    $ip1 = Get-Random -Minimum 1 -Maximum 254
    $ip2 = Get-Random -Minimum 1 -Maximum 254
    $ip3 = Get-Random -Minimum 1 -Maximum 254
    $ip4 = Get-Random -Minimum 1 -Maximum 254
    $forwarded = "`"X-Forwarded-For: $ip1.$ip2.$ip3.$ip4`""
        
    [string[]] $arguments = "--silent",
    "--header", $user_agent,
    "--header", $referer,
    "--header", $forwarded,
    "--data", $data,
    $url_vote

    Write-Host
    Start-Process -FilePath "curl.exe" -ArgumentList $arguments -NoNewWindow -Wait
            
    if ($maxInterval -gt 0) {
        Write-Host
        Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum $maxInterval)
    }
}

Read-Host -Prompt "`nCompleted at $(Get-Date), any key to close"
