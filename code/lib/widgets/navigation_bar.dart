import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 1,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.message),
          label: "Messages",
        ),
        NavigationDestination(
          icon: Icon(Icons.checklist),
          label: "Chores",
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_basket),
          label: "Shopping",
        ),
        NavigationDestination(
          icon: Icon(Icons.monetization_on),
          label: "Finances",
        ),
      ],
    );
  }
}
