import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBarUI extends StatefulWidget {
  Function(int) callback;
  Function(String) buttonCallback;
  SearchBarUI({@required this.callback, @required this.buttonCallback});
  @override
  _SearchBarUIState createState() => _SearchBarUIState();
}

class _SearchBarUIState extends State<SearchBarUI> {
  TextEditingController textController = new TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width - 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: TextField(
          decoration: new InputDecoration(hintText: "Jump to simulation #"),
          controller: textController,
          onChanged: (value) {
            widget.callback(int.parse(value));
          },
          onSubmitted: widget.buttonCallback,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ),
    );
  }
}
