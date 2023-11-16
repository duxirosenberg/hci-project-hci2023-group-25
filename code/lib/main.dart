import 'package:chore_manager/classes.dart';
import 'package:chore_manager/data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chore Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(text: "Room"),
            Tab(text: "Assigned to"),
            Tab(text: "Due Date"),
          ]),
        ),
        body: TabBarView(
          children: [
            ChoreList(chores: sortByRoom()),
            ChoreList(chores: sortByAssignee()),
            Container(),
          ],
        ),
      ),
    );
  }
}

class ChoreList extends StatefulWidget {
  final GroupedChores chores;
  const ChoreList({super.key, required this.chores});

  @override
  State<ChoreList> createState() => _ChoreListState();
}

class _ChoreListState extends State<ChoreList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            // will probably cause error when new chore added?
            widget.chores[panelIndex].$1.expanded = isExpanded;
          });
        },
        children: widget.chores.map((entry) {
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
    );
  }
}
