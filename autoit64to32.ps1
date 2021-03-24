# Script Title: AutoIt64to32
# Date: 2021-3-24
# Exploit Author: g4xyk00
# Software Link:  https://github.com/g4xyk00/autoit64to32
# Version: 1.0
# Usage: AutoIt64to32.ps1 <Path of AutoItSC.bin> <Path of 64-bit executable file>

Write-Host "AutoIt64to32 v1.0"
$currentPath = [string](Get-Location)
cd -Path $currentPath

$AutoItSCPath=$args[0] # AutoIt Interpreter stub
$64bitExePath=$args[1] # AutoIt compiled 64-bit executable file
$AutoItSCPath = [String](Get-ChildItem $AutoItSCPath)
$64bitExePath = [String](Get-ChildItem $64bitExePath)

$AutoItSCDec = [System.IO.File]::ReadAllBytes($AutoItSCPath)
$64bitExeDec = [System.IO.File]::ReadAllBytes($64bitExePath)
$scriptDec = 163,72,75,190,152,108,74,169,153,76,83,10,134,214,72,125

Write-Host "[INFO] To extract appended script from AutoIt compiled 64-bit executable file" 

$scriptIdx = (0..($64bitExeDec.Count-1)) | where {
	($64bitExeDec[$_] -eq $scriptDec[0]) -and 
	($64bitExeDec[$_+1] -eq $scriptDec[1]) -and 
	($64bitExeDec[$_+2] -eq $scriptDec[2]) -and 
	($64bitExeDec[$_+3] -eq $scriptDec[3]) -and 
	($64bitExeDec[$_+4] -eq $scriptDec[4]) -and 
	($64bitExeDec[$_+5] -eq $scriptDec[5]) -and 
	($64bitExeDec[$_+6] -eq $scriptDec[6]) -and 
	($64bitExeDec[$_+7] -eq $scriptDec[7]) -and 
	($64bitExeDec[$_+8] -eq $scriptDec[8]) -and 
	($64bitExeDec[$_+9] -eq $scriptDec[9]) -and 
	($64bitExeDec[$_+10] -eq $scriptDec[10]) -and 
	($64bitExeDec[$_+11] -eq $scriptDec[11]) -and 
	($64bitExeDec[$_+12] -eq $scriptDec[12]) -and 
	($64bitExeDec[$_+13] -eq $scriptDec[13]) -and 
	($64bitExeDec[$_+14] -eq $scriptDec[14]) -and 
	($64bitExeDec[$_+15] -eq $scriptDec[15])
}

if($scriptIdx -is [array]){
	$scriptIdx = $scriptIdx[0];
}

$startIndex = $scriptIdx;
$length = $64bitExeDec.Count - $scriptIdx;
$64bitExeDec = [System.Collections.ArrayList]$64bitExeDec
$64bitExeDec.Removerange(0,$startIndex)

Write-Host "[INFO] To combine appended script with interpreter stub" 
$32bitExe = $AutoItSCDec + $64bitExeDec


$32bitExeFileName = (Get-ChildItem $64bitExePath).BaseName + ".32bit.exe"
set-content -value $32bitExe -encoding byte -path $32bitExeFileName
Write-Host "[INFO] 32-bit executable file is generated in " + (Get-ChildItem $64bitExePath).BaseName + $32bitExeFileName