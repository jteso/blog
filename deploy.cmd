@echo off
echo ==> Deploying site
echo --> %DEPLOYMENT_SOURCE%
echo --> %DEPLOYMENT_TARGET%

REM ---Deploy the _site folder in repository to default target (wwwroot)
xcopy %DEPLOYMENT_SOURCE%\_site\* %DEPLOYMENT_TARGET% /Y /s 

