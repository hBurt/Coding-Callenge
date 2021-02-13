import 'JSONState.dart';

class Election {
  int _candidate1TotalVotes = 0;
  int _candidate2TotalVotes = 0;
  SimpleCandidate _candidateWinner;
  SimpleCandidate _candidateLooser;
  JSONState _state;

  int get getCandidate1TotalVotes => _candidate1TotalVotes;
  set setCandidate1TotalVotes(int votes) => _candidate1TotalVotes = votes;

  int get getCandidate2TotalVotes => _candidate2TotalVotes;
  set setCandidate2TotalVotes(int votes) => _candidate2TotalVotes = votes;

  SimpleCandidate get getCandidateWinner => _candidateWinner;
  set setCandidateWinner(SimpleCandidate winner) => _candidateWinner = winner;

  SimpleCandidate get getCandidateLooser => _candidateLooser;
  set setCandidateLooser(SimpleCandidate looser) => _candidateLooser = looser;

  JSONState get getState => _state;
  set setState(JSONState state) => _state = state;
}

class SimpleCandidate {
  String name;
  List<int> chanceOfWinning = new List<int>();
  int totalVotes = 0;
  int totalWins = 0;
  int upsetWins = 0;

  SimpleCandidate(this.name);

  void resetVotes() {
    totalVotes = 0;
  }

  double getChanceOfWinning() {
    double total = 0;
    double denominator = 0;
    for (int i in chanceOfWinning) {
      total += i;
      denominator++;
    }

    return total / denominator;
  }
}
