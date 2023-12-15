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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: chores
              .map((entry) => Card(
                    child: ExpansionTile(
                      leading: entry.$3,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${entry.$2.length} Chore(s)",
                            style: const TextStyle(fontSize: 14),
                          ),
                          AnimatedRotation(
                            turns: entry.$1.expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.expand_more),
                          ),
                        ],
                      ),
                      initiallyExpanded: entry.$1.expanded,
                      onExpansionChanged: (isExpanded) {
                        context
                            .read<DataProvider>()
                            .setExpanded(entry.$1, isExpanded);
                      },
                      backgroundColor: Colors.transparent,
                      title: Row(
                        children: [
                          Text(entry.$1.name),
                        ],
                      ),
                      children: [
                        ChoreList(chores: entry.$2, scrollable: false)
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
