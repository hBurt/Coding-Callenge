import 'dart:math';

import 'package:coding_challenge/ui/SearchBarUI.dart';
import 'package:coding_challenge/util/Election.dart';
import 'package:coding_challenge/util/JSONCandidate.dart';
import 'package:coding_challenge/util/JSONHandler.dart';
import 'package:coding_challenge/util/JSONInput.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:coding_challenge/util/JSONState.dart';
import 'package:flutter/painting.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();

  JSONInput stateFilePath;
  JSONInput candidatesInput;
  int runs;

  Future<List<List<JSONCandidate>>> futureCandidates;

  Results(
      {@required this.stateFilePath,
      @required this.candidatesInput,
      @required this.runs});
}

class _ResultsState extends State<Results> {
  List<JSONState> states;
  List<JSONCandidate> candidates;
  JSONHandler jsonHandler;
  Future<List<List<Election>>> data;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int simulationToJumpTo = 0;

  Future<List<List<Election>>> _calculateResults() async {
    Random _r = new Random();
    List<List<Election>> elections = new List<List<Election>>();

    //Number of simulations
    for (int i = 0; i < widget.runs; i++) {
      JSONCandidate _candidateFirst = candidates.elementAt(0);
      JSONCandidate _candidateSecond = candidates.elementAt(1);

      SimpleCandidate _simpleCandidateFirst =
          new SimpleCandidate(_candidateFirst.name);
      SimpleCandidate _simpleCandidateSecond =
          new SimpleCandidate(_candidateSecond.name);

      List<Election> innerElections = new List<Election>();

      //Simulate state election
      for (int i = 0;
          i < _candidateFirst.jsonCandidateStateChance.length;
          i++) {
        Election currentElection = new Election();

        //get candidate chance
        int a = _candidateFirst.jsonCandidateStateChance.elementAt(i).chance;
        int b = _candidateSecond.jsonCandidateStateChance.elementAt(i).chance;

        //update simple candidate chance
        _simpleCandidateFirst.chanceOfWinning.add(a);
        _simpleCandidateSecond.chanceOfWinning.add(b);

        //determine win/loss
        double probabilityLoss = b / (a + b);
        bool didCandidateWin = _r.nextDouble() > probabilityLoss;

        if (didCandidateWin) {
          _simpleCandidateFirst.totalVotes += states
              .elementAt(
                  _candidateFirst.jsonCandidateStateChance.elementAt(i).stateId)
              .votes;
          currentElection.setCandidateWinner = _simpleCandidateFirst;
          currentElection.setCandidateLooser = _simpleCandidateSecond;
        } else {
          _simpleCandidateSecond.totalVotes += states
              .elementAt(_candidateSecond.jsonCandidateStateChance
                  .elementAt(i)
                  .stateId)
              .votes;
          currentElection.setCandidateWinner = _simpleCandidateSecond;
          currentElection.setCandidateLooser = _simpleCandidateFirst;
        }

        currentElection.getCandidateWinner.totalWins++;

        currentElection.setState = states.elementAt(
            _candidateFirst.jsonCandidateStateChance.elementAt(i).stateId);

        innerElections.add(currentElection);
      }

      elections.add(innerElections);
    }

    return elections;
  }

  Future _waitForJSON() async {
    Future.wait([
      jsonHandler.fetchStates(widget.stateFilePath).then((value) {
        for (int i = 0; i < value.length; i++) {
          states.add(value.elementAt(i));
        }
      }),
      jsonHandler.fetchCandidates(widget.candidatesInput).then((value) {
        for (int i = 0; i < value.length; i++) {
          candidates.add(value.elementAt(i));
        }
      })
    ]).then((value) {
      setState(() {
        data = _calculateResults();
      });
    });
  }

  futureSimulationInternalList(context, currentElectionList) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentElectionList.length,
        itemBuilder: (BuildContext context, int index) {
          Election election = currentElectionList.elementAt(index);

          Column upsetVictoryColumn;

          if (election.getCandidateWinner.chanceOfWinning.elementAt(index) <=
              30) {
            upsetVictoryColumn = Column(
              children: [
                Icon(
                  Icons.emoji_people,
                  color: Colors.amber,
                  size: 28,
                ),
                Text("Upset\nVictory")
              ],
            );
          } else {
            upsetVictoryColumn = Column();
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Table(
                    columnWidths: {0: FractionColumnWidth(.3)},
                    children: [
                      TableRow(children: [
                        Text(
                          election.getState.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Winner:" + election.getCandidateWinner.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]),
                      TableRow(children: [
                        Text(""),
                        Text("Votes: +" + election.getState.votes.toString()),
                      ]),
                      TableRow(children: [
                        Text(""),
                        Text("Chance of winning: " +
                            election.getCandidateWinner.chanceOfWinning
                                .elementAt(index)
                                .toString()),
                      ])
                    ],
                  ),
                  Align(
                      alignment: Alignment.topRight, child: upsetVictoryColumn)
                ],
              ),
            ),
          );
        });
  }

  void _calculateSimulationTotals(List<List<Election>> data,
      SimpleCandidate overallCandidate1, SimpleCandidate overallCandidate2) {
    int counter;
    for (int i = 0; i < data.length; i++) {
      List<Election> le = data.elementAt(i);

      overallCandidate1.resetVotes();
      overallCandidate2.resetVotes();

      counter = 0;

      for (int j = 0; j < le.length; j++) {
        Election e = le.elementAt(j);
        counter++;

        if (overallCandidate1.name == e.getCandidateWinner.name) {
          overallCandidate1.totalVotes++;
        } else {
          overallCandidate2.totalVotes++;
        }
      }

      if (overallCandidate1.totalVotes > (counter / 2)) {
        overallCandidate1.totalWins++;
      } else {
        overallCandidate2.totalWins++;
      }
    }
  }

  futureSimulation(context) {
    return FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot<List<List<Election>>> snapshot) {
          if (snapshot.hasData) {
            SimpleCandidate overallCandidate1 =
                new SimpleCandidate(candidates.elementAt(0).name);
            SimpleCandidate overallCandidate2 =
                new SimpleCandidate(candidates.elementAt(1).name);

            _calculateSimulationTotals(
                snapshot.data, overallCandidate1, overallCandidate2);

            return ScrollablePositionedList.builder(
                itemPositionsListener: itemPositionsListener,
                itemScrollController: itemScrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  List<Election> currentElectionList =
                      snapshot.data.elementAt(index);

                  Election e = currentElectionList.elementAt(0);

                  int overallTotalVotes = e.getCandidateWinner.totalVotes +
                      e.getCandidateLooser.totalVotes;
                  String winnerString;

                  if (e.getCandidateWinner.totalVotes >
                      (overallTotalVotes / 2)) {
                    winnerString =
                        "Projected winner: " + e.getCandidateWinner.name;
                  } else if (e.getCandidateLooser.totalVotes >
                      (overallTotalVotes / 2)) {
                    winnerString =
                        "Projected winner: " + e.getCandidateLooser.name;
                  } else {
                    winnerString = "Projected winner: N/A";
                  }

                  Widget paddingCustomTopBottom5(Widget widget) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: widget,
                    );
                  }

                  TableRow tableRowCustomX2(String col1, String col2) {
                    return TableRow(children: [
                      paddingCustomTopBottom5(
                          Text(col1, textAlign: TextAlign.center)),
                      paddingCustomTopBottom5(
                          Text(col2, textAlign: TextAlign.center)),
                    ]);
                  }

                  TableRow tableRowCustomX3(
                      String col1, String col2, String col3) {
                    return TableRow(children: [
                      paddingCustomTopBottom5(Text(col1)),
                      paddingCustomTopBottom5(Text(col2)),
                      paddingCustomTopBottom5(Text(col3)),
                    ]);
                  }

                  TableRow tableRowCandidateFinal(SimpleCandidate candidate) {
                    return tableRowCustomX3(
                        candidate.name,
                        candidate.totalWins.toString(),
                        candidate.getChanceOfWinning().toString());
                  }

                  TableBorder horizontalBorder = new TableBorder(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      horizontalInside: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 1,
                          style: BorderStyle.solid),
                      verticalInside: BorderSide.none);

                  Card futureSimulationCard = new Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Simulation # " + index.toString(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(children: [
                                Text(
                                  winnerString,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Table(
                                  border: horizontalBorder,
                                  children: [
                                    tableRowCustomX3(
                                        "Candidate", "Wins", "Chance"),
                                    tableRowCandidateFinal(
                                        e.getCandidateWinner),
                                    tableRowCandidateFinal(
                                        e.getCandidateLooser),
                                  ],
                                )
                              ]),
                            ),
                          ),
                          futureSimulationInternalList(
                              context, currentElectionList),
                        ],
                      ),
                    ),
                  );

                  if (index == 0) {
                    return Column(
                      children: [
                        Card(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Total Simulations: " +
                                        snapshot.data.length.toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Table(
                                    border: horizontalBorder,
                                    children: [
                                      tableRowCustomX2(
                                          "Candidate", "Overall Wins"),
                                      tableRowCustomX2(
                                          overallCandidate1.name,
                                          overallCandidate1.totalWins
                                              .toString()),
                                      tableRowCustomX2(
                                          overallCandidate2.name,
                                          overallCandidate2.totalWins
                                              .toString()),
                                    ],
                                  )
                                ],
                              )),
                        ),
                        futureSimulationCard,
                      ],
                    );
                  } else {
                    return futureSimulationCard;
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _jumpToSimulation([String index]) {
    int scrollTo = index == null ? simulationToJumpTo : int.parse(index);

    itemScrollController.scrollTo(
        index: scrollTo,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  searchbar(context) {
    return Row(
      children: [
        SearchBarUI(
          buttonCallback: (value) => _jumpToSimulation(value),
          callback: (value) {
            setState(() {
              simulationToJumpTo = value;
            });
          },
        ),
        FlatButton(
            onPressed: _jumpToSimulation,
            child: Icon(Icons.arrow_forward_sharp))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    states = List<JSONState>();
    candidates = new List<JSONCandidate>();
    jsonHandler = new JSONHandler(context);

    _waitForJSON();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Election Simulation',
        home: Scaffold(
            appBar: AppBar(
              title: Text(""),
              actions: [searchbar(context)],
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      child: Center(
                        // Use future builder and DefaultAssetBundle to load the local JSON file
                        child: futureSimulation(context),
                      ),
                    )))));
  }
}
