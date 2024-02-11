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
      title: Stack(
        children: [
          Text(
            todo.todo,
            style: AppTextStyle.normal16.copyWith(
              color: todo.state == TodoState.completed ? Colors.green : Colors.black,
              decoration: todo.state == TodoState.completed ? TextDecoration.lineThrough : null,
              decorationColor: todo.state == TodoState.completed ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
      subtitle: RichText(
        text: TextSpan(
          text: todo.createdAt.time,
          style: AppTextStyle.normal14.copyWith(
            color: Colors.grey.shade600
          ),
          children: [
            if(todo.isLocal) ...[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.storage_rounded,
                    size: 16,
                  ),
                )
              )
            ]
          ]
        ),
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