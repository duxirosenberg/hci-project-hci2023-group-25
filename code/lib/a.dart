import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/grouped_chore_list.dart';
import 'package:chore_manager/widgets/navigation_bar.dart';
import 'package:chore_manager/widgets/popup_actions.dart';
import 'package:flutter/material.dart';

class A extends StatelessWidget {
  final DataProvider data;
  const A({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Chores'),
          bottom: const TabBar(tabs: [
            Tab(text: "Room"),
            Tab(text: "Assigned to"),
            Tab(text: "Due Date"),
          ]),
          actions: const [Text("A"), TopActionMenu()],
        ),
        body: TabBarView(
          children: [
            GroupedChoreList(chores: data.sortByRoom),
            GroupedChoreList(chores: data.sortByAssignee),
            GroupedChoreList(chores: data.sortByDueDate),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)),
        bottomNavigationBar: const MyNavigationBar(),
      ),
    );
  }
}
