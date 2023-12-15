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
    final personalChores = data.personalChores;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Chore Mate"),
          bottom: TabBar(tabs: [
            Tab(text: "Your chores (${personalChores.length})"),
            Tab(text: "All chores (${data.choreBox.length})"),
          ]),
          actions: const [Text("B"), TopActionMenu()],
        ),
        body: TabBarView(
          children: [
            PersonalChoreList(chores: personalChores),
            ChoreList(
              padding: const EdgeInsets.only(bottom: 80),
              chores: data.choreBox.values.toList()..sortByDue(),
              scrollable: true,
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: chores.isEmpty
          ? const Center(child: Text("Congrats, all your chores are done!"))
          : ImplicitlyAnimatedList<Chore>(
              padding: const EdgeInsets.only(bottom: 80),
              items: chores,
              itemBuilder: (context, animation, item, i) {
                return SizeFadeTransition(
                  animation: animation,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChoreDetail(
                          key: ValueKey(item.hashCode), chore: item),
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
