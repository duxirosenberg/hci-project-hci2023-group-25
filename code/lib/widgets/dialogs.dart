import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/core/utils.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class ChoreEditDialog extends StatefulWidget {
  final Chore? chore;
  ChoreEditDialog({super.key, required this.chore})
      : _assignees = chore?.assignees ?? [];
  final List<String> _assignees;

  @override
  State<ChoreEditDialog> createState() => _ChoreEditDialogState();
}

class _ChoreEditDialogState extends State<ChoreEditDialog> {
  final formKey = GlobalKey<FormState>();
  late String name;
  late String? notes;
  late String room;
  late DateTime dueDate;
  late TextEditingController dateFieldController;
  late int frequency;

  @override
  void initState() {
    name = widget.chore?.name ?? "";
    notes = widget.chore?.notes;
    room = widget.chore?.room ?? "General";
    dueDate = widget.chore?.dueDate ?? MyDateUtils.today();
    dateFieldController = TextEditingController(
        text: widget.chore?.dueDate.toFormatString() ??
            MyDateUtils.today().toFormatString());
    frequency = widget.chore?.frequency ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, child) {
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.chore == null ? "New chore" : "Edit chore"),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    final newChore = Chore(
                      assignees: widget._assignees,
                      indexOfCurrentAssignee: 0,
                      name: name,
                      dueDate: dueDate,
                      frequency: frequency,
                      room: room,
                      notes: notes,
                    );

                    if (widget.chore == null) {
                      data.addChore(newChore);
                    } else {
                      data.updateChore(widget.chore!, newChore);
                    }

                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        label: Text("Name"),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value == "" ? "Required" : null,
                      onSaved: (newValue) => name = newValue!,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      initialValue: notes,
                      minLines: 3,
                      maxLines: null,
                      decoration: const InputDecoration(
                        label: Text("Notes"),
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (newValue) => notes = newValue,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DropdownMenu(
                      width: MediaQuery.of(context).size.width - 32,
                      label: const Text("Room"),
                      initialSelection: room,
                      dropdownMenuEntries: data.rooms
                          .map((room) => DropdownMenuEntry(
                              value: room.name, label: room.name))
                          .toList(),
                      onSelected: (value) => room = value!,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: dateFieldController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text("Due Date"),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: MyDateUtils.today(),
                          firstDate: MyDateUtils.today(),
                          lastDate: DateTime(2050),
                        );

                        if (date != null) {
                          dateFieldController.text = date.toFormatString();
                          dueDate = date;
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Text("Assignees",
                        style: Theme.of(context).textTheme.titleLarge),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: data.users
                          .map(
                            (user) => FilterChip(
                              showCheckmark: false,
                              shape: const StadiumBorder(),
                              labelPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              avatar: UserDisplay(user: user.name, small: true),
                              label: Text(user.name),
                              selected: widget._assignees.contains(user.name),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    widget._assignees.add(user.name);
                                  } else {
                                    widget._assignees.remove(user.name);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    if (widget._assignees.length >= 2) ...[
                      Text("In which order?",
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(
                        height: 40,
                        child: ReorderableListView(
                          buildDefaultDragHandles: false,
                          scrollDirection: Axis.horizontal,
                          children: widget._assignees
                              .mapIndexed((index, user) => Padding(
                                    key: Key(user),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: ReorderableDelayedDragStartListener(
                                      index: index,
                                      child:
                                          UserDisplay(user: user, small: true),
                                    ),
                                  ))
                              .toList(),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final String item =
                                  widget._assignees.removeAt(oldIndex);
                              widget._assignees.insert(newIndex, item);
                            });
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
