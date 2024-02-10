import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/strings.dart';
import 'package:todo/views/theme/images.dart';
import 'package:todo/views/theme/text_style.dart';

class AddEditTodoBottomSheet extends StatefulWidget {
  final Todo? todo;
  const AddEditTodoBottomSheet(this.todo,{super.key});

  /// if a item is passed it is a editMode
  /// otherwise its a new one
  static Future<void> open([Todo? todo]) async => await Get.bottomSheet(
    AddEditTodoBottomSheet(todo),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )
    ),
  );

  @override
  State<AddEditTodoBottomSheet> createState() => _AddEditTodoBottomSheetState();
}

class _AddEditTodoBottomSheetState extends State<AddEditTodoBottomSheet> {
  bool get _isUpdate => widget.todo != null;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  TodoController controller = Get.find<TodoController>();

  @override
  void initState() {
    super.initState();
    if(widget.todo != null) _textEditingController.text = widget.todo!.todo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// closing keyboard when somewhere is pressed on the bottom sheet
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        /// when the keyboard is open bottom sheet will scroll to
        /// the maximum height which does not look very good
        /// for small devices
        /// so when keyboard is open adding a manual space at top to
        /// make it look nicer
        margin: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.bottom > 0 ? 80 : 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bg4),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 4,
                  top: 14
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isUpdate ? Strings.edit_todo : Strings.add_todo,
                        style: AppTextStyle.medium24.copyWith(
                          color: Colors.white
                        ),
                      ),
                    ),
                    CloseButton()
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextFormField(
                  style: AppTextStyle.normal20.copyWith(
                    color: Colors.white
                  ),
                  controller: _textEditingController,
                  maxLines: 5,
                  minLines: 2,
                  textInputAction: TextInputAction.done,
                  validator: (string){
                    if(string == null || string.isEmpty) return Strings.todo_validation_msg;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: _isUpdate ? null : Strings.todo_hint,
                    hintStyle: AppTextStyle.medium12.copyWith(
                      color: Colors.grey.shade400
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 4
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 2.2
                      )
                    ),
                  ),
                ),
              ),

              if(_isUpdate) ...[
                Center(
                  child: TextButton(
                    onPressed: (){
                      controller.deleteTodo(widget.todo!);
                    },
                    child: Text(
                      Strings.delete,
                      style: AppTextStyle.medium12.copyWith(
                        color: Colors.red
                      ),
                    )
                  ),
                ),
                SizedBox(height: 14),
              ],

              ElevatedButton(
                onPressed: (){
                  if(!_key.currentState!.validate()) return ;
                  Get.back();
                  if(_isUpdate){
                    controller.updateTodo(
                      widget.todo!
                        ..editHistory.add(widget.todo!.todo)
                        ..todo = _textEditingController.text
                    );
                  }else{
                    controller.addTodo(_textEditingController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.purple
                ),
                child: Text(
                  _isUpdate ? Strings.update : Strings.create,
                  style: AppTextStyle.normal20.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
