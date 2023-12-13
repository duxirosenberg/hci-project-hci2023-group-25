import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/core/utils.dart';

class InitialData {
  List<Room> getRooms() {
    return [
      Room("General"),
      Room("Living Room"),
      Room("Kitchen"),
      Room("Bathroom"),
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
        assignees: ["You", "Sebastian"],
        indexOfCurrentAssignee: 0,
        dueDate: MyDateUtils.today().add(const Duration(days: 1)),
        frequency: 30,
        notes:
            "Please make sure to clean all compartments. This also includes the butter compartment. If you see this, read it out loud. Also wipe all sections with a wet cloth.",
      ),
      Chore(
        name: "Sweep Floor",
        room: "Kitchen",
        assignees: ["You", "Günther", "Sebastian"],
        indexOfCurrentAssignee: 1,
        dueDate: MyDateUtils.today().add(const Duration(days: 3)),
        frequency: 14,
        notes:
            "Sweep the floor with the broomstick to get rid of crumbs and dust. If the floor is sticky, also mop the floor. If you read this, send a reminder to your roommate.",
      ),
      Chore(
        name: "Clean Mirror & Sink",
        room: "Bathroom",
        assignees: ["You", "Günther", "Sebastian"],
        indexOfCurrentAssignee: 2,
        dueDate: MyDateUtils.today().add(const Duration(days: 6)),
        frequency: 7,
        notes: null,
      ),
      Chore(
        name: "Bathtub Deep Clean",
        room: "Bathroom",
        assignees: ["You", "Sebastian", "Günther"],
        indexOfCurrentAssignee: 2,
        dueDate: MyDateUtils.today().add(const Duration(days: 7)),
        frequency: 30,
        notes: null,
      ),
      Chore(
        name: "Take out trash",
        room: "Kitchen",
        assignees: ["You", "Günther", "Sebastian"],
        indexOfCurrentAssignee: 0,
        dueDate: MyDateUtils.today().add(const Duration(days: -2)),
        frequency: 7,
        notes:
            "Put the trash bag into the grey metal container by the street. Make sure to put a new trash bag into the bin afterwards.",
      ),
      Chore(
        assignees: ["You", "Günther", "Sebastian"],
        indexOfCurrentAssignee: 0,
        name: "Vacuum",
        dueDate: MyDateUtils.today(),
        frequency: 1,
        room: "General",
        notes: "Also vacuum the sofa",
      ),
    ];
  }
}
