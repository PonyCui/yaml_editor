import 'package:yaml/yaml.dart';
import 'package:to_yaml/to_yaml.dart';
import 'package:yaml_editor/yaml_option_type.dart';

export './yaml_editor_widget.dart';
export './yaml_option_type.dart';

class YAMLEditorController {
  dynamic obj;
  Map<String, YAMLOptionType> optionsTypes;

  YAMLEditorController(String source, {this.optionsTypes}) {
    this.obj = transformToDartObject(loadYaml(source));
  }

  getSource() {
    if (this.obj is Map) {
      return (this.obj as Map).toYaml();
    } else if (this.obj is List) {
      return (this.obj as List).toYaml();
    } else {
      return this.obj;
    }
  }

  transformToDartObject(dynamic yamlObject) {
    if (yamlObject is YamlMap) {
      return yamlObject.value
          .map((key, value) => MapEntry(key, transformToDartObject(value)));
    } else if (yamlObject is YamlList) {
      return yamlObject.value.map((e) => transformToDartObject(e)).toList();
    } else {
      return yamlObject;
    }
  }
}
