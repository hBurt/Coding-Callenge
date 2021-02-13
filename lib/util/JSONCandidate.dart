import 'package:coding_challenge/util/JSONCandidateStateChance.dart';

class JSONCandidate {
  int id;
  String name;
  List<JSONCandidateStateChance> jsonCandidateStateChance;

  JSONCandidate({this.id, this.name, this.jsonCandidateStateChance});

  JSONCandidate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['state_chances_of_winning'] != null) {
      jsonCandidateStateChance = new List<JSONCandidateStateChance>();
      json['state_chances_of_winning'].forEach((v) {
        jsonCandidateStateChance.add(new JSONCandidateStateChance.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return "id: " +
        id.toString() +
        ", name: " +
        name +
        ", state/chance: " +
        jsonCandidateStateChance.toString();
  }
}
