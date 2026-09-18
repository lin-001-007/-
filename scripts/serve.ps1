# Static file server + local data API (127.0.0.1 only)
param(
    [int]$Port = 17890
)

$Root = Split-Path -Parent $PSScriptRoot
$dataDir = Join-Path $Root "data"
$dataFile = Join-Path $dataDir "storage.json"
New-Item -ItemType Directory -Force -Path $dataDir | Out-Null

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
$listener.Start()

$mime = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".txt"  = "text/plain; charset=utf-8"
    ".ico"  = "image/x-icon"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
}

function Get-LocalPath([string]$urlPath) {
    $decoded = [System.Uri]::UnescapeDataString($urlPath.TrimStart("/"))
    if ([string]::IsNullOrWhiteSpace($decoded)) { $decoded = "priority.html" }
    $full = [System.IO.Path]::GetFullPath((Join-Path $Root $decoded))
    if (-not $full.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }
    return $full
}

function Write-HttpResponse($res, [int]$statusCode, [string]$body, [string]$contentType) {
    $res.StatusCode = $statusCode
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $res.ContentType = $contentType
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    $res.Close()
}

function Read-RequestBody($req) {
    if (-not $req.HasEntityBody) { return "" }
    $reader = New-Object System.IO.StreamReader($req.InputStream, $req.ContentEncoding)
    try { return $reader.ReadToEnd() } finally { $reader.Close() }
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $req = $context.Request
        $res = $context.Response
        $path = $req.Url.AbsolutePath

        if ($path -eq "/api/storage") {
            if ($req.HttpMethod -eq "GET") {
                if (Test-Path $dataFile) {
                    $json = [System.IO.File]::ReadAllText($dataFile, [System.Text.Encoding]::UTF8)
                    Write-HttpResponse $res 200 $json "application/json; charset=utf-8"
                } else {
                    Write-HttpResponse $res 200 "{}" "application/json; charset=utf-8"
                }
                continue
            }
            if ($req.HttpMethod -eq "POST") {
                $body = Read-RequestBody $req
                if ([string]::IsNullOrWhiteSpace($body)) {
                    Write-HttpResponse $res 400 '{"error":"empty body"}' "application/json; charset=utf-8"
                    continue
                }
                try {
                    $null = $body | ConvertFrom-Json
                } catch {
                    Write-HttpResponse $res 400 '{"error":"invalid json"}' "application/json; charset=utf-8"
                    continue
                }
                [System.IO.File]::WriteAllText($dataFile, $body, [System.Text.Encoding]::UTF8)
                Write-HttpResponse $res 200 '{"ok":true}' "application/json; charset=utf-8"
                continue
            }
            Write-HttpResponse $res 405 '{"error":"method not allowed"}' "application/json; charset=utf-8"
            continue
        }

        $filePath = Get-LocalPath $path
        if ($null -eq $filePath -or -not (Test-Path $filePath -PathType Leaf)) {
            Write-HttpResponse $res 404 "404 Not Found" "text/plain; charset=utf-8"
            continue
        }

        $ext = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
        $res.ContentType = $mime[$ext]
        if (-not $res.ContentType) { $res.ContentType = "application/octet-stream" }
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $res.StatusCode = 200
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
    }
}
finally {
    $listener.Stop()
    $listener.Close()
}
