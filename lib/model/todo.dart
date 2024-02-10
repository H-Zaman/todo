import 'package:cloud_firestore/cloud_firestore.dart';

enum TodoState{
  created,
  completed,
  deleted
}

class Todo{
  final String id;
  String todo;
  TodoState state;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Todo({
    required this.id,
    required this.todo,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    todo: json['todo'],
    state: TodoState.values.firstWhere((element) => element.name == json['state']),
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  factory Todo.fresh(String todo) => Todo(
    id: '${Timestamp.now().millisecondsSinceEpoch}',
    todo: todo,
    state: TodoState.created,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  );

  Map<String, dynamic> toJson()=>{
    'id' : id,
    'todo' : todo,
    'state' : state.name,
    'createdAt' : createdAt,
    'updatedAt' : Timestamp.now(),
  };
}