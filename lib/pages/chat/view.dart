import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/common/widgets/app.dart';
import 'package:chat_flutter/pages/chat/index.dart';
import 'package:chat_flutter/pages/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar _buildAppBar() {
      return transparentAppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: ChatList(),
    );
  }
}
