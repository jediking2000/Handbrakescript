$dir = "$pwd"
cd $dir

set-Alias handbrake $pwd\HandBrakeCLI.exe

$exclude = Get-Content $pwd\ExcludeList.txt


$i = 0
"Start Script" > $pwd\HandbrakeLog.txt

$files = Get-Childitem $dir -recurse | ? { !$_.PsIsContainer -and $_.Name -match "mkv" -and $exclude -notcontains $_.FullName -and !( $_.FullName -match "N:\videos\tv\Game of Thrones" ) }
"Start Script" > $pwd\Files.txt
foreach ($file in $files)
{
  $file.FullName >> $pwd\Files.txt
}  

#$files = Get-Childitem $dir -recurse | ? { !$_.PsIsContainer -and $exclude -notcontains $_.FullName }

foreach ($file in $files)
{
   # $newpath = $file.DirectoryName + "\Encoded" 
   # if (-not (Test-Path -Path $newpath))
   # {
   #     New-Item $newpath -ItemType Directory
   # }
    $check = $file.DirectoryName + "\noencode"
    if (-not (Test-Path -Path $check)) 
    {
        $newname = $file.DirectoryName + "\" + $file.BaseName + ".mp4"
        $newname
        #Write-Progress -Activity "Encoding Files..." -Status "Encoded $i of $($files.count)" -Currentoperation $PSObject -PercentComplete (($i / $files.count) * 100)
        handbrake -i $file.FullName --verbose -f av_mp4 -e x265 --encoder-preset slow -q 24.0 --vfr --native-language "eng" --audio-lang-list "eng" --aencoder ca_aac --mixdown 7point1 --auto-anamorphic --keep-display-aspect --no-comb-detect --no-deinterlace --no-decomb --no-detelecine --no-hqdn3d --no-nlmeans --no-unsharp --no-lapsharp --no-deblock --no-grayscale --subtitle scan --subtitle-forced -o $newname 
        $log = $file.FullName
        $log >> $pwd\HandbrakeLog.txt
        $log >> $pwd\ExcludeList.txt
        $i++
        #$trash = '$pwd' + "\Done\" + '$file.DirectoryName' + '$file.name'
        $trash = $file.BaseName + ".Done"
        move-item -Path $file.FullName -Destination $pwd\Done\$trash
        }
    
}


if ($i -eq 0)
{
    ' '
    'Error...'
    start-sleep -seconds 1
    ' '
    'No matching files found.'

    ' '
    start-sleep -Seconds 1

    'Script exiting...'
    start-sleep -Seconds 2
}
