@ECHO OFF
ECHO "File: %~1"
SET SCRIPTPATH=%~dp0

ECHO "Script dir: "%SCRIPTPATH%
SET INPUTDIR=%SCRIPTPATH%origin
SET OUTPUTDIR=%SCRIPTPATH%destination

if not exist "%SCRIPTPATH%origin" mkdir %SCRIPTPATH%origin
if not exist "%SCRIPTPATH%destination" mkdir %SCRIPTPATH%destination

ECHO "Input dir: "%INPUTDIR%
ECHO "Output dir: "%OUTPUTDIR%

docker image inspect stockmind/gpd-pocket-ubuntu-respin:latest >NUL
IF errorlevel 1 (
	ECHO "Docker hub image not found!"
	docker image inspect gpd-pocket-ubuntu-respin:latest >NUL
	IF errorlevel 1 (
		ECHO "Local Docker image not found!"
		echo "Build docker image or download it from Docker Hub with 'docker pull stockmind/gpd-pocket-ubuntu-respin'!"
		pause
		exit 1
	) ELSE (
	 	ECHO "Local Docker image found!"
	 	SET IMAGENAME="gpd-pocket-ubuntu-respin"
	)
) ELSE (
	ECHO "Docker hub image found!" 
	SET IMAGENAME="stockmind/gpd-pocket-ubuntu-respin"
)

REM CLEAN OLD CONTAINER
docker rm gpd-pocket-kernel-container

REM RUN KERNEL BUILD
docker run -t -v %INPUTDIR%:/docker-input -v %OUTPUTDIR%:/docker-output --name gpd-pocket-kernel-container %IMAGENAME% kernel

pause
