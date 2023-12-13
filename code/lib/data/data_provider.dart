import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/initial_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DataProvider with ChangeNotifier {
  void switchMode() {
    settingsBox.put("altMode", !altMode);
    notifyListeners();
  }

  void resetApp() async {
    await choreBox.clear();
    await roomBox.clear();
    await userBox.clear();

    await choreBox.addAll(InitialData().getChores());
    await roomBox.addAll(InitialData().getRooms());
    await userBox.addAll(InitialData().getUsers());
    notifyListeners();
  }

  final Box settingsBox = Hive.box("settings");
  final Box<Chore> choreBox = Hive.box("chores");
  final Box<Room> roomBox = Hive.box("rooms");
  final Box<User> userBox = Hive.box("users");
  late List<Due> dues;

  SpecialGroup unassigned = SpecialGroup("Unassigned");

  DataProvider() {
    dues = InitialData().getDues();

    final firstRun = settingsBox.get("firstRun", defaultValue: true) as bool;
    if (firstRun) {
      resetApp();
      settingsBox.put("firstRun", false);
      settingsBox.put("altMode", false);
    }
  }

  bool get altMode {
    return settingsBox.get("altMode", defaultValue: false) as bool;
  }

  void markDone(Chore chore) async {
    chore.markDone();
    await chore.save();
    notifyListeners();
  }

  void setExpanded(ChoreGroup group, bool expanded) {
    group.expanded = expanded;
    notifyListeners();
  }

  Future<void> addChore(Chore chore) async {
    await choreBox.add(chore);
    notifyListeners();
  }

  Future<void> updateChore(Chore old, Chore updated) async {
    old.delete();
    choreBox.add(updated);

    notifyListeners();
  }

  GroupedChores get sortByRoom {
    final GroupedChores res = [];

    for (final room in roomBox.values) {
      final choresInRoom = choreBox.values
          .where((chore) => chore.room == room.name)
          .toList()
        ..sortByDue();

      if (choresInRoom.isNotEmpty) {
        res.add((room, choresInRoom));
      }
    }
    return res;
  }

  GroupedChores get sortByAssignee {
    final GroupedChores res = [];

    for (final user in userBox.values) {
      res.add((
        user,
        choreBox.values
            .where((chore) =>
                chore.assignees.isNotEmpty &&
                chore.assignees[chore.indexOfCurrentAssignee] == user.name)
            .toList()
          ..sortByDue(),
      ));
    }

    res.add((
      unassigned,
      choreBox.values.where((chore) => chore.assignees.isEmpty).toList()
    ));

    return res;
  }

  GroupedChores get sortByDueDate {
    final GroupedChores res = [];
    res.add((dues[0], [])); // overdue
    res.add((dues[1], [])); // due today
    res.add((dues[2], [])); // upcoming

    for (final chore in choreBox.values) {
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
    return choreBox.values
        .where((chore) =>
            chore.assignees.isNotEmpty &&
            chore.assignees[chore.indexOfCurrentAssignee] == "You")
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
