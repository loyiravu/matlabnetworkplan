@echo off
@ ECHO.
@ ECHO.
@ ECHO.                              说    明
@ ECHO -----------------------------------------------------------------------
@ ECHO 这是网上流传的批处理。它会帮您删除回收站、临时目录、最近打开过的文档痕迹
@ ECHO 等。对系统运行稍有帮助。但不能根治速度慢的问题。电脑速度慢通常是因为太多
@ ECHO 无用的运算占据了CPU和内存资源所致，非删除一些文件就能解决。建议装好系统后，
@ ECHO 及时做Ghost备份。以后如果觉得运行不畅了，就恢复系统，这是最彻底的办法。
@ ECHO -----------------------------------------------------------------------
@ ECHO.
pause
echo 正在清理系统垃圾文件，请稍等......
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
echo 清理系统垃圾完成！
echo. & pause 