import 'package:chat_flutter/pages/application/controller.dart';
import 'package:chat_flutter/pages/chat/index.dart';
import 'package:chat_flutter/pages/contact/index.dart';
import 'package:chat_flutter/pages/me/index.dart';
import 'package:get/get.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(
      () => ApplicationController(),
    );
    Get.lazyPut<ContactController>(
      () => ContactController(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
    Get.lazyPut<MeController>(
      () => MeController(),
    );
  }
}
