import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberPickerUI extends StatefulWidget {
  Function(int) callback;
  Function(String) buttonCallback;
  NumberPickerUI({@required this.callback, @required this.buttonCallback});
  @override
  _NumberPickerUIState createState() => _NumberPickerUIState();
}

class _NumberPickerUIState extends State<NumberPickerUI> {
  TextEditingController textController = new TextEditingController();

  void initState() {
    super.initState();
    textController.text = "100";
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          widget.callback(int.parse(value));
        },
        decoration: new InputDecoration(
          labelText: "Number of simulations to run",
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue)),
        ),
        onSubmitted: widget.buttonCallback,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
