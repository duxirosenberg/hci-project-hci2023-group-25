import 'package:chore_manager/classes.dart';
import 'package:chore_manager/utils.dart';

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
      dueDate: DateUtils.today().add(const Duration(days: 1)),
      frequency: 30,
      notes:
          "Please make sure to clean all compartments. This also included the butter compartment. Also wipe all sections with a wet cloth.",
    ),
    Chore(
      name: "Wipe Floor",
      room: "Kitchen",
      assignees: ["Nic"],
      currentAssignee: 0,
      dueDate: DateUtils.today().add(const Duration(days: 3)),
      frequency: 14,
      notes: null,
    ),
    Chore(
      name: "Clean Mirror & Sink",
      room: "Bathroom",
      assignees: ["Nic"],
      currentAssignee: 0,
      dueDate: DateUtils.today().add(const Duration(days: 6)),
      frequency: 7,
      notes: null,
    ),
    Chore(
      name: "Bathtub Deep Clean",
      room: "Bathroom",
      assignees: ["Nic"],
      currentAssignee: 0,
      dueDate: DateUtils.today().add(const Duration(days: 7)),
      frequency: 60,
      notes: null,
    ),
    Chore(
      name: "Take out trash",
      room: "Kitchen",
      assignees: ["Nic"],
      currentAssignee: 0,
      dueDate: DateUtils.today().add(const Duration(days: -2)),
      frequency: 7,
      notes: null,
    ),
    Chore(
      assignees: ["Nic"],
      currentAssignee: 0,
      name: "Vacuum",
      dueDate: DateUtils.today(),
      frequency: 1,
      room: "Other",
      notes: "Also vacuum the sofa",
    ),
  ];
}
