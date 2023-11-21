import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:chore_manager/widgets/popup_actions.dart';
import 'package:flutter/material.dart';

class B extends StatelessWidget {
  final DataProvider data;
  const B({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Chore Manager - B"),
        actions: const [TopActionMenu()],
      ),
      body: PersonalChoreList(
          chores: data.personalChores), // only show personal chores
    );
  }
}

class PersonalChoreList extends StatelessWidget {
  final List<Chore> chores;
  const PersonalChoreList({super.key, required this.chores});

  @override
  Widget build(BuildContext context) {
    // maybe replace with animated list
    return ListView.builder(
      itemCount: chores.length,
      itemBuilder: (context, index) {
        return ChoreDetail(chore: chores[index]);
      },
    );
  }
}
