import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatelessWidget {
  final bool scrollable;
  final List<Chore> chores;
  const ChoreList({super.key, required this.chores, required this.scrollable});

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList(
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      items: chores,
      shrinkWrap: true,
      itemBuilder: (context, animation, item, i) {
        return SizeFadeTransition(
          key: ValueKey(item.hashCode),
          animation: animation,
          child: ChoreTile(chore: item),
        );
      },
      areItemsTheSame: (oldItem, newItem) => oldItem.name == newItem.name,
    );
  }
}
