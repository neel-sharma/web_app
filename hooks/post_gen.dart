import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final appName = context.vars['appName'].toString().snakeCase;
  final appDirectory = Directory('${Directory.current.path}/$appName');

  // Create the Flutter project in the specified directory
  await _runCommand('flutter create .', appDirectory);

  // Add dependencies
  await _runCommand('flutter pub add flutter_inappwebview', appDirectory);
  await _runCommand('flutter pub add lottie', appDirectory);

  final bool setupLauncherIconAndSplash = context.vars['setupLauncherIconAndSplash'].toString() == 'true';
  if (setupLauncherIconAndSplash) {
    await _runCommand('flutter pub add flutter_native_splash', appDirectory);
    await _runCommand('flutter pub add icons_launcher', appDirectory);

    final assetsDirectory = Directory('${appDirectory.path}/assets');
    final imagePath = await _pickImage();
    if (imagePath != null) {
      final fileName = 'logo.png';
      final newFilePath = '${assetsDirectory.path}/$fileName';
      File(imagePath).copySync(newFilePath);

      await _runCommand('dart run flutter_native_splash:create', appDirectory);
      await _runCommand('dart run icons_launcher:create', appDirectory);
    }
  }

  final bool enableRemoteConfig = context.vars['enableRemoteConfig'].toString() == 'true';
  if (enableRemoteConfig) {
    await _runCommand('flutter pub add firebase_core', appDirectory);
    await _runCommand('flutter pub add firebase_remote_config', appDirectory);
  }

  // Get dependencies
  await _runCommand('flutter pub get', appDirectory);
}

Future<void> _runCommand(String command, Directory workingDirectory) async {
  // Detect the operating system
  final isWindows = Platform.isWindows;
  final shell = isWindows ? 'cmd' : 'bash';
  final args = isWindows ? ['/C', command] : ['-c', command];

  final result = await Process.run(shell, args, workingDirectory: workingDirectory.path);

  if (result.exitCode != 0) {
    print('Command failed: $command');
    print('Error: ${result.stderr}');
  } else {
    print('Command succeeded: $command');
    print('Output: ${result.stdout}');
  }
}

Future<String?> _pickImage() async {
  if (Platform.isWindows) {
    print('Running on Windows: attempting to open file picker...');
    // PowerShell script to open file dialog and return the selected file path
    final result = await Process.run(
        'powershell',
        [
          '-Command',
          r'''
        Add-Type -AssemblyName System.Windows.Forms;
        $dlg = New-Object System.Windows.Forms.OpenFileDialog;
        $dlg.Filter = 'PNG files (*.png)|*.png';
        $dlg.InitialDirectory = [System.Environment]::GetFolderPath('Desktop');
        if ($dlg.ShowDialog() -eq 'OK') { $dlg.FileName }
        '''
        ]
    );

    // Log the exit code and output
    print('Exit code: ${result.exitCode}');
    if (result.exitCode == 0) {
      print('File picker output: ${result.stdout.trim()}');
      return result.stdout.trim();
    } else {
      print('Error output: ${result.stderr}');
    }
  } else if (Platform.isMacOS || Platform.isLinux) {
    print('Running on macOS/Linux: attempting to open file picker...');
    // Use zenity for macOS/Linux to open file selection dialog
    final result = await Process.run('zenity', ['--file-selection', '--file-filter=*.png']);

    // Log the exit code and output
    print('Exit code: ${result.exitCode}');
    if (result.exitCode == 0) {
      print('File picker output: ${result.stdout.trim()}');
      return result.stdout.trim();
    } else {
      print('Error output: ${result.stderr}');
    }
  } else {
    print('Unsupported platform');
  }
  return null;  // Unsupported platform or failure
}

