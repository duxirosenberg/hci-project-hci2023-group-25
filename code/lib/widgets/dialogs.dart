import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:flutter/material.dart';

class ChoreDialog extends StatelessWidget {
  final Chore chore;
  const ChoreDialog({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      content: SizedBox(
          width: 800,
          child: SingleChildScrollView(child: ChoreDetail(chore: chore))),
    );
  }
}

class ChoreEditDialog extends StatelessWidget {
  const ChoreEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
