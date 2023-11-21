import 'package:chore_manager/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopActionMenu extends StatelessWidget {
  const TopActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text("Switch A/B"),
            onTap: () => context.read<DataProvider>().switchMode(),
          ),
          PopupMenuItem(
            child: const Text("Reset App"),
            onTap: () => context.read<DataProvider>().resetApp(),
          ),
        ];
      },
    );
  }
}
