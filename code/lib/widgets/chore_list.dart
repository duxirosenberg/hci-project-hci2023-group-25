import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatelessWidget {
  final List<Chore> chores;
  const ChoreList({super.key, required this.chores});

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList(
      items: chores,
      shrinkWrap: true,
      itemBuilder: (context, animation, item, i) {
        return SizeFadeTransition(
          animation: animation,
          child: ChoreTile(chore: item),
        );
      },
      areItemsTheSame: (oldItem, newItem) => oldItem.name == newItem.name,
    );
  }
}
