import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/dialogs.dart';
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
            onTap: () async {
              final res = await showDialog(
                context: context,
                builder: (context) => const ConfirmDialog(
                  title: "Reset App?",
                  infoText:
                      "This means that all your changes are undone and the app is restored to its initial state.",
                  confirmText: "Reset",
                ),
              );

              if ((res ?? false) && context.mounted) {
                context.read<DataProvider>().resetApp();
              }
            },
          ),
        ];
      },
    );
  }
}
