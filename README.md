# Lua-IP-Mask
Simple Lua based utility to mask ip adresses in files and piped command output

# How to get it.
get the latest release from the releases section or build yourself using [luvi](https://github.com/luvit/luvi)

---
#### usage instructions

put luaipmask somwhere easy to get to _prefereably somwhere in your path see [windows](https://helpdeskgeek.com/windows-10/add-windows-path-environment-variable/) 
linux: just stick it in your users private bin. or `/user/bin`

its a simple tool. either
luaipmask ./ipaddresses.txt                           -- prints the contents of a file with "masked" ip addresses to the console
luaipmask ./ipaddresses.txt > maskedAddresses.txt     -- redirects the printed "masked" file to a new "masked" file
ipconfig | luaipmask                                  -- prints the output of a command with "masked" ip addresses
ipconfig | luaipmask > maskedAddresses.txt            -- redirect the piped output to a "masked" file

#### screenshots

linux usage
![image](https://user-images.githubusercontent.com/747653/173941203-d6177d86-2418-4bcf-b8cd-7150998f8b73.png)

windows usage
![image](https://user-images.githubusercontent.com/747653/173941831-5c4ce164-8dd8-4750-aad1-ede53beb2bd9.png)


thats all for now :)
suggestions/improvements are welcomed - Issues must be relevant. non relevant discusion will be closed...

---
#### build instructions

download the repo and copy the cintents to a folder called `ipmask`
or clone it using `git clone https://github.com/SvalTek/Lua-IP-Mask ipmask`
run luvi with the following arguments `luvi ./ipmask/ -o luaipmask` (if on windows luaipmask.exe)
this will bundle the script into a zip and append it to the end of luvi's "launcher"

