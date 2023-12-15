// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChoreAdapter extends TypeAdapter<Chore> {
  @override
  final int typeId = 0;

  @override
  Chore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chore(
      assignees: (fields[1] as List).cast<String>(),
      indexOfCurrentAssignee: fields[2] as int,
      name: fields[0] as String,
      dueDate: fields[4] as DateTime,
      frequency: fields[5] as int,
      room: fields[3] as String,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Chore obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.assignees)
      ..writeByte(2)
      ..write(obj.indexOfCurrentAssignee)
      ..writeByte(3)
      ..write(obj.room)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChoreGroupAdapter extends TypeAdapter<ChoreGroup> {
  @override
  final int typeId = 1;

  @override
  ChoreGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChoreGroup(
      fields[0] as String,
      icon: fields[2] as IconData?,
    )..expanded = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, ChoreGroup obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.expanded)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoreGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final int typeId = 2;

  @override
  Room read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      fields[0] as String,
      icon: fields[2] as IconData?,
    )..expanded = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.expanded)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as String,
      icon: fields[2] as IconData?,
    )..expanded = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.expanded)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
