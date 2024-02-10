import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';

class RootBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}