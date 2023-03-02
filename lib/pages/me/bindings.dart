import 'package:chat_flutter/pages/me/controller.dart';
import 'package:get/get.dart';

class MeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeController>(
      () => MeController(),
    );
  }
}
