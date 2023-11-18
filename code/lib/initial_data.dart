import 'package:chore_manager/classes.dart';

// store expanded state in the grouped by attribute?

class InitialData {
  static List<Room> rooms = [
    Room("Kitchen"),
    Room("Bathroom"),
    Room("Other"),
  ];

  static List<User> users = [
    User("Nic"),
    User("Günther"),
    User("Sebasthian"),
  ];

  static List<Chore> chores = [
    Chore(
        name: "Clean the fridge",
        room: "Kitchen",
        assignees: ["Nic", "Günther"],
        currentAssignee: 1,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        frequency: 30),
    Chore(
        name: "Wipe Floor",
        room: "Kitchen",
        assignees: ["Nic"],
        currentAssignee: 0,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        frequency: 14),
    Chore(
        name: "Clean Mirror & Sink",
        room: "Bathroom",
        assignees: ["Nic"],
        currentAssignee: 0,
        dueDate: DateTime.now().add(const Duration(days: 6)),
        frequency: 7),
    Chore(
        name: "Bathtub Deep Clean",
        room: "Bathroom",
        assignees: ["Nic"],
        currentAssignee: 0,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        frequency: 60),
    Chore(
        name: "Take out trash",
        room: "Kitchen",
        assignees: ["Nic"],
        currentAssignee: 0,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        frequency: 7),
  ];
}
