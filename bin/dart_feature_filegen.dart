import 'package:dart_feature_filegen/dart_feature_filegen.dart';

void main(List<String> arguments) async {
  if (arguments.length < 2) {
    print('Usage: dart run dart_feature_filegen <app> <feature_name>');
    return;
  }

  final app = arguments[0];
  final featureName = arguments[1];
  await generateFeature(featureName,app);
}
