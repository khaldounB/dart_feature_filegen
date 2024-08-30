import 'package:dart_feature_filegen/dart_feature_filegen.dart';

void main(List<String> arguments) async {
  if (arguments.length < 1) {
    print('Usage: dart run dart_feature_filegen <feature_name>');
    return;
  }

  final featureName = arguments[0];
  await generateFeature(featureName);
}
