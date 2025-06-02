# escape=`
FROM mcr.microsoft.com/windows/nanoserver:ltsc2025
USER ContainerAdministrator

COPY ./powershell C:\powershell
COPY oledlg.dll C:\Windows\SysWOW64\oledlg.dll
ADD https://aka.ms/vs/17/release/vc_redist.x86.exe C:\vc_redist.x86.exe

RUN setx /M PATH "%PATH%;C:\powershell;" 
RUN mklink C:\powershell\powershell.exe C:\powershell\pwsh.exe
RUN dism /Online /Add-Capability /CapabilityName:Microsoft.NanoServer.Datacenter.WOWSupport /NoRestart || if %ERRORLEVEL%==3010 exit 0
RUN C:\vc_redist.x86.exe /install /passive /norestart || if %ERRORLEVEL%==3010 exit 0
RUN del /F C:\vc_redist.x86.exe 