import 'dart:io';

/// Generates the folder and file structure for a given feature in a Flutter project.
///
/// This function creates directories and files with initial boilerplate code
/// for a specified feature name.
Future<void> generateFeature(String featureName) async {
  final featurePath = 'lib/features/$featureName';

  // Define the folder structure
  final directories = [
    '$featurePath/data/models',
    '$featurePath/data/requests',
    '$featurePath/ui/screens',
    '$featurePath/ui/widgets',
    '$featurePath/providers',
    '$featurePath/web_services',
    '$featurePath/repo',
  ];

  // Define the initial files and their contents
  final files = {
    '$featurePath/providers/${featureName}_provider.dart': '''
import 'package:flutter/material.dart';

class ${_capitalize(featureName)}Provider extends ChangeNotifier {}
''',
    '$featurePath/web_services/${featureName}_web_services.dart': '''
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import '../../../core/constants/server/end_points.dart';
import '../../../core/utils/base_model/base_model.dart';
import 'package:retrofit/http.dart';

part '${featureName}_web_services.g.dart';

@RestApi(baseUrl: EndPoints.host)
abstract class ${_capitalize(featureName)}WebServices {
  factory ${_capitalize(featureName)}WebServices(Dio dio) = _${_capitalize(featureName)}WebServices;
}
''',
    '$featurePath/repo/${featureName}_repo.dart': '''
import '../web_services/${featureName}_web_services.dart';

class ${_capitalize(featureName)}Repo {
  static final ${_capitalize(featureName)}Repo _${featureName}Repo = ${_capitalize(featureName)}Repo._internal();

  factory ${_capitalize(featureName)}Repo() {
    return _${featureName}Repo;
  }

  ${_capitalize(featureName)}Repo._internal();

  // Add methods to interact with the web services
}
''',
    '$featurePath/ui/screens/${featureName}_screen.dart': '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/${featureName}_provider.dart';

class ${_capitalize(featureName)}Screen extends StatelessWidget {
  const ${_capitalize(featureName)}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<${_capitalize(featureName)}Provider>(
      create: (context) => ${_capitalize(featureName)}Provider(),
      child: Scaffold(),
    );
  }
}
'''
  };

  // Create directories
  for (var dir in directories) {
    final directory = Directory(dir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      print('Created directory: $dir');
    } else {
      print('Directory already exists: $dir');
    }
  }

  // Create files with initial content
  for (var filePath in files.keys) {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.writeAsString(files[filePath]!);
      print('Created file: $filePath');
    } else {
      print('File already exists: $filePath');
    }
  }

  await _runBuildRunner();

  print('Feature "$featureName" structure created successfully.');
}

/// Capitalizes the first letter of the given string [input].
String _capitalize(String input) {
  return input[0].toUpperCase() + input.substring(1);
}

/// Runs the build_runner tool to generate the .g.dart file for JSON serialization.
///
/// This method runs the `build_runner` command, which is necessary to generate
/// the part file containing the `fromJson` and `toJson` methods.
Future<void> _runBuildRunner() async {
  const String green = '\x1B[32m';
  const String resetColor = '\x1B[0m';
  const String red = '\x1B[31m';

  print('${resetColor}Running build_runner to generate .g.dart file...');
  final result = await Process.run(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    workingDirectory: Directory.current.path,
  );

  if (result.exitCode == 0) {
    print('${green}build_runner completed successfully.${resetColor}');
  } else {
    print('${red}build_runner failed with exit code ${result.exitCode}');
    print(result.stderr);
  }
}
