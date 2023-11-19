import 'package:chore_manager/classes.dart';
import 'package:chore_manager/initial_data.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  bool altMode = false; // altMode is B Type

  void switchMode() {
    altMode = !altMode;
    notifyListeners();
  }

  void resetApp() {
    chores = InitialData().getChores();
    rooms = InitialData().getRooms();
    users = InitialData().getUsers();
    notifyListeners();
  }

  late List<Chore> chores;
  late List<Room> rooms;
  late List<User> users;

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
        chores.where((chore) => chore.room == room.name).toList()
          ..sort(
            (a, b) => a.dueDate.compareTo(b.dueDate),
          ),
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
      ));
    }
    return res;
  }
}