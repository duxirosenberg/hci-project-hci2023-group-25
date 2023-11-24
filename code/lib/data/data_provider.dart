import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/initial_data.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  bool altMode = true; // altMode is B Type

  void switchMode() {
    altMode = !altMode;
    notifyListeners();
  }

  void resetApp() {
    chores = InitialData().getChores();
    rooms = InitialData().getRooms();
    users = InitialData().getUsers();
    dues = InitialData().getDues();
    notifyListeners();
  }

  late List<Chore> chores;
  late List<Room> rooms;
  late List<User> users;
  late List<Due> dues;

  DataProvider() {
    resetApp();
  }

  void markDone(Chore chore) {
    chore.markDone();
    notifyListeners();
  }

  void setExpanded(ChoreGroup group, bool expanded) {
    group.expanded = expanded;
    notifyListeners();
  }

  GroupedChores get sortByRoom {
    final GroupedChores res = [];

    for (final room in rooms) {
      res.add((
        room,
        chores.where((chore) => chore.room == room.name).toList(),
      ));
    }
    return res;
  }

  GroupedChores get sortByAssignee {
    final GroupedChores res = [];

    for (final user in users) {
      res.add((
        user,
        chores
            .where(
                (chore) => chore.assignees[chore.currentAssignee] == user.name)
            .toList()
          ..sortByDue(),
      ));
    }
    return res;
  }

  GroupedChores get sortByDueDate {
    final GroupedChores res = [];
    res.add((dues[0], [])); // overdue
    res.add((dues[1], [])); // due today
    res.add((dues[2], [])); // upcoming

    for (final chore in chores) {
      int index;
      if (chore.daysUntilDue() < 0) {
        index = 0;
      } else if (chore.daysUntilDue() == 0) {
        index = 1;
      } else {
        index = 2;
      }

      res[index].$2.add(chore);
    }

    for (final group in res) {
      group.$2.sortByDue();
    }
    return res;
  }

  List<Chore> get personalChores {
    return chores
        .where((chore) => chore.assignees[chore.currentAssignee] == "You")
        .toList()
      ..sortByDue();
  }

  /*List<Chore> get otherChores {
    return chores
        .where((chore) => chore.assignees[chore.currentAssignee] != "You")
        .toList()
      ..sortByDue();
  }*/
}

extension Sorter on List<Chore> {
  void sortByDue() {
    sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void sortByFrequency() {
    sort((a, b) => a.frequency.compareTo(b.frequency));
  }
}
