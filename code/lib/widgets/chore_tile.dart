import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoreTile extends StatelessWidget {
  final Chore chore;

  const ChoreTile({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chore.name),
      subtitle: Text("Due ${chore.dueString}"),
      leading: CheckboxOrBell(chore: chore),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserDisplay(
              small: true, user: chore.assignees[chore.currentAssignee]),
          /*IconButton(
            onPressed: () {
              context.read<DataProvider>().markDone(chore);
            },
            icon: const Icon(Icons.check),
          ),*/
        ],
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return Consumer<DataProvider>(builder: (context, data, child) {
            return ChoreDialog(
              chore: chore,
            );
          });
        },
      ),
    );
  }
}

class ChoreDetail extends StatelessWidget {
  final Chore chore;
  const ChoreDetail({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CheckboxOrBell(chore: chore),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  chore.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            UserDisplay(
                user: chore.assignees[chore.currentAssignee], small: false),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(chore.dueString),
        ),
        ListTile(
          leading: const Icon(Icons.location_pin),
          title: Text(chore.room),
        ),
        ListTile(
          leading: const Icon(Icons.replay_rounded),
          title: Text(chore.frequencyString),
        ),
        if (chore.notes != null)
          ListTile(
            leading: const Icon(Icons.notes),
            title: Text(chore.notes!),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text("Edit")),
        ),
        /* chore.assignedToUser
            ? OutlinedButton(
                onPressed: () {
                  context.read<DataProvider>().markDone(chore);
                },
                child: const Text("Mark as completed"),
              )
            : OutlinedButton(
                onPressed: () {}, child: const Text("Send a reminder")),*/
      ],
    );
  }
}

class UserDisplay extends StatelessWidget {
  final bool small;
  final String user;
  const UserDisplay({super.key, required this.user, required this.small});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          width: 8,
        ),
        CircleAvatar(
          child: Text(user.substring(0, 1)),
        ),
      ],
    );
  }
}

class CheckboxOrBell extends StatelessWidget {
  final Chore chore;
  const CheckboxOrBell({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return chore.assignedToUser
        ? Checkbox(
            value: false,
            onChanged: (value) {
              context.read<DataProvider>().markDone(chore);
            },
          )
        : SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
              ),
            ),
          );
  }
}
