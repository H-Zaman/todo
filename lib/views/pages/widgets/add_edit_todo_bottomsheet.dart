import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/strings.dart';
import 'package:todo/utils/extension.dart';
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
    if(widget.todo != null) {
      _textEditingController.text = widget.todo!.todo;
      reminderTime = widget.todo!.reminderTime;
    }
  }

  DateTime? reminderTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// closing keyboard when somewhere is pressed on the bottom sheet
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        margin: EdgeInsets.only(top: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 4,
                  top: 14
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 32),
                    Center(
                      child: Text(
                        _isUpdate ? Strings.edit_note : Strings.add_note,
                        style: AppTextStyle.medium24
                      ),
                    ),
                    CloseButton()
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextFormField(
                  style: AppTextStyle.normal16,
                  controller: _textEditingController,
                  maxLines: 10,
                  minLines: 5,
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
                  ),
                ),
              ),

              ListTile(
                onTap: () async{
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: reminderTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if(pickedDate == null) return ;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: reminderTime == null ? TimeOfDay.now() : TimeOfDay(hour: reminderTime!.hour, minute: reminderTime!.minute),
                  );

                  if(pickedTime == null) return ;

                  setState(() {
                    reminderTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                },
                leading: Icon(
                  CupertinoIcons.bell,
                  color: reminderTime == null ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  reminderTime == null ? 'Set reminder' : reminderTime!.time,
                  style: TextStyle(
                    color: reminderTime == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),

              /// making sure no duplicates are created
              /// by changing from local/firebase
              /// maybe allow sync in a later version
              if(!_isUpdate) Obx(()=>SwitchListTile(
                value: controller.saveInLocalDb.value,
                onChanged: controller.saveInLocalDb,
                title: Text(
                  Strings.save_note_in_local,
                  style: TextStyle(
                    color: controller.saveInLocalDb.value ? Colors.black : Colors.grey
                  ),
                ),
                secondary: Icon(
                  Icons.storage_rounded,
                  color: controller.saveInLocalDb.value ? Colors.blue : Colors.grey,
                ),
              )),

              Spacer(),
              if(_isUpdate) ...[
                ElevatedButton(
                  onPressed: (){
                    controller.deleteTodo(widget.todo!);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.red
                  ),
                  child: Text(
                    Strings.delete,
                    style: AppTextStyle.normal20.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2
                    ),
                  )
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
                        ..reminderTime = reminderTime
                        ..todo = _textEditingController.text
                    );
                  }else{
                    controller.addTodo(_textEditingController.text, reminderTime);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue
                ),
                child: Text(
                  _isUpdate ? Strings.update : Strings.create,
                  style: AppTextStyle.normal20.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
