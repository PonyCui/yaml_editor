import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yaml_editor/yaml_editor.dart';

class YAMLEditorWidget extends StatefulWidget {
  final YAMLEditorController controller;

  YAMLEditorWidget({this.controller});

  @override
  _YAMLEditorWidgetState createState() => _YAMLEditorWidgetState();
}

class _YAMLEditorWidgetState extends State<YAMLEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 12, right: 12),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        _FactoryEditor(
          data: widget.controller.obj,
          indent: 0,
          controller: widget.controller,
        )
      ],
    );
  }
}

class _FactoryEditor extends StatelessWidget {
  final YAMLEditorController controller;
  final dynamic data;
  final String dataKey;
  final int indent;

  _FactoryEditor({this.data, this.dataKey, this.indent, this.controller});

  @override
  Widget build(BuildContext context) {
    if (this.data is Map) {
      return _MapEditor(data: data, indent: indent, controller: controller);
    } else if (this.data is List) {
      return _ListEditor(
          data: data, dataKey: dataKey, indent: indent, controller: controller);
    }
    return Container();
  }
}

class _MapEditor extends StatefulWidget {
  final YAMLEditorController controller;
  final Map data;
  final int indent;

  _MapEditor({this.data, this.indent, this.controller});

  @override
  __MapEditorState createState() => __MapEditorState();
}

class __MapEditorState extends State<_MapEditor> {
  Widget _renderEntry(MapEntry entry) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: this.widget.indent * 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                entry.key,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                " : ",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Expanded(
                child: (() {
                  if (!(entry.value is int ||
                      entry.value is String ||
                      entry.value is bool ||
                      entry.value is double ||
                      entry.value == null)) {
                    return Container(height: 44);
                  } else if (widget.controller.optionsTypes[entry.key] !=
                      null) {
                    return Container(
                      height: 44,
                      child: Row(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return widget
                                  .controller.optionsTypes[entry.key].options
                                  .map((e) =>
                                      PopupMenuItem(child: Text(e), value: e))
                                  .toList();
                            },
                            child: Text(
                              entry.value,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            onSelected: (value) {
                              setState(() {
                                widget.data[entry.key] = value;
                              });
                            },
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    );
                  } else {
                    return TextField(
                      controller: TextEditingController(text: '${entry.value}'),
                      onChanged: (value) {
                        widget.data[entry.key] = value;
                      },
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  }
                })(),
              ),
            ],
          ),
        ),
        (() {
          if (!(entry.value is int ||
              entry.value is String ||
              entry.value is bool ||
              entry.value is double ||
              entry.value == null)) {
            return _FactoryEditor(
              data: entry.value,
              dataKey: entry.key,
              indent: widget.indent + 1,
              controller: widget.controller,
            );
          } else {
            return Container();
          }
        })(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.entries.map((e) => _renderEntry(e)).toList(),
    );
  }
}

class _ListEditor extends StatefulWidget {
  final YAMLEditorController controller;
  final List data;
  final String dataKey;
  final int indent;

  _ListEditor({this.data, this.dataKey, this.indent, this.controller});

  @override
  __ListEditorState createState() => __ListEditorState();
}

class __ListEditorState extends State<_ListEditor> {
  Widget _renderEntry(int index, dynamic value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: this.widget.indent * 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "- ",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Expanded(
                child: (() {
                  if (!(value is int ||
                      value is String ||
                      value is bool ||
                      value is double ||
                      value == null)) {
                    return Container(height: 44);
                  } else if (widget.controller.optionsTypes[widget.dataKey] !=
                      null) {
                    return Container(
                      height: 44,
                      child: Row(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return widget.controller
                                  .optionsTypes[widget.dataKey].options
                                  .map((e) =>
                                      PopupMenuItem(child: Text(e), value: e))
                                  .toList();
                            },
                            child: Text(
                              value,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            onSelected: (value) {
                              setState(() {
                                widget.data[index] = value;
                              });
                            },
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    );
                  } else {
                    return TextField(
                      controller: TextEditingController(text: '$value'),
                      onChanged: (value) {
                        widget.data[index] = value;
                      },
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  }
                })(),
              ),
            ],
          ),
        ),
        (() {
          if (!(value is int ||
              value is String ||
              value is bool ||
              value is double ||
              value == null)) {
            return _FactoryEditor(
              data: value,
              indent: widget.indent + 1,
              controller: widget.controller,
            );
          } else {
            return Container();
          }
        })(),
      ],
    );
  }

  _renderAddButton() {
    return Container(
      padding: EdgeInsets.only(left: max(0, this.widget.indent * 22.0 - 8.0)),
      alignment: Alignment.centerLeft,
      child: MaterialButton(
        onPressed: () {
          setState(() {
            final str = json.encode(widget.data.last);
            widget.data.add(json.decode(str));
          });
        },
        minWidth: 0,
        height: 44,
        child: Icon(Icons.add_circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.data
            .asMap()
            .map((index, e) => MapEntry(index, _renderEntry(index, e)))
            .values
            .toList()
              ..add(_renderAddButton()));
  }
}
