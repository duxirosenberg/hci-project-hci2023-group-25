class Chore {
  final String name;
  final List<String> assignees;
  int currentAssignee; // index of the current assignee
  final String room;
  DateTime dueDate; // probably need to replace with schedule
  final int frequency; // days before chore should be done again

  Chore({
    required this.assignees,
    required this.currentAssignee,
    required this.name,
    required this.dueDate,
    required this.frequency,
    required this.room,
  });

  /*String getDateString() {

  }*/
}

class ChoreGroup {
  final String name;
  bool expanded = true;

  ChoreGroup(this.name);
}

class Room extends ChoreGroup {
  Room(super.name);
}

class User extends ChoreGroup {
  User(super.name);
}

class Due extends ChoreGroup {
  Due(super.name);
}

typedef GroupedChores = List<(ChoreGroup, List<Chore>)>;
