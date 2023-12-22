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
      subtitle: Row(
        children: [
          Icon(
            Icons.access_time,
            size: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 2,
            color: chore.dueColor,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(chore.dueString),
        ],
      ),
      leading: CheckboxOrBell(chore: chore),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserDisplay(small: true, user: chore.currentAssignee),
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

class ChoreDetail extends StatefulWidget {
  final Chore chore;
  final bool dialog;
  const ChoreDetail({super.key, required this.chore, this.dialog = false});

  @override
  State<ChoreDetail> createState() => _ChoreDetailState();
}

class _ChoreDetailState extends State<ChoreDetail> {
  late Chore chore;

  @override
  void initState() {
    chore = widget.chore;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CheckboxOrBell(chore: chore),
          title: Text(
            chore.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: IconButton(
              onPressed: () async {
                final res = await showDialog<Chore>(
                  context: context,
                  builder: (context) {
                    return ChoreEditDialog(
                      chore: chore,
                      onDeletePopTwice: widget.dialog,
                    );
                  },
                );

                if (res != null) chore = res;
              },
              icon: const Icon(Icons.edit)),
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: UserDisplay(
                    user: chore.currentAssignee,
                    small: false,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.access_time,
                      color: chore.dueColor,
                    ),
                    title: Text(chore.dueString),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: const Icon(Icons.location_pin),
                    title: Text(chore.room),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: const Icon(Icons.replay_rounded),
                    title: Text(chore.frequencyString),
                  ),
                ),
              ],
            ),
            if (chore.assignees.length >= 2)
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.group),
                title: Row(
                  children: chore.assignees
                      .map((user) => SizedBox(
                          height: 28,
                          width: 32,
                          child: UserDisplay(user: user, small: true)))
                      .toList(),
                ),
              ),
            if (chore.notes != null)
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.notes),
                title: Text(chore.notes!),
              ),
          ],
        ),
      ],
    );
  }
}

class UserDisplay extends StatelessWidget {
  final bool small;
  final String? user;
  final double? radius;
  const UserDisplay(
      {super.key, required this.user, required this.small, this.radius});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      if (small) {
        return Container();
      } else {
        return const ListTile(
          leading: Icon(Icons.no_accounts),
          title: Text("Unassigned"),
        );
      }
    } else {
      if (small) {
        return CircleAvatar(
          backgroundColor:
              user == "You" ? Colors.greenAccent : Colors.lightBlueAccent,
          radius: radius,
          child: Text(user!.substring(0, 1)),
        );
      }

      return ListTile(
        leading: CircleAvatar(
          radius: 12,
          backgroundColor:
              user == "You" ? Colors.greenAccent : Colors.lightBlueAccent,
          child: Text(user!.substring(0, 1)),
        ),
        title: Text(
          user!,
        ),
      );
    }
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
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("\"${chore.name}\" marked as done"),
              ));
            },
          )
        : IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Sent a reminder for \"${chore.name}\""),
              ));
            },
            icon: const Icon(
              Icons.notifications_active_outlined,
            ),
          );
  }
}
