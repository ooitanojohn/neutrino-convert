param(
    [string]$BASENAME,
    [string]$ModelDir
)

$NumThreads = 4
$InferenceMode = 3

# musicXML_to_label
$SUFFIX = "musicxml"

# NSF
$PitchShiftNsf = 0

# WORLD
$PitchShiftWorld = 0
$FormantShift = 1.0
$SmoothPitch = 0.0
$SmoothFormant = 0.0
$EnhanceBreathiness = 0.0

if ($InferenceMode -eq 4) {
    $NsfModel = "va"
    $SamplingFreq = 48
} elseif ($InferenceMode -eq 3) {
    $NsfModel = "vs"
    $SamplingFreq = 48
} elseif ($InferenceMode -eq 2) {
    $NsfModel = "ve"
    $SamplingFreq = 24
}

Write-Host "$(Get-Date) : start MusicXMLtoLabel"
.\bin\musicXMLtoLabel.exe score\musicxml\$BASENAME.$SUFFIX score\label\full\$BASENAME.lab score\label\mono\$BASENAME.lab

Write-Host "$(Get-Date) : start NEUTRINO"
.\bin\NEUTRINO.exe score\label\full\$BASENAME.lab score\label\timing\$BASENAME.lab output\$BASENAME.f0 output\$BASENAME.melspec model\$ModelDir\ -w output\$BASENAME.mgc output\$BASENAME.bap -n 1 -k $StyleShift -o $NumThreads -d $InferenceMode -m -t

Write-Host "$(Get-Date) : start NSF"
.\bin\NSF.exe output\$BASENAME.f0 output\$BASENAME.melspec .\model\$ModelDir\$NsfModel.bin output\$BASENAME.wav -l score\label\timing\$BASENAME.lab -n 1 -p $NumThreads -s $SamplingFreq -f $PitchShiftNsf -m -t

Write-Host "$(Get-Date) : start WORLD"
.\bin\WORLD.exe output\$BASENAME.f0 output\$BASENAME.mgc output\$BASENAME.bap output\$BASENAME_world.wav -f $PitchShiftWorld -m $FormantShift -p $SmoothPitch -c $SmoothFormant -b $EnhanceBreathiness -n $NumThreads -t

Write-Host "$(Get-Date) : end"
