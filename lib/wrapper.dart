import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/views/pages/auth_page.dart';
import 'package:todo/views/pages/home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Obx(() {
        if(controller.isLoggedIn) return HomePage();
        return AuthPage();
      },
    );
  }
}
