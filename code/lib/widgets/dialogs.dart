import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoreDialog extends StatelessWidget {
  final Chore chore;
  const ChoreDialog({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chore.name),
          UserDisplay(
              user: chore.assignees[chore.currentAssignee], small: false),
        ],
      ),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Assigned to: ${chore.assignees[chore.currentAssignee]}"),
            Text("Due ${chore.getDueString()}"),
            Text("Room: ${chore.room}"),
            Text(chore.room),
            Text("Notes: ${chore.notes}"),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        chore.assignedToUser
            ? OutlinedButton(
                onPressed: () {
                  context.read<DataProvider>().markDone(chore);
                },
                child: const Text("Mark as completed"),
              )
            : OutlinedButton(
                onPressed: () {}, child: const Text("Send a reminder")),
      ],
    );
  }
}

class ChoreEditDialog extends StatelessWidget {
  const ChoreEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
