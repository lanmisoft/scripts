@echo off
setlocal
SET CurrentDir=%~dp0
set lldp_file="%CurrentDir%lldp.etl"
set lldp_txt_file="%CurrentDir%lldp.txt"
echo ===== pktmon setup...====
pktmon stop
pktmon reset
pktmon filter remove
echo LLDP filter setup..
pktmon filter add --ethertype 0x88cc
pktmon filter list
pktmon list
 echo ====== Packets form ETHERNET cards only...====
pktmon start --capture --pkt-size 0 --file-name "%lldp_file%" --comp nics 
:LOOP
 pktmon counters
 echo ====== Waiting for LLDP packet,press a-z to exit loop...====
 choice /C abcdefghijklmnopqrstuvwxyz1234567890 /T 5 /D 0 > nul
if ErrorLevel 1 if not ErrorLevel 36 goto :QUIT
goto :LOOP
:QUIT
pktmon status
pktmon stop
pktmon etl2txt %lldp_file% --verbose 3 
Start %~dp0notepadplus.exe %lldp_txt_file% -lbatch 