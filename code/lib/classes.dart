class Chore {
  final String name;
  final String assignee;
  final String room;
  final DateTime dueDate; // probably need to replace with schedule

  Chore(
      {required this.name,
      required this.assignee,
      required this.dueDate,
      required this.room});
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
