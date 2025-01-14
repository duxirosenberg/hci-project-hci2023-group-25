import 'package:chore_manager/a.dart';
import 'package:chore_manager/b.dart';
import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ChoreAdapter());
  Hive.registerAdapter(IconAdapter());
  Hive.registerAdapter<Room>(RoomAdapter());
  Hive.registerAdapter<User>(UserAdapter());

  await Hive.openBox("settings");
  await Hive.openBox<Chore>("chores");
  await Hive.openBox<Room>("rooms");
  await Hive.openBox<User>("users");

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
      title: 'Flat Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade100)),
      home: const MyHomePage(title: 'Chore Manager'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        return data.altMode ? B(data: data) : A(data: data);
      },
    );
  }
}
