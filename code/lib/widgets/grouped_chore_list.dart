import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupedChoreList extends StatelessWidget {
  final GroupedChores chores;
  const GroupedChoreList({super.key, required this.chores});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90),
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
            body: entry.$2.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("No chores here at the moment!"),
                  )
                : ChoreList(chores: entry.$2),
          );
        }).toList(),
      ),
    );
  }
}
