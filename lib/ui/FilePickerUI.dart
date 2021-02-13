import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerUI extends StatefulWidget {
  @override
  _FilePickerUIState createState() => _FilePickerUIState();

  final String labelTextCheckbox;
  String labelTextField;
  final String prepackagedJSONLocation;
  void Function(String, bool) callback;

  FilePickerUI(
      {@required this.labelTextCheckbox,
      @required this.labelTextField,
      @required this.callback,
      @required this.prepackagedJSONLocation});
}

class _FilePickerUIState extends State<FilePickerUI> {
  bool checkBoxValue = true;
  String filePath = "Choose File";

  String getPathName() {
    return filePath;
  }

  void _onValueChange(bool _val) => setState(() {
        checkBoxValue = _val;

        if (checkBoxValue) {
          widget.callback(widget.prepackagedJSONLocation, checkBoxValue);
        } else {
          widget.callback(filePath, checkBoxValue);
        }
      });

  void _passToString(String pathName) {
    setState(() {
      widget.labelTextField = pathName;
      filePath = pathName;
    });
  }

  Future<void> _getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      _passToString(file.path);
    } else {
      print("Not using selected file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: [
          CheckboxListTile(
              title: Text(widget.labelTextCheckbox),
              value: checkBoxValue,
              onChanged: _onValueChange,
              controlAffinity: ListTileControlAffinity.leading),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: checkBoxValue ? null : _getFile,
                  child: Text(getPathName())))
        ],
      ),
    );
  }
}
