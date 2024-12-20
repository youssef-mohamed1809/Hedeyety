Set-Location -Path "C:\Users\youss\StudioProjects\Hedeyety"

$recordingProcess = Start-Process -FilePath "adb" -ArgumentList "shell screenrecord /sdcard/test_recording.mp4" -NoNewWindow -PassThru
Write-Host "Recording starting..."

Start-Sleep -Seconds 5

Write-Host "Test script will start"
Start-Process -FilePath "flutter" -ArgumentList "test integration_test/app_test.dart" -NoNewWindow -Wait

Stop-Process -Id $recordingProcess.Id -ErrorAction Stop

Write-Host "Video will be saved..."
Start-Sleep -Seconds 2

Start-Process -FilePath "adb" -ArgumentList "pull /sdcard/test_recording.mp4" -NoNewWindow -Wait -ErrorAction Stop

Write-Host "Recording and test complete!"

Write-Host "Press any key to exit..."
[System.Console]::ReadKey() | Out-Null




#$recordingProcess = Start-Process -FilePath "adb" -ArgumentList "shell screenrecord /sdcard/test_recording.mp4" -NoNewWindow -PassThru
##$recordingPID = $recordingProcess.Id
#
#Write-Host "Recording starting..."
#Start-Sleep -Seconds 5
#
#Write-Host "Test script will start"
#Start-Process -FilePath "C:\dev\flutter\bin\cache\dart-sdk\bin\dart.exe" -ArgumentList "test C:\Users\youss\StudioProjects\Hedeyety\integration_test\app_test.dart" -Wait
#
#Stop-Process -Id $recordingProcess.Id
#
#Write-Host "Video will saving..."
#Start-Sleep -Seconds 2
#
#Start-Process -FilePath "adb" -ArgumentList "pull /sdcard/test_recording.mp4" -Wait
#
##[System.Console]::ReadKey() | Out-Null
#Read-Host
##$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


