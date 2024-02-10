import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/repository/todo_repository.dart';
import 'package:todo/views/theme/text_style.dart';

class TodoController extends GetxController{

  final TodoRepo _repo = TodoRepo();

  RxBool loading = RxBool(true);

  final RxList<Todo> todos = RxList();

  @override
  void onInit() {
    super.onInit();
    _repo.todosStream().then((steam) => steam.listen((event) {
      if(event.docs.isNotEmpty){
        final items = List<Todo>.from(event.docs.map((e) => Todo.fromJson(e.data() as Map<String, dynamic>)));
        items.sort((b,a) => a.createdAt.compareTo(b.createdAt));
        todos(items);
      }
      loading(false);
    }));
  }

  Future<void> addTodo(String todo) async => await _repo.addTodo(todo);

  Future<void> updateTodo(Todo todo) async => await _repo.editTodo(todo);

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
          onPressed: (){
            Get.back();
            Get.back();
            _repo.deleteTodo(todo);
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