import 'package:chore_manager/core/utils.dart';
import 'package:flutter/material.dart';

class Chore {
  final String name;
  final List<String> assignees;
  int indexOfCurrentAssignee; // index of the current assignee
  final String room;
  DateTime dueDate; // probably need to replace with schedule
  final int frequency; // days before chore should be done again
  final String? notes;

  Chore({
    required this.assignees,
    required this.indexOfCurrentAssignee,
    required this.name,
    required this.dueDate,
    required this.frequency,
    required this.room,
    required this.notes,
  });

  Chore.clone(Chore chore)
      : this(
          name: chore.name,
          assignees: List.from(chore.assignees),
          indexOfCurrentAssignee: chore.indexOfCurrentAssignee,
          room: chore.room,
          dueDate: chore.dueDate.copyWith(),
          frequency: chore.frequency,
          notes: chore.notes,
        );

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

  Color? get dueColor {
    final dayDiff = daysUntilDue();

    if (dayDiff < 0) {
      return Colors.redAccent;
    } else if (dayDiff == 0) {
      return Colors.orangeAccent;
    } else {
      return null;
    }
  }

  String get frequencyString {
    if (frequency == 1) {
      return "daily";
    } else if (frequency == 7) {
      return "weekly";
    } else if (frequency == 14) {
      return "biweekly";
    } else if (frequency == 30) {
      return "monthly";
    } else {
      return "every $frequency days";
    }
  }

  void markDone() {
    if (assignees.isNotEmpty) {
      indexOfCurrentAssignee = (indexOfCurrentAssignee + 1) % assignees.length;
    }
    dueDate = MyDateUtils.today().add(Duration(days: frequency));
  }

  bool get assignedToUser {
    return indexOfCurrentAssignee == 0;
  }

  String? get currentAssignee {
    if (assignees.isEmpty) {
      return null;
    } else {
      return assignees[indexOfCurrentAssignee];
    }
  }

  int daysUntilDue() {
    return dueDate.difference(MyDateUtils.today()).inDays;
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

class SpecialGroup extends ChoreGroup {
  SpecialGroup(super.name);
}

typedef GroupedChores = List<(ChoreGroup, List<Chore>)>;
