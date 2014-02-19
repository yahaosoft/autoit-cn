; ===================================================================
; Project: CompileLib Library
; Description: Functions for retrieving settings and compiling projects.
; Author: Jason Boggs <vampire DOT valik AT gmail DOT com>
; ===================================================================
#include-once
;;;#RequireAdmin	; Required when running Nonreg Tests to avoid UAC prompt delayed at nonreg launch

; Stop x64 compiling for now - it should work OK but we don't want to be taking
; risks during build time
If @AutoItX64 Then
;~ 	MsgBox(16, @AutoItVersion, "Please only run the build scripts using the x86 version of AutoIt.")
;~ 	Exit
EndIf

#Region Members Exported
#cs Exported Functions
Compile_Main($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False) - The main function responsible for building a project.
Compile_Main_CS($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False)
Batch_Main($sProject, Const ByRef $aScripts) - The main function responsible for running the scripts.
_CompilerIsRunning($vCompiler) - Checks to see if the development environment is running and prompts the user to close it if it is.
_Compile($sSolutionPath, $vCompiler = "", $vPlatform = "", $vConfiguration = "", $bRebuild = True) - Performs compilation of the specified solution.
_SolutionPath($vCompiler, $sBuildRoot, $sName) - Returns the path to an existing solution for the specified compiler.
_SolutionHasX64($sSolutionPath) - Tets if a solution contains an x64 platform.
_CleanOutputDirs($sRoot) - Cleans common output sub-directories found in the root directory.
_CleanFiles($sRoot) - Cleans common build output files found in the root directory.
_CleanInstallOutput(Const ByRef $aInstallFiles, $sRoot = @WorkingDir) - Cleans a list of files in the installation directory.
_CopyBuildOutput(Const ByRef $aBuildOutput, Const ByRef $aInstallFiles, $sProject, $sRoot = @WorkingDir) - Copies build output to the installation directory.
_BuildOutputResult($nReturn, $nError, $nExtended, $vPlatform = $PLATFORM_WIN32) - Outputs a description of a build error.
_BuildDirSet() - Changes the working directory to the root build directory.
_SettingGet($vSetting, $vDefault = "", $bNumber = False, $sSection = $g_sSection) - Retrieves a setting.
_SettingGetSection($sSection) - Returns all key, value pairs in a section.
_SettingSet($vSetting, $vValue, $sSection = $g_sSection) - Sets a setting.
_SettingSetEnv($vSetting, $vValue = "") - Sets a setting in the environment which overrides the INI file.
_SettingGetIniFile() - Returns the path to the configuration file.
_Sign($sFile, $sDesc) - Signs the specified with a hard-coded certificate.
_ArchiveDir($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False) - Archives files.
_WinRAR($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False) - Runs WinRAR with the specified command.
_7Zip($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False) - Runs WinRAR with the specified command.
_CompilerProcess($vCompiler) - Returns the name of the process for the specified compiler.
_CompilerFullName($vCompiler) - Returns the name of a string in a human recognizable form.
_CompilerGetProjectSuffix($vCompiler) - Returns the project suffix for the specified compiler.
_CompilerGetSolutionDir($vCompiler) - Returns the solution directory for the specified compiler.
_PlatformName($vPlatform) - Returns the name of the specified platform.
_ConfigurationName($vConfiguration) - Returns the name of the specified configuration.
_ReleaseName($vConfiguration, $vPlatform) - Returns the composited release name.
_RegRead64($sKeyname, $sValue) - Returns the registry value
#ce Exported Functions
#EndRegion Members Exported

#Region Includes
#include "OutputLib.au3"
#include "UtilityLib.au3"
#EndRegion Includes

#Region Global Variables
; This variable should be updated whenever INI-breaking
; changes are introduced.  This is to alert the user that
; the INI file is out of date and a new INI needs generated.
Global Const $g_nExpectedIniVersion = 17

; Build related constants.
Global Const $PLATFORM_WIN32 = "Win32"
Global Const $PLATFORM_X64 = "x64"
Global Const $PLATFORM_CS_ANYCPU = "Any CPU"
Global Const $PLATFORM_CS_X86 = "x86"
Global Const $PLATFORM_CS_X64 = "x64"
Global Const $PLATFORM_EMPTY = ""

Global Const $CONFIGURATION_RELEASE = "Release"
Global Const $CONFIGURATION_DEBUG = "Debug"
Global Const $CONFIGURATION_EMPTY = ""

; Compiler related constants.
Global Const $COMPILER_EMPTY = ""

; Members of the Compiler Array.
;	Name - Short name of the compiler, i.e. "VC8"
; 	Full Name - Full name of the compiler, i.e. "Visual Studio 8.0"
; 	Compiler Reg Key - The registry key containing the path to the compiler.
;	Compiler Solution Dir - The name of the solution directory the build configuration will be under, i.e. VC8.0
;	Compiler Solution Suffix - The suffix appended to the project name for the specific compiler, i.e. _VC8.sln
;	Compiler Binary - The name of the executable image for the compiler, i.e devenv.exe
; 	Project Suffix - The suffix appended to project files, i.e. .vcproj or .vcxproj
Global Enum $COMPILER_NAME, $COMPILER_FULLNAME, $COMPILER_REGKEY, $COMPILER_SOLUTIONDIR, $COMPILER_SOLUTIONSUFFIX, _
		$COMPILER_BINARY, $COMPILER_PROJECTSUFFIX, $COMPILER_MAX

; Short names for compilers.  Used to identify compilers when not using the array.
Global Const $COMPILER_VC71 = "VC7.1"
Global Const $COMPILER_VC8 = "VC8"
Global Const $COMPILER_VC9 = "VC9"
Global Const $COMPILER_VC10 = "VC10"
Global Const $COMPILER_VC11 = "VC11"
Global Const $COMPILER_VC8EXPRESS = "VC8Express"
Global Const $COMPILER_VC9EXPRESS = "VC9Express"
Global Const $COMPILER_VC10EXPRESS = "VC10Express"
Global Const $COMPILER_VC11EXPRESS = "VC11Express"

; Compiler attribute array.
Global Const $g_aCompilerMap[9][$COMPILER_MAX] = [ _
		[$COMPILER_VC71, "Visual Studio 7.1", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\7.1", "VC7.1", ".sln", "devenv.exe", ".vcproj"], _
		[$COMPILER_VC8, "Visual Studio 8.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\8.0", "VC8.0", ".sln", "devenv.exe", ".vcproj"], _
		[$COMPILER_VC9, "Visual Studio 9.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\9.0", "VC9.0", ".sln", "devenv.exe", ".vcproj"], _
		[$COMPILER_VC10, "Visual Studio 10.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\10.0", "VC10.0", ".sln", "devenv.exe", ".vcxproj"], _
		[$COMPILER_VC11, "Visual Studio 11.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\11.0", "VC11.0", ".sln", "devenv.exe", ".vcxproj"], _
		[$COMPILER_VC8EXPRESS, "Visual Studio Express 8.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VCExpress\8.0", "VC8.0", ".sln", "VCExpress.exe", ".vcproj"], _
		[$COMPILER_VC9EXPRESS, "Visual Studio Express 9.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VCExpress\9.0", "VC9.0", ".sln", "VCExpress.exe", ".vcproj"], _
		[$COMPILER_VC10EXPRESS, "Visual Studio Express 10.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VCExpress\10.0", "VC10.0", ".sln", "VCExpress.exe", ".vcxproj"], _
		[$COMPILER_VC11EXPRESS, "Visual Studio Express 11.0", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VCExpress\11.0", "VC11.0", ".sln", "VCExpress.exe", ".vcxproj"] _
		]

; Visual Studio 2010 is the default compiler.
Global Const $COMPILER_DEFAULT = $COMPILER_VC10

Global Const $g_sIni = @ScriptDir & "\config.ini" ; DO NOT USE DIRECTLY (See _SettingGetIniFile())
Global Const $g_sSection = "Build"

; Settings Constants
Global Const $SETTING_BUILDDIR = "BuildDir"
Global Const $SETTING_COMPILER = "Compiler"
Global Const $SETTING_SIGN = "Sign"
Global Const $SETTING_RUNTEST = "RunTest"
Global Const $SETTING_ADMINTEST = "AdminTest"
Global Const $SETTING_RUNPERFORMANCE = "RunPerf"
Global Const $SETTING_STOPTEST = "StopTestFirstError"
Global Const $SETTING_ARCHIVE = "Archive"
Global Const $SETTING_PLATFORM = "Platform"
Global Const $SETTING_CONFIGURATION = "Configuration"
Global Const $SETTING_BUILDX64 = "Buildx64"
Global Const $SETTING_REBUILD = "RebuildAlways"
Global Const $SETTING_AUTOITX3TEST = "AutoItX3Test"
Global Const $SETTING_YEAR = "Year"
Global Const $SETTING_SVNCLIENT = "SubversionClient"
Global Const $SETTING_BUILDTYPE = "BuildType"
Global Const $SETTING_PROFILE = "Profile"
Global Const $SETTING_SCPHOSTKEY = "SCPHostKey"
Global Const $SETTING_SCPPRIVATEKEY = "SCPPrivateKey"
Global Const $SETTING_SCPSYNCBYSIZE = "SCPSyncBySize"
Global Const $SETTING_SCPSYNCBYDATE = "SCPSyncByDate"
Global Const $SETTING_PFXPASSWORD = "PFXPassword"
Global Const $SETTING_REBUILDHELPFILES = "RebuildHelpFiles"

; Define the Build Types supported.
Global Enum $BUILDTYPE_RELEASE, $BUILDTYPE_BETA, $BUILDTYPE_RELEASECANDIDATE
#EndRegion Global Variables

#Region Library Initialization

; Always show debugging information
AutoItSetOption("TrayIconDebug", True)
; We need to ensure the INI file is valid, otherwise we may attempt
; to use weird values.
__IsIniValid()

; Global variable to get BuildSuccessCallback return value
Global $g_nReturnBuildSuccessCallback = 0

#Region __IsIniValid()
; ===================================================================
; __IsIniValid()
;
; Checks to see if the version in the INI file matches the expected INI version.  This function will
;	abort the script if the INI file is invalid.
; Parameters:
;	None.
; Returns:
;	None.
; ===================================================================
Func __IsIniValid()
	Local $sIni = _SettingGetIniFile(True) ; use the redirected Config.ini not the doc\_build one
	If Not FileExists($sIni) Then
		If Not FileCopy($sIni & ".dist", $sIni) Then Return
	EndIf
	Local $nVersion = Number(IniRead($sIni, "IniVersion", "IniVersion", 0))
	If $nVersion <> $g_nExpectedIniVersion Then
		MsgBox(4112, "CompileLib Error", "Error, the INI file is out of date:" & @CRLF & $sIni)
		Exit -1
	EndIf
EndFunc   ;==>__IsIniValid
#EndRegion __IsIniValid()

#EndRegion Library Initialization

#Region Script Entry Points

#Region Compile_Main()
; ===================================================================
; Compile_Main($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False)
;
; The main function responsible for building a project.
; Parameters:
;	$sProject - IN - The name of the project.  This is the name of the Visual Studio project and the
; 		name of the directory where the project lives.
;	$aBuildFiles - IN - An array of files that are the build output.
;	$aInstallFiles - IN - An array of files that are part of the install.
;	$sBuildSuccessCallback - IN/OPTIONAL - On a successful build, this function will be Call()'ed for
;		any project-specific actions.
;	$sProjectDir - IN/OPTIONAL - The project directory if different than $sProject.
;	$bDisplayFullOutput - IN/OPTIONAL - If False some output is suppressed.
;	$bSkipInitialOutput - IN/OPTIONAL - If True then the "Output for..." message is skipped.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func Compile_Main($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False)
	Local $nReturnCode = 0

	; define default project dir
	If $sProjectDir = "" Then $sProjectDir = $sProject

	; Loads the compiler settings.
	Local $vCompiler = _SettingGet($SETTING_COMPILER)
	Local $vConfiguration = _SettingGet($SETTING_CONFIGURATION)
	Local $bRebuild = _SettingGet($SETTING_REBUILD, True, True)

	; Create the output window
	_OutputWindowCreate()

	; Initial output message
	If $bDisplayFullOutput And Not $bSkipInitialOutput Then _OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $sProject & ") ====" & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	_BuildDirSet()

	; Get solutionPath, if that fails, try the default compiler.
	Local $sSolutionPath = _SolutionPath($vCompiler, $sProjectDir & "\build", $sProject)
	If $sSolutionPath = "" Then
		$vCompiler = $COMPILER_DEFAULT
		$sSolutionPath = _SolutionPath($vCompiler, $sProjectDir & "\build", $sProject)
	EndIf

	If $sSolutionPath Then
		; Before making any changes, make sure the compiler isn't running.
		If Not _CompilerIsRunning($vCompiler) Then
			; Delete files in the install dir that we are about to change
			_CleanInstallOutput($aInstallFiles)

			; Compile 32-bit.
			Local $bCompiled = _Compile($sSolutionPath, $vCompiler, $PLATFORM_WIN32, $vConfiguration, $bRebuild)
			_BuildOutputResult($bCompiled, @error, @extended)

			; Compile 64-bit if allowed.
			If _SettingGet($SETTING_BUILDX64, False, True) And _SolutionHasX64($sSolutionPath) Then
				$bCompiled = BitOR($bCompiled, _Compile($sSolutionPath, $vCompiler, $PLATFORM_X64, $vConfiguration, $bRebuild))
				_BuildOutputResult($bCompiled, @error, @extended, $PLATFORM_X64)
			EndIf

			; Invert compiled status for return code.
			$nReturnCode = ($bCompiled = False)
			If $bCompiled Then
				; Invoke the build success callback.
				If $sBuildSuccessCallback Then Call($sBuildSuccessCallback)

				; Copy newly compiled files to install
				If _CopyBuildOutput($aBuildFiles, $aInstallFiles, $sProjectDir) = False Then
					_OutputProgressWrite("Copying build output failed." & @CRLF)
					$nReturnCode = 4
				EndIf

				; Optionally archive the source.
				If _SettingGet($SETTING_ARCHIVE, 0, True) Then
					; Get the file version.  This must be done before cleaning the build output.
					Local $sFileVersion = "0.0.0.0"

					; Build a list of potential locations to get the file version from.
					Local $aVersionFiles[3] = ["", "bin\AutoIt3.exe", "install\AutoIt3.exe"]

					; If there is a valid build output file then add it as the first source.
					If IsArray($aBuildFiles) And $aBuildFiles[0] Then $aVersionFiles[0] = "bin\" & $aBuildFiles[0]

					; Loop through the potential sources.
					For $i = 0 To UBound($aVersionFiles) - 1
						If $aVersionFiles[$i] Then
							$sFileVersion = FileGetVersion($aVersionFiles[$i])
							; If the version was not found flag an error.
							If $sFileVersion = "0.0.0.0" Then
								_OutputProgressWrite("Unable to read file version from file: " & $aVersionFiles[$i] & @CRLF)
							Else
								ExitLoop ; Found a version so stop processing.
							EndIf
						EndIf
					Next

					; Clean all the common build directories and files for this project.
					_CleanFiles($sProjectDir)

					Local $sArchiveName = $sProject & "-src-v" & $sFileVersion
					Local $aExcludes[23] = ["*\.svn", "*\.svn\*", "*\build\VC7.1\*.suo", _
							"*\build\VC8.0\*.suo", "*\build\VC8.0\*.user", "*\build\VC8.0\*.ncb", _
							"*\build\VC9.0\*.suo", "*\build\VC9.0\*.user", "*\build\VC9.0\*.ncb", _
							"*\build\VC10.0\*.sdf", "*\build\VC10.0\*.user", "*\build\VC10.0\*.opensdf", _
							"*\build\VC10.0\ipch", "*\build\VC10.0\ipch\*", "*\build\VC10.0\*.suo", _
							"*\build\VC11.0\*.sdf", "*\build\VC11.0\*.user", "*\build\VC11.0\*.opensdf", _
							"*\build\VC11.0\ipch", "*\build\VC11.0\ipch\*", "*\build\VC11.0\*.suo", _
							"*\bin\*.pdb", "*\bin\Include\*"]
					_ArchiveDir($sProjectDir, $sArchiveName, $aExcludes, True)
				EndIf
			EndIf
		Else
			_OutputProgressWrite("Build failed: Compiler already running." & @CRLF)
			$nReturnCode = 2
		EndIf
	Else
		_OutputProgressWrite("Solution not found for: " & _CompilerFullName($vCompiler) & @CRLF)
		$nReturnCode = 3
	EndIf

	$nReturnCode += $g_nReturnBuildSuccessCallback

	; Write closing message and wait for close (if applicable).
	If $bDisplayFullOutput Then
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
		_OutputWaitClosed($nReturnCode)
	EndIf

	Return $nReturnCode
EndFunc   ;==>Compile_Main
#EndRegion Compile_Main()

#Region Compile_Main_CS()
; ===================================================================
; Compile_Main_CS($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False)
;
; The main function responsible for building a project.
; Parameters:
;	$sProject - IN - The name of the project.  This is the name of the Visual Studio project and the
; 		name of the directory where the project lives.
;	$aBuildFiles - IN - An array of files that are the build output.
;	$aInstallFiles - IN - An array of files that are part of the install.
;	$sBuildSuccessCallback - IN/OPTIONAL - On a successful build, this function will be Call()'ed for
;		any project-specific actions.
;	$sProjectDir - IN/OPTIONAL - The project directory if different than $sProject.
;	$bDisplayFullOutput - IN/OPTIONAL - If False some output is suppressed.
;	$bSkipInitialOutput - IN/OPTIONAL - If True then the "Output for..." message is skipped.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func Compile_Main_CS($sProject, Const ByRef $aBuildFiles, Const ByRef $aInstallFiles, $sBuildSuccessCallback = "", $sProjectDir = "", $bDisplayFullOutput = True, $bSkipInitialOutput = False)
	Local $nReturnCode = 0

	; define default project dir
	If $sProjectDir = "" Then $sProjectDir = $sProject

	; Loads the compiler settings.
	Local $vCompiler = _SettingGet($SETTING_COMPILER)
	Local $vConfiguration = _SettingGet($SETTING_CONFIGURATION)
	Local $bRebuild = _SettingGet($SETTING_REBUILD, True, True)

	; Create the output window
	_OutputWindowCreate()

	; Initial output message
	If $bDisplayFullOutput And Not $bSkipInitialOutput Then _OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $sProject & ") ====" & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	_BuildDirSet()

	; Get solutionPath
	Local $sSolutionPath = _SolutionPath($vCompiler, $sProjectDir & "\build", $sProject)

	; Try again with no build directory (CS projects)
	If $sSolutionPath = "" Then
		$sSolutionPath = _SolutionPath($vCompiler, $sProjectDir, $sProject)
	EndIf

	; Try again with default compiler
	If $sSolutionPath = "" Then
		$vCompiler = $COMPILER_DEFAULT
		$sSolutionPath = _SolutionPath($vCompiler, $sProjectDir & "\build", $sProject)
	EndIf

	If $sSolutionPath Then
		; Before making any changes, make sure the compiler isn't running.
		If Not _CompilerIsRunning($vCompiler) Then
			; Delete files in the install dir that we are about to change
			_CleanInstallOutput($aInstallFiles)

			; Compile Any CPU.
			Local $bCompiled = _Compile($sSolutionPath, $vCompiler, $PLATFORM_CS_ANYCPU, $vConfiguration, $bRebuild)
			_BuildOutputResult($bCompiled, @error, @extended)

			; Compile 64-bit if allowed.
			If _SettingGet($SETTING_BUILDX64, False, True) And _SolutionHasX64($sSolutionPath) Then
				$bCompiled = BitOR($bCompiled, _Compile($sSolutionPath, $vCompiler, $PLATFORM_X64, $vConfiguration, $bRebuild))
				_BuildOutputResult($bCompiled, @error, @extended, $PLATFORM_X64)
			EndIf

			; Invert compiled status for return code.
			$nReturnCode = ($bCompiled = False)
			If $bCompiled Then
				; Invoke the build success callback.
				If $sBuildSuccessCallback Then Call($sBuildSuccessCallback)

				; Copy newly compiled files to install
				If _CopyBuildOutput($aBuildFiles, $aInstallFiles, $sProjectDir) = False Then
					_OutputProgressWrite("Copying build output failed." & @CRLF)
					$nReturnCode = 4
				EndIf
			EndIf
		Else
			_OutputProgressWrite("Build failed: Compiler already running." & @CRLF)
			$nReturnCode = 2
		EndIf
	Else
		_OutputProgressWrite("Solution not found for: " & _CompilerFullName($vCompiler) & @CRLF)
		$nReturnCode = 3
	EndIf

	$nReturnCode += $g_nReturnBuildSuccessCallback

	; Write closing message and wait for close (if applicable).
	If $bDisplayFullOutput Then
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
		_OutputWaitClosed($nReturnCode)
	EndIf

	Return $nReturnCode
EndFunc   ;==>Compile_Main_CS
#EndRegion Compile_Main_CS()


#Region Batch_Main()
; ===================================================================
; Batch_Main($sProject, Const ByRef $aScripts)
;
; The main function responsible for running the scripts.
; Parameters:
;	$sProject - IN - The name of the project.
;	$aScripts - IN - An array of scripts to run.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func Batch_Main($sProject, Const ByRef $aScripts)
	; Create the output window so all output will go into one window.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Starting " & StringTrimRight(@ScriptName, 4) & " (" & $sProject & ") ====" & @CRLF)

	Local $nReturn
	; Run all the scripts
	Local $nSuccess = 0
	For $i = 0 To UBound($aScripts) - 1
		If $aScripts[$i] Then
			_OutputProgressWrite(@CRLF & "Running " & $aScripts[$i] & " (" & $i + 1 & "/" & UBound($aScripts) & ")..." & @CRLF)
			$nReturn = _RunWaitScript(@ScriptDir & "\" & $aScripts[$i], "", @ScriptDir)
			If $nReturn Then ; An error occured.
				_OutputProgressWrite($aScripts[$i] & " did not complete successfully... ")
				Switch MsgBox(262144 + 2 + 8192 + 48, "Warning", $aScripts[$i] & " did not complete successfully.", 300)
					Case -1, 3 ; Abort, assume abort on timeout.
						_OutputProgressWrite("Aborting." & @CRLF)
						$nReturn = 1
						ExitLoop
					Case 4 ; Retry
						_OutputProgressWrite("Retrying." & @CRLF)
						$i -= 1 ; We have to decrement because the For loop will increment
					Case 5 ; Ignore
						_OutputProgressWrite("Ignoring." & @CRLF)
						$nReturn = 0
				EndSwitch
			Else
				$nSuccess += 1
			EndIf
		EndIf
	Next

	$nReturn = UBound($aScripts) - $nSuccess

	; Wait for close (if applicable).
	_OutputProgressWrite("==== " & StringTrimRight(@ScriptName, 4) & " Finished: " & _
			$nSuccess & "/" & UBound($aScripts) & " Completed ====" & @CRLF & @CRLF)
	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>Batch_Main
#EndRegion Batch_Main()

#EndRegion Script Entry Points

#Region Public Members

#Region _CompilerIsRunning()
; ===================================================================
; _CompilerIsRunning($vCompiler)
;
; Checks to see if the development environment is running and prompts the user to close it if it is.
; Parameters:
;	$vCompiler - IN - The compiler to check for.
; Returns:
;	True if the compiler is running, False otherwise.
; ===================================================================
Func _CompilerIsRunning($vCompiler)
	Local $sExe = _CompilerProcess($vCompiler)
	Local $bExists
	Do
		$bExists = ProcessExists($sExe)
		If $bExists Then
			Switch MsgBox(262144 + 2 + 8192 + 48, "Warning", "Your development environment is running, for safest operation, please close it.", 30)
				Case -1, 3 ; Abort, assume abort on timeout.
					$bExists = True
					ExitLoop
				Case 4 ; Retry
					$bExists = True
				Case 5 ; Ignore
					$bExists = False
			EndSwitch
		EndIf
	Until Not $bExists
	Return $bExists
EndFunc   ;==>_CompilerIsRunning
#EndRegion _CompilerIsRunning()

#Region _Compile()
; ===================================================================
; _Compile($sSolutionPath, $vCompiler = "", $vPlatform = "", $vConfiguration = "", $bRebuild = True)
;
; Performs compilation of the specified solution.
; Parameters:
;	$sSolutionPath - IN - The solution to compile.
;	$vCompiler - IN/OPTIONAL - The compiler to use.  Defaults to $COMPILER_DEFAULT.
;	$vPlatform - IN/OPTIONAL - The platform to use.  Defaults to $PLATFORM_WIN32
;	$vConfiguration - IN/OPTIONAL - The configuration to use.  Defaults to $CONFIGURATION_RELEASE
;	$bRebuild - IN/OPTIONAL - If True, performs /rebuild, otherwise /build.
; Returns:
;	Non-zero on success, 0 on failure.
; ===================================================================
Func _Compile($sSolutionPath, $vCompiler = "", $vPlatform = "", $vConfiguration = "", $bRebuild = True)
	; Ensure we specify a valid platform.
	If $vCompiler = $COMPILER_EMPTY Then $vCompiler = $COMPILER_DEFAULT
	If $vPlatform = $PLATFORM_EMPTY Then $vPlatform = $PLATFORM_WIN32
	If $vConfiguration = $CONFIGURATION_EMPTY Then $vConfiguration = $CONFIGURATION_RELEASE

	; Get the path to the compiler.
	Local $sCompilerPath
	For $i = 0 To UBound($g_aCompilerMap) - 1
		If $g_aCompilerMap[$i][$COMPILER_NAME] = $vCompiler Then
			$sCompilerPath = _RegRead64($g_aCompilerMap[$i][$COMPILER_REGKEY], "InstallDir")
			If $sCompilerPath Then $sCompilerPath &= _CompilerProcess($vCompiler)
		EndIf
	Next
	If $sCompilerPath = $COMPILER_EMPTY Then Return SetError(1, 0, False)

	; Ensure the compiler exists.
	If Not FileExists($sCompilerPath) Then Return SetError(2, 0, False)

	; Compile
	Local Const $sOutputFile = @ScriptDir & "\Build.log"
	Local $sCmd
	Local $sRebuild = " /rebuild "
	If Not $bRebuild Then $sRebuild = " /build "
	Switch $vCompiler
		Case $COMPILER_VC71
			$sCmd = '"' & $sCompilerPath & '" "' & $sSolutionPath & '"' & $sRebuild & '"' & _ConfigurationName($vConfiguration) & '" /out "' & $sOutputFile & '"'
		Case Else
			$sCmd = '"' & $sCompilerPath & '" "' & $sSolutionPath & '"' & $sRebuild & '"' & _ReleaseName($vConfiguration, $vPlatform) & '" /out "' & $sOutputFile & '"'
	EndSwitch
	Local $nReturn = _RunWaitForwardFileOutput("_OutputBuildWrite", $sOutputFile, $sCmd)
	FileDelete($sOutputFile)
	; Visual Studio returns 0 on success but we return a boolean.
	Return $nReturn = 0
EndFunc   ;==>_Compile
#EndRegion _Compile()

#Region _SolutionPath()
; ===================================================================
; _SolutionPath($vCompiler, $sBuildRoot, $sName)
;
; Returns the path to an existing solution for the specified compiler.
; Parameters:
;	$vCompiler - IN - The compiler to use.
;	$sBuildRoot - IN - The root directory to search in.  A compiler specific directory will be appended to
;		this path.
;	$sName - IN - The name of the project.  A compiler specific suffix and extension will be appended
;		to this name.
; Returns:
;	If the specified solution exists, the full path to it, otherwise an empty string.
; ===================================================================
Func _SolutionPath($vCompiler, $sBuildRoot, $sName)
	Local $sSolutionPath

	; First try the standard structure we use for C++ \VC11.0\ProjectName.sln
	For $i = 0 To UBound($g_aCompilerMap) - 1
		If $g_aCompilerMap[$i][$COMPILER_NAME] = $vCompiler Then
			$sSolutionPath = $sBuildRoot & "\" & $g_aCompilerMap[$i][$COMPILER_SOLUTIONDIR] & "\" _
					 & $sName & $g_aCompilerMap[$i][$COMPILER_SOLUTIONSUFFIX]
		EndIf
	Next
	If FileExists($sSolutionPath) Then Return $sSolutionPath

	; If that doesn't work try just ProjectName.sln with no compiler specific directory/name (used in C# projects)
	For $i = 0 To UBound($g_aCompilerMap) - 1
		If $g_aCompilerMap[$i][$COMPILER_NAME] = $vCompiler Then
			$sSolutionPath = $sBuildRoot & "\" & $sName & $g_aCompilerMap[$i][$COMPILER_SOLUTIONSUFFIX]
		EndIf
	Next
	If FileExists($sSolutionPath) Then Return $sSolutionPath

	Return ""
EndFunc   ;==>_SolutionPath
#EndRegion _SolutionPath()

#Region _SolutionHasX64()
; ===================================================================
; _SolutionHasX64($sSolutionPath)
;
; Tets if a solution contains an x64 platform.
; Parameters:
;	$sSolutionPath - IN - The solution to check.
; Returns:
;	True if an x64 platform exists, False if not.
; ===================================================================
Func _SolutionHasX64($sSolutionPath)
	Local $sFile = FileRead($sSolutionPath)
	Return StringRegExp($sFile, "(?i)Release\|x64")
EndFunc   ;==>_SolutionHasX64
#EndRegion _SolutionHasX64()

#Region _CleanOutputDirs()
; ===================================================================
; _CleanOutputDirs($sRoot)
;
; Cleans common output sub-directories found in the root directory.
; Parameters:
;	$sRoot - IN - The root directory containing sub-directories to be cleaned.
; Returns:
;	None.
; ===================================================================
Func _CleanOutputDirs($sRoot)
	; Pattern matches either "debug" or "release" or strings starting
	; with "debug" or "release" and ending with "win32" or "x64"
	Local Const $sPattern = "(?i)(?:debug|release)(?:.*(?=win32|x64)|$)"
	Local $hSearch = FileFindFirstFile($sRoot & "\*.*")
	Local $sFileList
	While True
		Local $sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		; If file is a directory and matches the pattern add it to the list.
		If StringRegExp($sFile, $sPattern) And StringInStr(FileGetAttrib($sRoot & "\" & $sFile), "D") Then
			$sFileList &= $sFile & "|"
		EndIf
	WEnd

	; Split the list into an array.
	Local Const $aSubDirs = StringSplit($sFileList, "|", 2)

	; The last element, if present, will be empty so skip it.
	For $i = 0 To UBound($aSubDirs) - 2
		DirRemove($sRoot & "\" & $aSubDirs[$i], 1)
	Next
EndFunc   ;==>_CleanOutputDirs
#EndRegion _CleanOutputDirs()

#Region _CleanFiles()
; ===================================================================
; _CleanFiles($sRoot)
;
; Cleans common build output files found in the root directory.
; Parameters:
;	$sRoot - IN - The root directory containing files to be cleaned.
; Returns:
;	None.
; ===================================================================
Func _CleanFiles($sRoot)
	Local $aFiles[14] = [ _
			"bin\*.pdb", _
			"bin\*.ilk", _
			"bin\*.lib", _
			"bin\*.exp", _
			"bin\*.dll", _
			"build\VC9.0\*.ncb", _
			"build\VC9.0\*.plg", _
			"build\VC8.0\*.ncb", _
			"build\VC8.0\*.plg", _
			"build\VC7.1\*.ncb", _
			"build\VC7.1\*.plg", _
			"build\VC6\*.ncb", _
			"build\VC6\*.plg", _
			"src\resources\*.aps" _
			]

	For $i = 0 To UBound($aFiles) - 1
		If $aFiles[$i] Then FileDelete($sRoot & "\" & $aFiles[$i])
	Next
EndFunc   ;==>_CleanFiles
#EndRegion _CleanFiles()

#Region _CleanInstallOutput()
; ===================================================================
; _CleanInstallOutput(Const ByRef $aInstallFiles, $sRoot = @WorkingDir)
;
; Cleans a list of files in the installation directory.
; Parameters:
;	$aInstallFiles - IN - The list of files to clean.
;	$sRoot - IN/OPTIONAL - The root directory which contains the "install" directory.
; Returns:
;	None.
; ===================================================================
Func _CleanInstallOutput(Const ByRef $aInstallFiles, $sRoot = @WorkingDir)
	For $i = 0 To UBound($aInstallFiles) - 1
		If $aInstallFiles[$i] Then FileDelete($sRoot & "\install\" & $aInstallFiles[$i])
	Next
EndFunc   ;==>_CleanInstallOutput
#EndRegion _CleanInstallOutput()

#Region _CopyBuildOutput()
; ===================================================================
; _CopyBuildOutput(Const ByRef $aBuildOutput, Const ByRef $aInstallFiles, $sProject, $sRoot = @WorkingDir)
;
; Copies build output to the installation directory.
; Parameters:
;	$aBuildOutput - IN - The list of build output files.
;	$aInstallFiles - IN - The list of destination installation files.
;	$sProject - IN - The name of the of project.
;	$sRoot - IN/OPTIONAL - The root directory containing the $sProject and "install" directories.
; Returns:
;	True if files were copied, false if the source and destination arrays are different sizes.
; ===================================================================
Func _CopyBuildOutput(Const ByRef $aBuildOutput, Const ByRef $aInstallFiles, $sProject, $sRoot = @WorkingDir)
	If UBound($aBuildOutput) <> UBound($aInstallFiles) Then Return False
	Local $ret = True
	For $i = 0 To UBound($aBuildOutput) - 1
		If $aInstallFiles[$i] Then
			If Not _SettingGet($SETTING_BUILDX64, False, True) And StringInStr($aInstallFiles[$i], "x64") Then ContinueLoop
			Local $sDestination = $sRoot & "\install\" & $aInstallFiles[$i]
			Local $sSource = $sRoot & "\bin\" & $aBuildOutput[$i]
			; Test if the common bin directory contains the output file.
			If Not FileExists($sSource) Then $sSource = $sRoot & "\" & $sProject & "\bin\" & $aBuildOutput[$i]
			If FileCopy($sSource, $sDestination, 1) Then ContinueLoop
			$ret = False
		EndIf
	Next
	Return $ret
EndFunc   ;==>_CopyBuildOutput
#EndRegion _CopyBuildOutput()


#Region _BuildOutputResult()
; ===================================================================
; _BuildOutputResult($nReturn, $nError, $nExtended, $vPlatform = $PLATFORM_WIN32)
;
; Outputs a description of a build error.
; Parameters:
;	$nReturn - IN - The return code from _Compile().
;	$nError - IN - The @error value after _Compile() has been called.
;	$nExtended - IN - The @extended value after _Compile() has been called.
;	$vPlatform - IN/OPTIONAL - The platform the build output is for.
; Returns:
;	None.
; ===================================================================
Func _BuildOutputResult($nReturn, $nError, $nExtended, $vPlatform = $PLATFORM_WIN32)
	#forceref $nExtended
	Switch $vPlatform
		Case $PLATFORM_WIN32
			_OutputProgressWrite("Win32 ")
		Case $PLATFORM_X64
			_OutputProgressWrite("x64 ")
		Case Else
			_OutputProgressWrite("Unknown ")
	EndSwitch

	If $nReturn Then
		_OutputProgressWrite("build succeeded.")
	Else
		Switch $nError
			Case 0 ; Build error
				_OutputProgressWrite("build failed: Compilation error, see Build Ouput for details.")
			Case 1 ; Invalid Compiler
				_OutputProgressWrite("build failed: Invalid compiler specified.")
			Case 2 ; Compiler doesn't exist
				_OutputProgressWrite("build failed: Unable to locate compiler.")
		EndSwitch
	EndIf
	; Add the trailing CRLF
	_OutputProgressWrite(@CRLF)
EndFunc   ;==>_BuildOutputResult
#EndRegion _BuildOutputResult()

#Region _BuildDirSet()
; ===================================================================
; _BuildDirSet()
;
; Changes the working directory to the root build directory.
; Parameters:
;	None.
; Returns:
;	None.
; ===================================================================
Func _BuildDirSet()
	FileChangeDir(@ScriptDir)
	FileChangeDir(_SettingGet($SETTING_BUILDDIR))
	Return @WorkingDir
EndFunc   ;==>_BuildDirSet
#EndRegion _BuildDirSet()


#Region _SettingGet()
; ===================================================================
; _SettingGet($vSetting, $vDefault = "", $bNumber = False, $sSection = $g_sSection)
;
; Retrieves a setting.
; Parameters:
;	$vSetting - IN - The name of the setting to obtain.
;	$vDefault - IN/OPTIONAL - The default value to return if the setting can't be found.
;	$bNumber - IN/OPTIONAL - If true, cast the result to a number.
;	$sSection - IN/OPTIONAL - Allows the section to be overriden.
; Returns:
;	Success: The setting optionally cast to a number.
;	Failure: The default value.
; ===================================================================
Func _SettingGet($vSetting, $vDefault = "", $bNumber = False, $sSection = Default, $fRedirected = False)
	; Check the environment first, it overrides.
	Local $vResult = EnvGet("Env" & $vSetting)
	; Nothing in the environment, read the INI file.
	If $sSection = Default Then $sSection = $g_sSection
	If Not $vResult Then $vResult = IniRead(_SettingGetIniFile($fRedirected), $sSection, $vSetting, $vDefault)
	If $bNumber Then Return Number($vResult)
	Return $vResult
EndFunc   ;==>_SettingGet
#EndRegion _SettingGet()

#Region _SettingGetSection()
; ===================================================================
; _SettingGetSection($sSection)
;
; Returns all key, value pairs in a section.
; Parameters:
;	$sSection - IN - The section to return the key, value pairs for.
; Returns:
;	Success - An array of key, value pairs.
;	Failure - An empty string and @error set to non-zero.
; ===================================================================
Func _SettingGetSection($sSection)
	Local $aRet = IniReadSection(_SettingGetIniFile(), $sSection)
	Return SetError(@error, @extended, $aRet)
EndFunc   ;==>_SettingGetSection
#EndRegion _SettingGetSection()

#Region _SettingSet()
; ===================================================================
; _SettingSet($vSetting, $vValue, $sSection = $g_sSection)
;
; Sets a setting.
; Parameters:
;	$vSetting - IN - The name of the setting to set.
;	$vValue - IN - The data to set.
;	$sSection - IN/OPTIONAL - Allows the section to be overriden.
; Returns:
;	None.
; ===================================================================
Func _SettingSet($vSetting, $vValue, $sSection = $g_sSection)
	IniWrite(_SettingGetIniFile(), $sSection, $vSetting, $vValue)
EndFunc   ;==>_SettingSet
#EndRegion _SettingSet()

#Region _SettingSetEnv()
; ===================================================================
; _SettingSetEnv($vSetting, $vValue = "")
;
; Sets a setting in the environment which overrides the INI file.
; Parameters:
;	$vSetting - IN - The name of the setting to set.
;	$vValue - IN/OPTIONAL - IN - The data to set.  If not specified then the environment override
;		will be deleted.
; Returns:
;	None.
; ===================================================================
Func _SettingSetEnv($vSetting, $vValue = "")
	$vSetting = "Env" & $vSetting
	If @NumParams = 1 Then
		EnvSet($vSetting)
	Else
		EnvSet($vSetting, $vValue)
	EndIf
EndFunc   ;==>_SettingSetEnv
#EndRegion _SettingSetEnv()

#Region _SettingGetIniFile()
; ===================================================================
; _SettingGetIniFile()
;
; Returns the path to the configuration file.
; Parameters:
;	None.
; Returns:
;	The path to the configuration file.
; ===================================================================
Func _SettingGetIniFile($fRedirected = False)
	If $fRedirected Then
		Local $sTemp = IniRead($g_sIni, "IniVersion", "RedirectedIni", "")
		If $sTemp Then
			; Config.ini need to be redirected
			If Not FileExists($sTemp) Then
				; use Config.ini located in the trunk\_build
				$sTemp = IniRead($g_sIni, "Build", "BuildDir", "") & "\" & $sTemp
			EndIf
			Return $sTemp
		EndIf
	EndIf

	Return $g_sIni
EndFunc   ;==>_SettingGetIniFile
#EndRegion _SettingGetIniFile()

#Region _Sign()
; ===================================================================
; _Sign($sFile, $sDesc)
;
; Signs the specified with a hard-coded certificate.
; Parameters:
;	$sFile - IN - The file to sign.
;	$sDesc - IN - The description of the file.
; Returns:
;	Success - 0.
;	Failure - 1.
; ===================================================================
Func _Sign($sFile, $sDesc)
	If Not FileExists($sFile) Then Return 1

	Local $pfx = "_build\External\authenticode\AutoIt_Consulting_Ltd.pfx"
	Local $pfxPassword = _SettingGet($SETTING_PFXPASSWORD, "")
	Local $timeStampURL = "http://timestamp.globalsign.com/scripts/timstamp.dll"

	Local $cmdLine = "_build\External\authenticode\signtool.exe"
	$cmdLine &= " sign /t " & $timeStampURL
	$cmdLine &= " /f """ & $pfx & """"
	$cmdLine &= " /p """ & $pfxPassword & """"
	$cmdLine &= " /d """ & $sDesc & """"
	$cmdLine &= " /du ""http://www.autoitscript.com/autoit3/"""
	$cmdLine &= " /q """ & $sFile & """"

	Return RunWait($cmdLine, "", @SW_HIDE)
EndFunc   ;==>_Sign
#EndRegion _Sign()

#Region _ArchiveDir()
; ===================================================================
; _ArchiveDir($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
;
; Archives files.
; Parameters:
;	$sDir - IN - name of the directory
;	$sArchiveName - IN - name of the archive
;	$aExcludes - IN/OPTIONAL - files and folders to exclude. Paths must be acceptable to both 7zip/winrar
;	$bSFX - IN/OPTIONAL - If true an SFX archive is created.
;	$bZip - IN/OPTIONAL - If true an ZIP archive is created.
; Returns:
;	Success - Returns 0.
;	Failure - Returns 1.
; ===================================================================
Func _ArchiveDir($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
	_OutputProgressWrite('Archiving "' & $sDir & '" directory to ' & $sArchiveName)
	Local $nReturn

	; 7Zip returns 0 on success
	If Not _7Zip($sDir, $sArchiveName, $aExcludes, $bSFX, $bZip) Then
		_OutputProgressWrite(" succeeded." & @CRLF)
		$nReturn = 0
	Else
		; WinRAR returns 0 on success
		If Not _WinRAR($sDir, $sArchiveName, $aExcludes, $bSFX, $bZip) Then
			_OutputProgressWrite(" succeeded." & @CRLF)
			$nReturn = 0
		Else
			_OutputProgressWrite(" failed." & @CRLF)
			$nReturn = 1
		EndIf
	EndIf
	Return $nReturn
EndFunc   ;==>_ArchiveDir
#EndRegion _ArchiveDir()

#Region _WinRAR()
; ===================================================================
; _WinRAR($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
;
; Runs WinRAR with the specified command.
; Parameters:
;	$sDir - IN - name of the directory
;	$sArchiveName - IN - name of the archive
;	$aExcludes - IN/OPTIONAL - Files and folders to exclude.  Paths must be acceptable to both 7zip/winrar
;	$bSFX - IN/OPTIONAL - If true an SFX archive is created.
;	$bZip - IN/OPTIONAL - If true an ZIP archive is created.
; Returns:
;	Success - Returns 0.
;	Failure - Returns 1.
; ===================================================================
Func _WinRAR($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
	; First we try the logical location.
	Local $sWinRAR = @ProgramFilesDir & "\WinRAR\winrar.exe"
	; If it's still not found, try forcing the path in case @ProgramDirs = Program Files (x86)
	If Not FileExists($sWinRAR) Then
		$sWinRAR = StringLeft(@ProgramFilesDir, 2) & "\Program Files\WinRAR\winrar.exe"
	EndIf
	; If we don't find it in the logical location, look in App Paths.
	If Not FileExists($sWinRAR) Then
		$sWinRAR = _RegRead64("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe", "")
	EndIf
	; If we can't find it in App Paths, look for the uninstall key and build the path from that.
	If Not FileExists($sWinRAR) Then
		$sWinRAR = _RegRead64("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver", "UninstallString")
		$sWinRAR = StringReplace($sWinRAR, "\uninstall.exe", "\winrar.exe")
	EndIf
	; If it's still not found, give up.
	If Not FileExists($sWinRAR) Then Return SetError(1, 0, -1)

	; Build the command string.
	Local $sCmd = "a -ibck -m5 -s "

	; If using SFX then add the flag.
	If $bSFX Then
		$sCmd &= "-sfx "
		$sArchiveName &= ".exe"
	Else
		If $bZip Then
			$sCmd &= "-afzip "
			$sArchiveName &= ".zip"
		Else
			$sArchiveName &= ".rar"
		EndIf
	EndIf

	; Delete any archive with this name
	FileDelete($sArchiveName)

	; Add the excludes
	If IsArray($aExcludes) Then
		For $sExclude In $aExcludes
			$sCmd &= "-x" & $sExclude & " "
		Next
	EndIf

	; Add the rest of the command string.
	$sCmd &= $sArchiveName & " " & $sDir

	Return RunWait('"' & $sWinRAR & '" ' & $sCmd)
EndFunc   ;==>_WinRAR
#EndRegion _WinRAR()

#Region _7Zip()
; ===================================================================
; _7Zip($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
;
; Runs WinRAR with the specified command.
; Parameters:
;	$sDir - IN - name of the directory
;	$sArchiveName - IN - name of the archive
;	$aExcludes - IN/OPTIONAL - Files and folders to exclude.  Paths must be acceptable to both 7zip/winrar
;	$bSFX - IN/OPTIONAL - If true an SFX archive is created.
;	$bZip - IN/OPTIONAL - If true a ZIP archive is created.
; Returns:
;	Success - Returns 0.
;	Failure - Returns 1.
; ===================================================================
Func _7Zip($sDir, $sArchiveName, $aExcludes = "", $bSFX = True, $bZip = False)
	; First we try the logical location.
	Local $s7Zip = @ProgramFilesDir & "\7-Zip\7z.exe"
	; If it's still not found, try forcing the path in case @ProgramDirs = Program Files (x86)
	If Not FileExists($s7Zip) Then
		$s7Zip = StringLeft(@ProgramFilesDir, 2) & "\Program Files\7-Zip\7z.exe"
	EndIf
	; If it's still not found, give up.
	If Not FileExists($s7Zip) Then Return SetError(1, 0, -1)

	; Build the command string.
	Local $sCmd = "a "
	If $bZip Then
;~ 		$sCmd &= "-tzip -m={LZMA} -mx=9 -mmt=on "
		$sCmd &= "-tzip -mx=9 -mmt=on "
	Else
		$sCmd &= "-t7z -m0=LZMA -mx=9 -ms=on -mmt=on "
	EndIf

	; If using SFX then add the flag.
	If $bSFX Then
		$sCmd &= "-sfx7z.sfx "
		$sArchiveName &= ".exe"
	Else
		If $bZip Then
			$sArchiveName &= ".zip"
		Else
			$sArchiveName &= ".7z"
		EndIf
	EndIf

	; Delete any archive with this name
	FileDelete($sArchiveName)

	; Archive name and Directory to archive
	; Also have to only enable recursion for wildcards (-r0) or it doesn't exclude properly
	; If we enable normal recursion (-r) then it seems to also archive random things from the parent
	; folder. Mental.
	$sCmd &= $sArchiveName & " -r0 " & $sDir

	; Add the excludes
	If IsArray($aExcludes) Then
		For $sExclude In $aExcludes
			$sCmd &= " -x!" & $sExclude
		Next
	EndIf

	; Add the rest of the command string.
	Return RunWait('"' & $s7Zip & '" ' & $sCmd, @WorkingDir, @SW_HIDE)
EndFunc   ;==>_7Zip
#EndRegion _7Zip()

#Region _CompilerProcess()
; ===================================================================
; _CompilerProcess($vCompiler)
;
; Returns the name of the process for the specified compiler.
; Parameters:
;	$vCompiler - IN - One of the $COMPILER_* flags.
; Returns:
;	The process name of the specified compiler.
; ===================================================================
Func _CompilerProcess($vCompiler)
	Return __CompilerGetAttribute($vCompiler, $COMPILER_BINARY)
EndFunc   ;==>_CompilerProcess
#EndRegion _CompilerProcess()

#Region _CompilerFullName()
; ===================================================================
; _CompilerFullName($vCompiler)
;
; Returns the name of a string in a human recognizable form.
; Parameters:
;	$vCompiler - IN - The compiler to get the name of.
; Returns:
;	The name of the specified compiler.
; ===================================================================
Func _CompilerFullName($vCompiler)
	Return __CompilerGetAttribute($vCompiler, $COMPILER_FULLNAME)
EndFunc   ;==>_CompilerFullName
#EndRegion _CompilerFullName()

#Region _CompilerGetProjectSuffix()
; ===================================================================
; _CompilerGetProjectSuffix($vCompiler)
;
; Returns the project suffix for the specified compiler.
; Parameters:
;	$vCompiler - IN - The compiler to retrive the project suffix for.
; Returns:
;	Success - The project suffix.
;	Failure - An empty string.
; ===================================================================
Func _CompilerGetProjectSuffix($vCompiler)
	Return __CompilerGetAttribute($vCompiler, $COMPILER_PROJECTSUFFIX)
EndFunc   ;==>_CompilerGetProjectSuffix
#EndRegion _CompilerGetProjectSuffix()

#Region _CompilerGetSolutionDir()
; ===================================================================
; _CompilerGetSolutionDir($vCompiler)
;
; Returns the solution directory for the specified compiler.
; Parameters:
;	$vCompiler - IN - The compiler to retrieve the solution directory for.
; Returns:
;	Success - The solution directory.
;	Failure - An empty string.
; ===================================================================
Func _CompilerGetSolutionDir($vCompiler)
	Return __CompilerGetAttribute($vCompiler, $COMPILER_SOLUTIONDIR)
EndFunc   ;==>_CompilerGetSolutionDir
#EndRegion _CompilerGetSolutionDir()

#Region _PlatformName()
; ===================================================================
; _PlatformName($vPlatform)
;
; Returns the name of the specified platform.
; Parameters:
;	$vPlatform - IN - One of the $PLATFORM_* flags.
; Returns:
;	The name of the platform.
; ===================================================================
Func _PlatformName($vPlatform)
	Return $vPlatform
EndFunc   ;==>_PlatformName
#EndRegion _PlatformName()

#Region _ConfigurationName()
; ===================================================================
; _ConfigurationName($vConfiguration)
;
; Returns the name of the specified configuration.
; Parameters:
;	$vConfiguration - IN - One of the $CONFIGURATION_* flags.
; Returns:
;	The name of the configuration.
; ===================================================================
Func _ConfigurationName($vConfiguration)
	Return $vConfiguration
EndFunc   ;==>_ConfigurationName
#EndRegion _ConfigurationName()

#Region _ReleaseName()
; ===================================================================
; _ReleaseName($vConfiguration, $vPlatform)
;
; Returns the composited release name.
; Parameters:
;	$vConfiguration - IN - One of the $CONFIGURATION_* flags.
;	$vPlatform - IN - One of the $PLATFORM_* flags.
; Returns:
;	The composited release name.
; ===================================================================
Func _ReleaseName($vConfiguration, $vPlatform)
	Return _ConfigurationName($vConfiguration) & '|' & _PlatformName($vPlatform)
EndFunc   ;==>_ReleaseName
#EndRegion _ReleaseName()

#Region _RegRead64()
; ===================================================================
; _RegRead64($sKeyname, $sValue)
;
; Returns the registry value
; Parameters:
;	$sKeyname - IN - The registry keyname.
;	$sValue - IN - The registry value.
; Returns:
;	The registry value.
; ===================================================================
Func _RegRead64($sKeyname, $sValue)
	Local $res = RegRead($sKeyname, $sValue)
	If @error And @AutoItX64 Then
		$sKeyname = StringReplace($sKeyname, "HKEY_LOCAL_MACHINE", "HKLM")
		$sKeyname = StringReplace($sKeyname, "HKLM\SOFTWARE\", "HKLM\SOFTWARE\Wow6432Node\")
		$res = RegRead($sKeyname, $sValue)
		If @error Then
			SetError(1)
			Return ""
		EndIf
	EndIf

	SetError(0)
	Return $res
EndFunc   ;==>_RegRead64
#EndRegion _RegRead64()

#EndRegion Public Members

#Region Private Members

#Region __CompilerGetAttribute()
; ===================================================================
; __CompilerGetAttribute($vCompiler, $iAttribute)
;
; Retrieves the specified compiler attribute.
; Parameters:
;	$vCompiler - IN - One of the $COMPILER_ constants identifying a compiler.
;	$iAttribute - IN - One of the $COMPILER_constants identifying an attribute.
; Returns:
;	Success - The specified compiler attribute.
;	Failure - Sets @error to non-zero, returns an empty string.
; ===================================================================
Func __CompilerGetAttribute($vCompiler, $iAttribute)
	If $iAttribute >= 0 And $iAttribute < $COMPILER_MAX Then
		For $i = 0 To UBound($g_aCompilerMap) - 1
			If $g_aCompilerMap[$i][$COMPILER_NAME] = $vCompiler Then Return $g_aCompilerMap[$i][$iAttribute]
		Next
	EndIf
	Return SetError(1, 0, "")
EndFunc   ;==>__CompilerGetAttribute
#EndRegion __CompilerGetAttribute()

#EndRegion Private Members
