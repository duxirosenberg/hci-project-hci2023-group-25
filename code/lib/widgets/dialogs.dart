import 'package:chore_manager/core/classes.dart';
import 'package:chore_manager/core/utils.dart';
import 'package:chore_manager/data/data_provider.dart';
import 'package:chore_manager/widgets/chore_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: SingleChildScrollView(
              child: ChoreDetail(
            chore: chore,
            dialog: true,
          ))),
    );
  }
}

class ChoreEditDialog extends StatefulWidget {
  final Chore? chore;
  final bool onDeletePopTwice; // needed if choredetail is open in dialog

  ChoreEditDialog(
      {super.key, required this.chore, required this.onDeletePopTwice})
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
                      // if editing chore, simply keeps the currentIndex as long as theres no overflow.
                      // this leads to weird behaviour when the order was changed, but otherwise quite a pain
                      indexOfCurrentAssignee:
                          widget.chore?.indexOfCurrentAssignee ??
                              0 %
                                  (widget._assignees.isEmpty
                                      ? 1
                                      : widget._assignees.length),
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

                    Navigator.pop(context, newChore);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    DropdownMenu(
                      requestFocusOnTap: false,
                      width: MediaQuery.of(context).size.width - 32,
                      label: const Text("Room"),
                      initialSelection: room,
                      dropdownMenuEntries: data.roomBox.values
                          .map((room) => DropdownMenuEntry(
                              value: room.name, label: room.name))
                          .toList(),
                      onSelected: (value) => room = value!,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateFieldController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              label: Text("Due Date"),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_month),
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: MyDateUtils.today(),
                                firstDate: MyDateUtils.today(),
                                lastDate: DateTime(2050),
                              );

                              if (date != null) {
                                dateFieldController.text =
                                    date.toFormatString();
                                dueDate = date;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: frequency.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              label: Text("Repeat"),
                              border: OutlineInputBorder(),
                              prefixText: "every ",
                              suffixText: " days",
                            ),
                            onSaved: (newValue) =>
                                frequency = int.parse(newValue ?? ""),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: notes,
                      minLines: 3,
                      maxLines: null,
                      decoration: const InputDecoration(
                        label: Text("Notes"),
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (newValue) {
                        if (newValue == null || newValue.trim() == "") {
                          notes = null;
                        } else {
                          notes = newValue.trim();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Text("Assignees",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: data.userBox.values
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
                    const SizedBox(height: 12),
                    if (widget._assignees.length >= 2) ...[
                      Text("In which order?",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
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
                    ],
                    if (widget.chore != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red)),
                          onPressed: () async {
                            final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmDialog(
                                title: "Delete Chore?",
                                confirmText: "Delete",
                              ),
                            );
                            if ((res ?? false) && context.mounted) {
                              context
                                  .read<DataProvider>()
                                  .deleteChore(widget.chore!);
                              Navigator.pop(context);
                              if (widget.onDeletePopTwice) {
                                Navigator.pop(context);
                              }
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("\"${widget.chore!.name}\" deleted"),
                              ));
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Delete"),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  const ConfirmDialog(
      {super.key, required this.title, required this.confirmText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: const Text("This action cannot be undone."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(confirmText)),
      ],
    );
  }
}
