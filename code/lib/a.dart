import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class A extends StatelessWidget {
  final DataProvider data;
  const A({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Chore Manager'),
          bottom: const TabBar(tabs: [
            Tab(text: "Room"),
            Tab(text: "Assigned to"),
            Tab(text: "Due Date"),
          ]),
          actions: [
            PopupMenuButton(
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
            )
          ],
        ),
        body: Consumer<DataProvider>(
          builder: (context, data, child) {
            return TabBarView(
              children: [
                ChoreList(chores: data.sortByRoom),
                ChoreList(chores: data.sortByAssignee),
                ChoreList(chores: data.sortByDueDate),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)),
        bottomNavigationBar: NavigationBar(
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
        ),
      ),
    );
  }
}
