import 'package:chore_manager/data_provider.dart';
import 'package:chore_manager/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chore Manager'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
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

class ChoreList extends StatelessWidget {
  final GroupedChores chores;
  const ChoreList({super.key, required this.chores});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        // maybe replace with ExpansionTiles
        expansionCallback: (panelIndex, isExpanded) {
          context
              .read<DataProvider>()
              .setExpanded(chores[panelIndex].$1, isExpanded);
        },
        children: chores.map((entry) {
          return ExpansionPanel(
              isExpanded: entry.$1.expanded,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(entry.$1.name),
                );
              },
              body: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.$2.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChoreTile(chore: entry.$2[index]);
                },
              ));
        }).toList(),
      ),
    );
  }
}

class ChoreTile extends StatelessWidget {
  final Chore chore;

  const ChoreTile({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chore.name),
      subtitle: Text("Due ${chore.getDueString()}"),
      leading: chore.assignedToUser
          ? Checkbox(
              value: false,
              onChanged: (value) {
                context.read<DataProvider>().markDone(chore);
              },
            )
          : IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              padding: EdgeInsets.zero,
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserDisplay(
              small: true, user: chore.assignees[chore.currentAssignee]),
          /*IconButton(
            onPressed: () {
              context.read<DataProvider>().markDone(chore);
            },
            icon: const Icon(Icons.check),
          ),*/
        ],
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return ChoreDialog(
            chore: chore,
          );
        },
      ),
    );
  }
}

class ChoreDialog extends StatelessWidget {
  final Chore chore;
  const ChoreDialog({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chore.name),
          UserDisplay(
              user: chore.assignees[chore.currentAssignee], small: false),
        ],
      ),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Assigned to: ${chore.assignees[chore.currentAssignee]}"),
            Text("Due ${chore.getDueString()}"),
            Text("Room: ${chore.room}"),
            Text(chore.room),
            Text("Notes: ${chore.notes}"),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        chore.assignedToUser
            ? OutlinedButton(
                onPressed: () {
                  context.read<DataProvider>().markDone(chore);
                },
                child: const Text("Mark as completed"),
              )
            : OutlinedButton(
                onPressed: () {}, child: const Text("Send a reminder")),
      ],
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

class UserDisplay extends StatelessWidget {
  final bool small;
  final String user;
  const UserDisplay({super.key, required this.user, required this.small});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          child: Text(user.substring(0, 1)),
        ),
        SizedBox(
          width: 8,
        ),
        if (!small)
          Text(
            user,
            style: TextStyle(fontSize: 14),
          ),
      ],
    );
  }
}
