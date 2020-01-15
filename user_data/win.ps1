cd C:\
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
curl https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe -o git.exe -UseBasicParsing
Start-Process -FilePath C:\git.exe -Args '/silent /install' -Verb RunAs -Wait
C:\'Program Files'\Git\bin\git.exe clone https://github.com/MatheusGPerini/lab-terraform-aws-iis.git
mkdir c:\website\lab
cd C:\website\lab
Copy-Item -Path "C:\lab-terraform-aws-iis\site\*" -Destination "C:\website\lab\" -Recurse
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Install-WindowsFeature -name Web-Server -IncludeManagementTools
New-WebAppPool labsite
New-WebSite -Name labsite -Port 8080 -ApplicationPool labsite -PhysicalPath "C:\website\lab"