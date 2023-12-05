import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_list.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:chore_manager/widgets/dialogs.dart';
import 'package:chore_manager/widgets/navigation_bar.dart';
import 'package:chore_manager/widgets/popup_actions.dart';
import 'package:flutter/material.dart';

class B extends StatelessWidget {
  final DataProvider data;
  const B({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Chores"),
          bottom: const TabBar(tabs: [
            Tab(text: "Your chores"),
            Tab(text: "All chores"),
          ]),
          actions: const [Text("B"), TopActionMenu()],
        ),
        body: TabBarView(
          children: [
            PersonalChoreList(chores: data.personalChores),
            ChoreList(
              chores: data.chores..sortByDue(),
              scrollable: true,
            ),
          ],
        ), // only show personal chores
        bottomNavigationBar: const MyNavigationBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ChoreEditDialog(chore: null);
                },
              );
            },
            child: const Icon(Icons.add)),
      ),
    );
  }
}

class PersonalChoreList extends StatelessWidget {
  final List<Chore> chores;
  const PersonalChoreList({super.key, required this.chores});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: chores.isEmpty
          ? const Center(child: Text("Congrats, all your chores are done!"))
          : ImplicitlyAnimatedList<Chore>(
              items: chores,
              itemBuilder: (context, animation, item, i) {
                return SizeFadeTransition(
                  animation: animation,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChoreDetail(chore: item),
                    ),
                  ),
                );
              },
              areItemsTheSame: (oldItem, newItem) =>
                  oldItem.name == newItem.name,
            ),
    );
  }
}
