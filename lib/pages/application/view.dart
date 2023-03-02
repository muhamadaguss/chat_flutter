import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/application/index.dart';
import 'package:chat_flutter/pages/chat/index.dart';
import 'package:chat_flutter/pages/contact/index.dart';
import 'package:chat_flutter/pages/me/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildPageView() {
      return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handlePageChanged,
        children: [
          ChatPage(),
          ContactPage(),
          MePage(),
        ],
      );
    }

    Widget _buildBottomNavigationBar() {
      return Obx(
        () => BottomNavigationBar(
          items: controller.bottomTabs,
          currentIndex: controller.state.pages,
          type: BottomNavigationBarType.fixed,
          onTap: controller.handleNavBarTap,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: AppColors.tabBarElement,
          selectedItemColor: AppColors.thirdElementText,
        ),
      );
    }

    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
