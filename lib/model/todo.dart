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
  final DateTime createdAt;
  final DateTime updatedAt;

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

  @override
  operator == (Object other) => other is Todo && other.id == id;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    uid: json['user_id'],
    todo: json['todo'],
    isLocal: json['isLocal'] ?? false,
    editHistory: List<String>.from(json['edits'].map((item) => item)),
    state: TodoState.values.firstWhere((element) => element.name == json['state']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    reminderTime: json['reminderTime'] == null ? null : DateTime.parse(json['reminderTime'])
  );

  factory Todo.fresh(String todo) => Todo(
    id: '${DateTime.now().millisecondsSinceEpoch}',
    uid: Get.find<AuthController>().user.uid,
    todo: todo,
    editHistory: [],
    state: TodoState.created,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson()=>{
    'id' : id,
    'user_id' : uid,
    'todo' : todo,
    'isLocal' : isLocal,
    'edits' : editHistory,
    'state' : state.name,
    'createdAt' : createdAt.toIso8601String(),
    'updatedAt' : DateTime.now().toIso8601String(),
    if(reminderTime != null) 'reminderTime' : reminderTime!.toIso8601String()
  };

  @override
  int get hashCode => super.hashCode;
}

class TodoGroup{
  final String group;
  final List<Todo> todos;
  const TodoGroup({
    required this.group,
    this.todos = const []
  });
}
