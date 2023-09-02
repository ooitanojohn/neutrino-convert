@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

: Project settings
set BASENAME=sample1
set NumThreads=4
set InferenceMode=3
set PhraseNum=1

: musicXML_to_label.exe
set SUFFIX=musicxml

: NEUTRINO.exe
set ModelDir=MERROW
set StyleShift=0

: NSF
set PitchShiftNsf=0

: WORLD
set PitchShiftWorld=0
set FormantShift=1.0
set SmoothPitch=0.0
set SmoothFormant=0.0
set EnhanceBreathiness=0.0

if %InferenceMode% equ 4 (
    set NsfModel=va
    set SamplingFreq=48
) else if %InferenceMode% equ 3 (
    set NsfModel=vs
    set SamplingFreq=48
) else if %InferenceMode% equ 2 (
    set NsfModel=ve
    set SamplingFreq=24
)

echo %date% %time% : start MusicXMLtoLabel
bin\musicXMLtoLabel.exe score\musicxml\%BASENAME%.%SUFFIX% score\label\full\%BASENAME%.lab score\label\mono\%BASENAME%.lab

echo %date% %time% : start NEUTRINO
bin\NEUTRINO.exe score\label\full\%BASENAME%.lab score\label\timing\%BASENAME%.lab output\%BASENAME%.f0 output\%BASENAME%.melspec model\%ModelDir%\ -w output\%BASENAME%.mgc output\%BASENAME%.bap -i output\%BASENAME%-phraselist.txt -p %PhraseNum% -n 1 -k %StyleShift% -o %NumThreads% -d %InferenceMode% -m -t

echo %date% %time% : start NSF
bin\NSF.exe output\%BASENAME%.f0 output\%BASENAME%.melspec .\model\%ModelDir%\%NsfModel%.bin output\%BASENAME%-%PhraseNum%.wav -n 1 -p %NumThreads% -s %SamplingFreq% -f %PitchShiftNsf% -m -t

echo %date% %time% : start WORLD
bin\WORLD.exe output\%BASENAME%.f0 output\%BASENAME%.mgc output\%BASENAME%.bap output\%BASENAME%-%PhraseNum%_world.wav -f %PitchShiftWorld% -m %FormantShift% -p %SmoothPitch% -c %SmoothFormant% -b %EnhanceBreathiness% -n %NumThreads% -t

echo %date% %time% : end
