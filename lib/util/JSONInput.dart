import 'package:flutter/cupertino.dart';

class JSONInput {
  String filePath = "";
  FilePathType filePathType;

  JSONInput({@required this.filePathType, @required this.filePath});
}

enum FilePathType { TYPE_ASSET, TYPE_LOADED }
