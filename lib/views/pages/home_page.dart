import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/strings.dart';
import 'package:todo/views/pages/widgets/add_edit_todo_bottomsheet.dart';
import 'package:todo/views/pages/widgets/loader.dart';
import 'package:todo/views/pages/widgets/todo_list_tile.dart';
import 'package:todo/views/theme/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();
  TodoController todoController = Get.put(TodoController());

  final ScrollController _scrollController = ScrollController();
  RxBool appBarMinimized = RxBool(false);

  final double _expandedAppbarHeight = 300;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      /// [_expandedAppbarHeight-20] safety offset
      if(_scrollController.offset > ((_expandedAppbarHeight-20) - AppBar().preferredSize.height + MediaQuery.of(context).padding.top)){
        appBarMinimized.value = (true);
      }else{
        appBarMinimized.value = (false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      backgroundColor: Colors.white,
      body: todoController.loading.value ? Loader() : CustomScrollView(
        controller: _scrollController,
        slivers: [

          SliverAppBar(
            backgroundColor: Colors.blue,
            expandedHeight: _expandedAppbarHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            Strings.welcome,
                            style: AppTextStyle.bold32.copyWith(
                              color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4
                            )
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            foregroundImage: authController.user.photoURL == null ? null : NetworkImage(authController.user.photoURL!),
                            child: Text(
                              authController.user.displayName![0].toUpperCase(),
                              style: AppTextStyle.bold24,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      authController.user.displayName!,
                      style: AppTextStyle.bold32.copyWith(
                        color: Colors.white
                      )
                    )
                  ],
                ),
              ),
            ),
            actions: [
              if(appBarMinimized.value) Row(
                children: [
                  Text(
                    authController.user.displayName!,
                    style: AppTextStyle.normal16.copyWith(
                      color: Colors.white
                    )
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2
                      )
                    ),
                    child: CircleAvatar(
                      foregroundImage: authController.user.photoURL == null ? null : NetworkImage(authController.user.photoURL!),
                      child: Text(
                      authController.user.displayName![0].toUpperCase(),
                      style: AppTextStyle.bold24,
                      )
                    ),
                  ),
                  SizedBox(width: 12)
                ],
              )
            ],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
            ),
          ),
          if(todoController.groups.isEmpty) SliverFillRemaining(
            child: Center(
              child: Text(
                Strings.no_notes_found,
                style: AppTextStyle.bold24
              ),
            ),
          ),

          ...todoController.groups.map((group) => SliverStickyHeader(
            header: Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 12,
                top: 10,
                bottom: 4
              ),
              child: Text(
                group.group,
                style: AppTextStyle.normal12.copyWith(
                  color: Colors.grey
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, i) => TodoListTile(group.todos[i]),
                childCount: group.todos.length,
              ),
            ),
          )).toList()
        ]
      ),
      floatingActionButton: InkWell(
        onTap: AddEditTodoBottomSheet.open,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.85),
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
    ));
  }
}