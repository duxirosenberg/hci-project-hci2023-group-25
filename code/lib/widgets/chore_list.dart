import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatelessWidget {
  final List<Chore> chores;
  const ChoreList({super.key, required this.chores});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chores.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ChoreTile(chore: chores[index]);
      },
    );
  }
}
