import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/utils/extension.dart';
import 'package:todo/views/pages/widgets/add_edit_todo_bottomsheet.dart';
import 'package:todo/views/theme/text_style.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;
  const TodoListTile(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AddEditTodoBottomSheet.open(todo),
      contentPadding: EdgeInsets.only(
        left: 14,
        right: 4
      ),
      title: Text(
        todo.todo,
        style: AppTextStyle.normal16,
      ),
      subtitle: Text(
        todo.createdAt.time
      ),
      trailing: Checkbox(
        value: todo.state == TodoState.completed,
        onChanged: (_){
          Get.find<TodoController>().updateTodo(
            todo..state = todo.state == TodoState.created ? TodoState.completed : TodoState.created
          );
        },
        activeColor: Colors.green,
      ),
    );
  }
}