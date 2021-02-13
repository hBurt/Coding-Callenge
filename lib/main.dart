import 'file:///C:/Users/Harrison/AndroidStudioProjects/coding_challenge/lib/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(CodingChallenge());

class CodingChallenge extends StatefulWidget {
  @override
  _CodingChallengeState createState() => _CodingChallengeState();
}

class _CodingChallengeState extends State<CodingChallenge> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
