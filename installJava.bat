@echo off
mkdir %USERPROFILE%\jdks

setlocal
cd /d %~dp0

cls

echo 1/3 - Descargando archivos
Call :DownloadOpenJDK

echo 2/3 - Descomprimiendo archivos
Call :UnZipFile "%USERPROFILE%\jdks" "%USERPROFILE%\jdks\openjdk-18.0.1.1_windows-x64_bin.zip"

echo 3/3 - Creando variables de entorno
Call :EnvironmentVariable

echo Agregar al Path de variable de entonrno:
echo %USERPROFILE%\jdks\jdk-18.0.1.1

exit /b


:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
exit /b

:EnvironmentVariable
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Dim WshShell
>>%vbs% echo Dim Env
>>%vbs% echo Set WshShell = WScript.CreateObject("WScript.Shell")
>>%vbs% echo Set Env = WshShell.Environment("SYSTEM")
>>%vbs% echo Env("JAVA_HOME") = "%USERPROFILE%\jdks\jdk-18.0.1.1"
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
exit /b


:DownloadOpenJDK
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo strFileURL = "https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_windows-x64_bin.zip"
>>%vbs% echo strHDLocation = "%USERPROFILE%\jdks\openjdk-18.0.1.1_windows-x64_bin.zip"
>>%vbs% echo Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
>>%vbs% echo objXMLHTTP.open "GET", strFileURL, false
>>%vbs% echo objXMLHTTP.send()
>>%vbs% echo If objXMLHTTP.Status = 200 Then
>>%vbs% echo 	Set objADOStream = CreateObject("ADODB.Stream")
>>%vbs% echo 	objADOStream.Open
>>%vbs% echo 	objADOStream.Type = 1 'adTypeBinary
>>%vbs% echo 	objADOStream.Write objXMLHTTP.ResponseBody
>>%vbs% echo 	objADOStream.Position = 0 'Set the stream position to the start	
>>%vbs% echo 	Set objFSO = Createobject("Scripting.FileSystemObject")
>>%vbs% echo 		If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation
>>%vbs% echo 	Set objFSO = Nothing	
>>%vbs% echo 	objADOStream.SaveToFile strHDLocation
>>%vbs% echo 	objADOStream.Close
>>%vbs% echo 	Set objADOStream = Nothing
>>%vbs% echo End if
>>%vbs% echo Set objXMLHTTP = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
exit /b
