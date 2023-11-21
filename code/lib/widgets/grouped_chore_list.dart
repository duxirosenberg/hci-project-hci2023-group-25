import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupedChoreList extends StatelessWidget {
  final GroupedChores chores;
  const GroupedChoreList({super.key, required this.chores});
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
