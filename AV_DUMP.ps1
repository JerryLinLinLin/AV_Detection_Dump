<#
.Synopsis
	Antivirus Dump
.DESCRIPTION
	Dump an Antivirus software's detection name
.PARAMETER Name
    Choose an Antivirus: Huorong | Kaspersky | Malwarebytes | ESET
#>

#Requires -Version 4.0
#Requires -RunAsAdministrator

Param(
    [Parameter(Mandatory)]
    [validateset("Huorong", "Kaspersky", "Malwarebytes", "ESET")]
    [string]$Name
)

$TimeStamp = (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss')
New-Item -ItemType Directory -Force $Name

$FileName = "$Name-$TimeStamp"
$DumpPath = "$FileName.dmp"
$StringPath = "$FileName.txt"


switch ($Name) {
    ESET {
        procdump.exe -ma "ekrn.exe" $DumpPath
        strings.exe -nobanner -n 3 "$FileName.dmp" > $StringPath

        $OutputPath = "$FileName-BASE.txt"
        select-string -Path $StringPath -Pattern "^@[a-zA-Z]{3,}\.[a-zA-Z]{2,}.+" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } > $OutputPath
        select-string -Path $StringPath -Pattern "^[a-zA-Z]{3,}\d*/[a-zA-Z]{2,}\.[^|]" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } >> $OutputPath
        select-string -Path $StringPath -Pattern "^[a-zA-Z]{3,}\d*/[a-zA-Z]{2,}$" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } >> $OutputPath

        $ResultPath = "$Name/$FileName-BASE.csv"
        Get-Content $OutputPath | Sort-Object | get-unique > $ResultPath

        Remove-Item $OutputPath
    }
    Huorong {
        $Regex = "^[A-Z][^/.=]{0,30}[/][A-Za-z]*[.][^/=]{0,20}$"

        procdump.exe -ma "HipsDaemon.exe" $DumpPath
        strings.exe -nobanner -n 7 "$FileName.dmp" > $StringPath

        $OutputPath = "$FileName-BASE.txt"
        select-string -Path $StringPath -Pattern $Regex -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } > $OutputPath

        $ResultPath = "$Name/$FileName-BASE.csv"
        Get-Content $OutputPath | Sort-Object | get-unique > $ResultPath

        Remove-Item $OutputPath
    }
    Kaspersky {
        $Regex_BASE = "^(?=[A-Z])(?!.*System.*|.*Windows.*|.*Microsoft.*|.*SCC.*|.*CLN.*|.*PDM.*|.*=.*|.*\\.*|.*//.*|.*\(.*)([^.]*)\.([^.]{1,10})\.([^.]*)\..*"
        $Regex_PDM = "^PDM:.*"

        procdump.exe -ma "avp.exe" $DumpPath
        strings.exe -nobanner -n 7 "$FileName.dmp" > $StringPath

        $OutputPath_BASE = "$FileName-BASE.txt"
        $OutputPath_PDM = "$FileName-PDM.txt"
        select-string -Path $StringPath -Pattern $Regex_BASE -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } > $OutputPath_BASE
        select-string -Path $StringPath -Pattern $Regex_PDM -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } > $OutputPath_PDM

        $ResultPath_BASE = "$Name/$FileName-BASE.csv"
        $ResultPath_PDM = "$Name/$FileName-PDM.csv"
        Get-Content $OutputPath_BASE | Sort-Object | get-unique > $ResultPath_BASE
        Get-Content $OutputPath_PDM | Sort-Object | get-unique > $ResultPath_PDM

        Remove-Item $OutputPath_BASE
        Remove-Item $OutputPath_PDM
        
    }
    Malwarebytes {
        $Regex_DDS = ".*.DDS$"

        procdump.exe -ma "MBAMService.exe" $DumpPath
        strings.exe -nobanner -u -n 7 "$FileName.dmp" > $StringPath

        $OutputPath_DDS = "$FileName-DDS.txt"
        $OutputPath_BASE = "$FileName-BASE.txt"
        select-string -Path $StringPath -Pattern $Regex_DDS -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } > $OutputPath_DDS
        
        $Range = $false
        Get-Content -Path $StringPath | Foreach-Object {
            if($_ -match "PUP.Optional.Bandoo.AppFlsh"){
                $Range = $true
            }
            if($_ -match "Toshiba.MBR"){
                $Range = $false
            }
            if ($Range) {
                Add-Content $OutputPath_BASE $_ 
            }
        }

        $ResultPath_DDS = "$Name/$FileName-DDS.csv"
        $ResultPath_BASE = "$Name/$FileName-BASE.csv"
        Get-Content $OutputPath_DDS | Sort-Object | get-unique > $ResultPath_DDS
        Get-Content $OutputPath_BASE | Sort-Object | get-unique > $ResultPath_BASE

        Remove-Item $OutputPath_BASE
        Remove-Item $OutputPath_DDS
    }
    Default {
        return
    }
}

Remove-Item $DumpPath
Remove-Item $StringPath