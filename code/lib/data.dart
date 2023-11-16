import 'package:chore_manager/classes.dart';

// store expanded state in the grouped by attribute?

class Global {
  static List<Room> rooms = [
    Room("Kitchen"),
    Room("Bathroom"),
    Room("Other"),
  ];

  static List<User> users = [User("Nic")];

  static List<Chore> chores = [
    Chore(
        name: "Clean the fridge",
        room: "Kitchen",
        assignee: "Nic",
        dueDate: DateTime.now().add(Duration(days: 1))),
    Chore(
        name: "Wipe Floor",
        room: "Kitchen",
        assignee: "Nic",
        dueDate: DateTime.now().add(Duration(days: 3))),
    Chore(
        name: "Clean Mirror & Sink",
        room: "Bathroom",
        assignee: "Nic",
        dueDate: DateTime.now().add(Duration(days: 6))),
    Chore(
        name: "Bathtub Deep Clean",
        room: "Bathroom",
        assignee: "Nic",
        dueDate: DateTime.now().add(Duration(days: 7))),
    Chore(
        name: "Take out trash",
        room: "Kitchen",
        assignee: "Nic",
        dueDate: DateTime.now().add(Duration(days: 2))),
  ];
}

GroupedChores sortByRoom() {
  final GroupedChores res = [];

  for (final room in Global.rooms) {
    res.add((
      room,
      Global.chores.where((chore) => chore.room == room.name).toList()
    ));
  }
  return res;
}

GroupedChores sortByAssignee() {
  final GroupedChores res = [];

  for (final user in Global.users) {
    res.add((
      user,
      Global.chores.where((chore) => chore.assignee == user.name).toList()
    ));
  }
  return res;
}
