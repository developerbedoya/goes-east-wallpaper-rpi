set ws=wscript.createobject("wscript.shell")
ws.run "C:\Windows\System32\bash.exe ~ -lc 'cd /home/dbalz/bin/weather && ./get-visible-ir.sh'",0