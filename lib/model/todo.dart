import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';

enum TodoState{
  created,
  completed,
  deleted
}

class Todo{
  final String id;
  final String uid;
  String todo;
  List<String> editHistory;
  TodoState state;
  DateTime? reminderTime;
  bool isLocal;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Todo({
    required this.id,
    required this.uid,
    required this.todo,
    required this.state,
    required this.editHistory,
    required this.createdAt,
    required this.updatedAt,
    this.reminderTime,
    this.isLocal = false
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    uid: json['user_id'],
    todo: json['todo'],
    isLocal: json['isLocal'] ?? false,
    editHistory: List<String>.from(json['edits'].map((item) => item)),
    state: TodoState.values.firstWhere((element) => element.name == json['state']),
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    reminderTime: json['reminderTime'] == null ? null : DateTime.parse(json['reminderTime'])
  );

  factory Todo.fresh(String todo) => Todo(
    id: '${Timestamp.now().millisecondsSinceEpoch}',
    uid: Get.find<AuthController>().user.uid,
    todo: todo,
    editHistory: [],
    state: TodoState.created,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  );

  Map<String, dynamic> toJson()=>{
    'id' : id,
    'user_id' : uid,
    'todo' : todo,
    'isLocal' : isLocal,
    'edits' : editHistory,
    'state' : state.name,
    'createdAt' : createdAt,
    'updatedAt' : Timestamp.now(),
    if(reminderTime != null) 'reminderTime' : reminderTime!.toIso8601String()
  };
}

class TodoGroup{
  final String group;
  final List<Todo> todos;
  const TodoGroup({
    required this.group,
    this.todos = const []
  });
}
