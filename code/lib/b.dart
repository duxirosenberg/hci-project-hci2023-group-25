import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_list.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:chore_manager/widgets/navigation_bar.dart';
import 'package:chore_manager/widgets/popup_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            ChoreList(chores: data.chores..sortByDue()),
          ],
        ), // only show personal chores
        bottomNavigationBar: const MyNavigationBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)),
      ),
    );
  }
}

class PersonalChoreList extends StatelessWidget {
  final List<Chore> chores;
  const PersonalChoreList({super.key, required this.chores});

  @override
  Widget build(BuildContext context) {
    // maybe replace with animated list
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: chores.isEmpty
          ? Center(child: Text("Congrats, all your chores are done!"))
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 90),
              itemCount: chores.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChoreDetail(chore: chores[index]),
                    ));
              },
            ),
    );
  }
}

class AllChoresPage extends StatelessWidget {
  const AllChoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        final chores = data.chores..sortByDue();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("All chores"),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: ChoreList(chores: chores),
          ),
        );
      },
    );
  }
}
