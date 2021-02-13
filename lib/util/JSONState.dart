class JSONState {
  final int id;
  final int votes;
  final String name;

  JSONState({this.id, this.name, this.votes});

  factory JSONState.fromJson(Map<String, dynamic> json) {
    return JSONState(
        id: json['id'] as int,
        name: json['name'] as String,
        votes: json['votes'] as int);
  }

  @override
  String toString() {
    return "id: " +
        id.toString() +
        ", name: " +
        name +
        ", votes: " +
        votes.toString();
  }
}
