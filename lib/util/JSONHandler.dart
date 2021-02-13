import 'dart:convert';
import 'dart:io';

import 'package:coding_challenge/util/JSONInput.dart';
import 'package:flutter/material.dart';

import 'JSONCandidate.dart';
import 'JSONState.dart';

class JSONHandler {
  BuildContext buildContext;
  String responseBodyCandidate = "";

  JSONHandler(BuildContext buildContext) {
    this.buildContext = buildContext;
  }

  List<JSONState> _parseStates(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<JSONState>((json) => JSONState.fromJson(json)).toList();
  }

  List<JSONCandidate> _parseCandidates(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<JSONCandidate>((json) => JSONCandidate.fromJson(json))
        .toList();
  }

  Future<String> awaitedString(String path) async {
    File file = File(path);
    return file.readAsString();
  }

  Future<List<JSONState>> fetchStates(JSONInput stateInput) async {
    if (stateInput.filePathType == FilePathType.TYPE_ASSET) {
      final responseBody = await DefaultAssetBundle.of(buildContext)
          .loadString(stateInput.filePath);
      return _parseStates(responseBody);
    } else {
      final responseBody = await awaitedString(stateInput.filePath);
      return _parseStates(responseBody);
    }
  }

  Future<List<JSONCandidate>> fetchCandidates(JSONInput candidatesInput) async {
    if (candidatesInput.filePathType == FilePathType.TYPE_ASSET) {
      final responseBody = await DefaultAssetBundle.of(buildContext)
          .loadString(candidatesInput.filePath);
      return _parseCandidates(responseBody);
    } else {
      final responseBody = await awaitedString(candidatesInput.filePath);
      return _parseCandidates(responseBody);
    }
  }
}
