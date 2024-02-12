import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/repository/todo_repository.dart';
import 'package:todo/utils/extension.dart';
import 'package:todo/views/theme/text_style.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class TodoController extends GetxController{

  final TodoRepo _repo = TodoRepo();
  final _localNotification = FlutterLocalNotificationsPlugin();

  RxBool loading = RxBool(true);
  RxBool saveInLocalDb = RxBool(false);

  final RxList<Todo> _todos = RxList();
  final RxList<Todo> _localTodos = RxList();

  List<TodoGroup> get groups {
    List<TodoGroup> temp = [];
    for (Todo todo in [..._todos, ..._localTodos]) {
      final groupName = todo.createdAt.notificationGroupString;
      TodoGroup? group = temp.firstWhereOrNull((element) => element.group == groupName);
      if(group == null){
        temp.add(TodoGroup(
          group: groupName,
          todos: [todo]
        ));
      }else{
        final group = temp.firstWhere((element) => element.group == groupName);
        group.todos
          ..add(todo)
          ..sort((b,a) => a.createdAt.compareTo(b.createdAt));
      }
    }
    return temp;
  }

  @override
  void onInit() {
    _localNotification.initialize(InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings()
    ));
    super.onInit();
    getTodos();
    _repo.todosStream().listen((event) {
      if(event.docs.isNotEmpty){
        final items = List<Todo>.from(event.docs.map((e) => Todo.fromJson(e.data() as Map<String, dynamic>)));
        items.sort((b,a) => a.createdAt.compareTo(b.createdAt));
        _todos(items);
      }
      loading(false);
    });
  }

  Future<void> addTodo(String string, DateTime? reminderTime) async {
    Todo todo = Todo.fresh(string);
    todo
      ..isLocal = saveInLocalDb.value
      ..reminderTime = reminderTime;
    final success = await _repo.addTodo(todo);
    if(success && todo.isLocal) await getTodos();

    if(todo.reminderTime != null) await _setReminder(todo);
  }

  Future<List<Todo>> getTodos() async => _localTodos(await _repo.getLocalTodos());

  Future<void> updateTodo(Todo todo) async {
    final success = await _repo.editTodo(todo);
    if(success && todo.isLocal) await getTodos();
    if(todo.reminderTime != null) await _setReminder(todo);
  }

  Future<void> _setReminder(Todo todo) async{
    tz.initializeTimeZones();
    final location = tz.getLocation(await FlutterTimezone.getLocalTimezone());
    tz.setLocalLocation(location);
    await _localNotification.zonedSchedule(
      int.parse(todo.id.substring(4)),
      'Notes-Alarm',
      todo.todo,
      tz.TZDateTime.from(todo.reminderTime!, location),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '_notes_app_channel_id',
          '_notes_app_channel_name',
          channelDescription: '_notes_app_channel_description'
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  Future<void> deleteTodo(Todo todo) async {
    await Get.dialog(AlertDialog(
      title: Text(
        'Confirm delete'
      ),
      content: Text(
        'Are you sure?'
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            'No',
            style: AppTextStyle.medium12.copyWith(
              color: Colors.black
            ),
          )
        ),
        TextButton(
          onPressed: () async{
            Get.back();
            Get.back();
            final success = await _repo.deleteTodo(todo);
            if(success && todo.isLocal) await getTodos();
          },
          child: Text(
            'Yes',
            style: AppTextStyle.medium12.copyWith(
              color: Colors.red
            ),
          )
        )
      ],
    ));
  }
}