import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/utils/extension.dart';
import 'package:todo/views/pages/widgets/add_edit_todo_bottomsheet.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;
  const TodoListTile(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.find<TodoController>().updateTodo(
          todo..state = todo.state == TodoState.created ? TodoState.completed : TodoState.created
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: IgnorePointer(
        ignoring: true,
        child: Radio(
          groupValue: TodoState.completed,
          value: todo.state,
          onChanged: (_){},
        ),
      ),
      title: Text(
        todo.todo
      ),
      subtitle: Text(
        todo.createdAt.time
      ),
      trailing: IconButton(
        constraints: BoxConstraints(),
        onPressed: () => AddEditTodoBottomSheet.open(todo),
        icon: Icon(
          Icons.edit
        )
      )
    );
  }
}