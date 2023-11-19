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
        ),
        body: Consumer<DataProvider>(
          builder: (context, data, child) {
            return TabBarView(
              children: [
                ChoreList(chores: data.sortByRoom),
                ChoreList(chores: data.sortByAssignee),
                Container(),
              ],
            );
          },
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
      trailing: IconButton(
        onPressed: () {
          context.read<DataProvider>().markDone(chore);
        },
        icon: const Icon(Icons.check),
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
      title: Text(chore.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Assigned to: ${chore.assignees[chore.currentAssignee]}"),
          Text("Due by: ${chore.getDueString()}"),
          Text("Room: ${chore.room}"),
          Text("Notes: ${chore.notes}"),
          Text(chore.room)
        ],
      ),
    );
  }
}
