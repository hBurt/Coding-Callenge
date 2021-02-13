import 'package:coding_challenge/ui/FilePickerUI.dart';
import 'package:coding_challenge/ui/NumberPickerUI.dart';
import 'package:coding_challenge/util/JSONInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Results.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String stateFilePath = "assets/json/states-1.json";
  final String candidatesFilePath = "assets/json/candidates-1.json";

  String stateCallback;
  String candidatesCallback;

  bool candidateCheckbox = true;
  bool stateCheckbox = true;

  int runs = 10;

  FilePickerUI filePickerUICandidate;
  FilePickerUI filePickerUIState;

  _startSimulation([String index]) {
    int simulationCount = index == null ? runs : int.parse(index);

    FilePathType candidateInputType;
    FilePathType stateInputType;

    if (candidateCheckbox) {
      candidateInputType = FilePathType.TYPE_ASSET;
      setState(() {
        candidatesCallback = candidatesFilePath;
      });
    } else {
      candidateInputType = FilePathType.TYPE_LOADED;
      setState(() {
        candidatesCallback = filePickerUICandidate.labelTextField;
      });
    }

    if (stateCheckbox) {
      stateInputType = FilePathType.TYPE_ASSET;
      setState(() {
        stateCallback = stateFilePath;
      });
    } else {
      stateInputType = FilePathType.TYPE_LOADED;
      setState(() {
        stateCallback = filePickerUIState.labelTextField;
      });
    }

    if (simulationCount == null || simulationCount == 0) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Warning'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Number of simulations must be greater than 0'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
          barrierDismissible: false);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Results(
                    stateFilePath: new JSONInput(
                        filePathType: stateInputType, filePath: stateCallback),
                    candidatesInput: new JSONInput(
                        filePathType: candidateInputType,
                        filePath: candidatesCallback),
                    runs: simulationCount,
                  )));
    }
  }

  void initState() {
    super.initState();
    stateCallback = stateFilePath;
    candidatesCallback = candidatesFilePath;

    filePickerUICandidate = new FilePickerUI(
      labelTextCheckbox: "Use prepackaged candidates file",
      labelTextField: "Path to candidates file",
      prepackagedJSONLocation: candidatesFilePath,
      callback: (string, boolVal) => setState(() {
        candidatesCallback = string;
        candidateCheckbox = boolVal;
      }),
    );

    filePickerUIState = new FilePickerUI(
      labelTextCheckbox: "Use prepackaged states file",
      labelTextField: "Path to states file",
      prepackagedJSONLocation: stateFilePath,
      callback: (string, boolVal) => setState(() {
        stateCallback = string;
        stateCheckbox = boolVal;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Election Simulation',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Election Simulation'),
            ),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  filePickerUIState,
                  filePickerUICandidate,
                  NumberPickerUI(
                    callback: (value) {
                      setState(() {
                        runs = value != null ? value : 0;
                      });
                    },
                    buttonCallback: (value) => _startSimulation(value),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: _startSimulation,
                          child: Text("Start simulation")))
                ],
              ),
            ))));
  }
}
