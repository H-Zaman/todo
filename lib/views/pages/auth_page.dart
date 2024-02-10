import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/strings.dart';
import 'package:todo/views/pages/widgets/loader.dart';
import 'package:todo/views/theme/icons.dart';
import 'package:todo/views/theme/images.dart';
import 'package:todo/views/theme/text_style.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImages.bg1,
            fit: BoxFit.fitHeight,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.loginHeader,
                  style: AppTextStyle.bold48,
                ),
                SizedBox(height: 24),
                Obx((){
                  if(controller.loading.value) return Loader();
                  return ElevatedButton.icon(
                    onPressed: controller.googleAuth,
                    icon: Image.asset(
                      AppIcons.google_icon,
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      Strings.sign_in,
                      style: AppTextStyle.medium24.copyWith(
                        color: Colors.black
                      ),
                    )
                  );
                })
              ],
            ),
          ),
        ),
      ],
    );
  }
}

