class JSONCandidateStateChance {
  int stateId;
  int chance;

  JSONCandidateStateChance({this.stateId, this.chance});

  JSONCandidateStateChance.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    chance = json['chance'];
  }

  @override
  String toString() {
    return "[stateID: " +
        stateId.toString() +
        ", chance: " +
        chance.toString() +
        "]";
  }
}
