$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://~MySecretServer~/choco/distr/1c/' + $env:ChocolateyPackageVersion + '/setup.zip' # download url, HTTPS preferred

$packageZipArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  #fileType      = 'MSI' #only one of these: exe, msi, msu
  url           = $url
  softwareName  = '1c*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  #checksum      = 'ba520b5d77f8a48f1b7eddb971d560e5d9dc9802b8d0ef572d8ad7d90218766c'
  #checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
  validExitCodes= @(0, 3010, 1641)
}

$packageMSIArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI' #only one of these: exe, msi, msu
  softwareName  = '1c*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  # MSI
    file          = $toolsDir + '\1CEnterprise 8.msi'
    silentArgs    = "/qr DESIGNERALLCLIENTS=1 THICKCLIENT=1 THINCLIENTFILE=1 THINCLIENT=1 WEBSERVEREXT=0 SERVER=0 CONFREPOSSERVER=0 CONVERTER77=0 SERVERCLIENT=0 LANGUAGES=RU"
  validExitCodes= @(0, 3010, 1641)
}

  $path1cconf        = "C:\Program Files (x86)\1cv8\" + $env:ChocolateyPackageVersion + "\bin\conf\conf.cfg" 
  
  $cmd_break      = "/c " + "echo.>>" + """" + $path1cconf + """"
  $cmd_unsafe     = "/c " + "echo DisableUnsafeActionProtection=.*>>" + """" + $path1cconf + """"

Write-Output "Установка 1с"
Install-ChocolateyZipPackage @packageZipArgs
Install-ChocolateyInstallPackage @packageMSIArgs

Write-Output "Отключаем защиту от опасных действий"
Start-ChocolateyProcessAsAdmin $cmd_break cmd 
Start-ChocolateyProcessAsAdmin $cmd_unsafe cmd 