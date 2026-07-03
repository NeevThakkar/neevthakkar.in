$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$publishDir = Join-Path $env:TEMP "neevthakkar-site-public"

if (Test-Path -LiteralPath $publishDir) {
  Remove-Item -LiteralPath $publishDir -Recurse -Force
}

New-Item -ItemType Directory -Path $publishDir | Out-Null

$publicFiles = @(
  "_headers",
  "_redirects",
  ".nojekyll",
  "404.html",
  "apple-touch-icon.png",
  "CNAME",
  "favicon-32x32.png",
  "favicon-48x48.png",
  "favicon.ico",
  "favicon.svg",
  "icon-192x192.png",
  "index.html",
  "llms-full.txt",
  "llms.txt",
  "og-image.jpg",
  "og-image.png",
  "profile-160.jpg",
  "profile.jpg",
  "robots.txt",
  "site.webmanifest",
  "sitemap.xml",
  "style.css",
  "style.min.css"
)

foreach ($file in $publicFiles) {
  Copy-Item -LiteralPath (Join-Path $projectRoot $file) -Destination (Join-Path $publishDir $file) -Force
}

$commit = git -C $projectRoot rev-parse HEAD
$message = git -C $projectRoot log -1 --pretty=%s

npx wrangler pages deploy $publishDir `
  --project-name neevthakkar-in `
  --branch main `
  --commit-hash $commit `
  --commit-message "$message"
