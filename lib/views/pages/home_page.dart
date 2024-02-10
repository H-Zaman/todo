import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/strings.dart';
import 'package:todo/views/pages/widgets/add_edit_todo_bottomsheet.dart';
import 'package:todo/views/pages/widgets/loader.dart';
import 'package:todo/views/pages/widgets/todo_list_tile.dart';
import 'package:todo/views/theme/images.dart';
import 'package:todo/views/theme/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();
  TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImages.bg5,
            fit: BoxFit.fitHeight,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          /// resizing based on if there are any items
          /// if there are items and the [AddEditTodoBottomSheet] opens
          /// it does not look nice when the UI is resizing because of the keyboard
          resizeToAvoidBottomInset: todoController.todos.isEmpty,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                foregroundImage: authController.user.photoURL == null ? null : NetworkImage(authController.user.photoURL!),
                child: Text(
                  authController.user.displayName![0].toUpperCase(),
                  style: AppTextStyle.bold24,
                ),
              ),
            ),
            title: Text(
              authController.user.displayName!,
              style: AppTextStyle.bold24,
            ),
          ),
          body: Builder(
            builder: (_){
              if(todoController.loading.value) return Loader();
              if(todoController.todos.isEmpty) return Center(
                child: Text(
                  Strings.no_todo_found,
                  style: AppTextStyle.bold24.copyWith(
                    color: Colors.white
                  ),
                ),
              );
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: todoController.todos.length,
                itemBuilder: (_, index) => TodoListTile(todoController.todos[index]),
              );
            },
          ),
          floatingActionButton: InkWell(
            onTap: AddEditTodoBottomSheet.open,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
              ),
              child: Icon(
                Icons.add_rounded,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
