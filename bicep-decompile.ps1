Param (
    [Parameter(HelpMessage = "Folder of ARM templates to decompile to bicep")] 
    [string] $Folder = "$PSScriptRoot\extractor"
)

$ErrorActionPreference = "Stop"

"Decompiling all ARM templates to Bicep from folder: $Folder"

Get-ChildItem -File -Recurse $Folder -Include *.json `
| ForEach-Object { 
    bicep.exe decompile $_.FullName
}
