import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoreList extends StatelessWidget {
  final GroupedChores chores;
  const ChoreList({super.key, required this.chores});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        // maybe replace with ExpansionTiles
        expansionCallback: (panelIndex, isExpanded) {
          context
              .read<DataProvider>()
              .setExpanded(chores[panelIndex].$1, isExpanded);
        },
        children: chores.map((entry) {
          return ExpansionPanel(
              isExpanded: entry.$1.expanded,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(entry.$1.name),
                );
              },
              body: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.$2.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChoreTile(chore: entry.$2[index]);
                },
              ));
        }).toList(),
      ),
    );
  }
}

class ChoreTile extends StatelessWidget {
  final Chore chore;

  const ChoreTile({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chore.name),
      subtitle: Text("Due ${chore.getDueString()}"),
      leading: chore.assignedToUser
          ? Checkbox(
              value: false,
              onChanged: (value) {
                context.read<DataProvider>().markDone(chore);
              },
            )
          : IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              padding: EdgeInsets.zero,
            ),
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
          return ChoreDialog(
            chore: chore,
          );
        },
      ),
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
        CircleAvatar(
          child: Text(user.substring(0, 1)),
        ),
        const SizedBox(
          width: 8,
        ),
        if (!small)
          Text(
            user,
            style: const TextStyle(fontSize: 14),
          ),
      ],
    );
  }
}
