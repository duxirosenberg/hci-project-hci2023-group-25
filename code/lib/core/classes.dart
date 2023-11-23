import 'package:chore_manager/core/utils.dart';

class Chore {
  final String name;
  final List<String> assignees;
  int currentAssignee; // index of the current assignee
  final String room;
  DateTime dueDate; // probably need to replace with schedule
  final int frequency; // days before chore should be done again
  final String? notes;

  Chore({
    required this.assignees,
    required this.currentAssignee,
    required this.name,
    required this.dueDate,
    required this.frequency,
    required this.room,
    required this.notes,
  });

  String get dueString {
    final dayDiff = daysUntilDue();

    if (dayDiff == 0) {
      return "today";
    } else if (dayDiff == 1) {
      return "tomorrow";
    } else if (dayDiff == -1) {
      return "yesterday";
    } else if (dayDiff < 0) {
      return "${dayDiff.abs()} days ago";
    } else {
      return "in $dayDiff days";
    }
  }

  String get frequencyString {
    if (frequency == 1) {
      return "daily";
    } else if (frequency == 7) {
      return "weekly";
    } else {
      return "every $frequency days";
    }
  }

  void markDone() {
    currentAssignee = (currentAssignee + 1) % assignees.length;
    dueDate = DateUtils.today().add(Duration(days: frequency));
  }

  bool get assignedToUser {
    return currentAssignee == 0;
  }

  int daysUntilDue() {
    return dueDate.difference(DateUtils.today()).inDays;
  }
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
