import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/core/utils.dart';

// store expanded state in the grouped by attribute?

class InitialData {
  List<Room> getRooms() {
    return [
      Room("Kitchen"),
      Room("Bathroom"),
      Room("Other"),
    ];
  }

  List<User> getUsers() {
    return [
      User("You"),
      User("Günther"),
      User("Sebastian"),
    ];
  }

  List<Due> getDues() {
    return [
      Due("Overdue"),
      Due("Due Today"),
      Due("Upcoming"),
    ];
  }

  List<Chore> getChores() {
    return [
      Chore(
        name: "Clean the fridge",
        room: "Kitchen",
        assignees: ["You"],
        currentAssignee: 0,
        dueDate: DateUtils.today().add(const Duration(days: 1)),
        frequency: 30,
        notes:
            "Please make sure to clean all compartments. This also includes the butter compartment. Also wipe all sections with a wet cloth.",
      ),
      Chore(
        name: "Wipe Floor",
        room: "Kitchen",
        assignees: ["You", "Günther", "Sebastian"],
        currentAssignee: 1,
        dueDate: DateUtils.today().add(const Duration(days: 3)),
        frequency: 14,
        notes: "",
      ),
      Chore(
        name: "Clean Mirror & Sink",
        room: "Bathroom",
        assignees: ["You", "Günther", "Sebastian"],
        currentAssignee: 0,
        dueDate: DateUtils.today().add(const Duration(days: 6)),
        frequency: 7,
        notes: null,
      ),
      Chore(
        name: "Bathtub Deep Clean",
        room: "Bathroom",
        assignees: ["You", "Günther", "Sebastian"],
        currentAssignee: 0,
        dueDate: DateUtils.today().add(const Duration(days: 7)),
        frequency: 60,
        notes: null,
      ),
      Chore(
        name: "Take out trash",
        room: "Kitchen",
        assignees: ["You", "Günther", "Sebastian"],
        currentAssignee: 0,
        dueDate: DateUtils.today().add(const Duration(days: -2)),
        frequency: 7,
        notes: null,
      ),
      Chore(
        assignees: ["You", "Günther", "Sebastian"],
        currentAssignee: 0,
        name: "Vacuum",
        dueDate: DateUtils.today(),
        frequency: 1,
        room: "Other",
        notes: "Also vacuum the sofa",
      ),
    ];
  }
}
