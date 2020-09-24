import 'package:flutter/material.dart';
import 'package:yaml_editor/yaml_editor.dart';

const sample = """
name: example
description: A new Flutter project.
关联内容: 品牌
关联内容数组: 
  - 品牌
git:
  url: httt
  ref: sdfsdf
arr:
  - 1
  - 2
  - 3
""";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  YAMLEditorController editorController;

  @override
  void initState() {
    super.initState();
    editorController = YAMLEditorController(sample, optionsTypes: {
      '关联内容': YAMLOptionType(key: '关联内容', options: ['话题', '品牌', '商品']),
      '关联内容数组': YAMLOptionType(key: '关联内容数组', options: ['话题', '品牌', '商品'])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YAML Editor"),
        actions: [
          MaterialButton(
            onPressed: () {
              print(editorController.getSource());
            },
            child: Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
      body: YAMLEditorWidget(controller: editorController),
    );
  }
}
