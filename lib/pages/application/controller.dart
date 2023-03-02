import 'dart:convert';

import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/store/store.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/application/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final db = FirebaseFirestore.instance;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  @override
  void onInit() {
    super.onInit();
    tabTitles = [
      'Chats',
      'Contacts',
      'Profile',
    ];
    bottomTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.message,
          color: AppColors.secondaryElementText,
        ),
        label: 'Chats',
        backgroundColor: AppColors.primaryBackground,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.contact_page,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.contact_page,
          color: AppColors.secondaryElementText,
        ),
        label: 'Contacts',
        backgroundColor: AppColors.primaryBackground,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.person,
          color: AppColors.secondaryElementText,
        ),
        label: 'Profile',
        backgroundColor: AppColors.primaryBackground,
      ),
    ];
    pageController = PageController(
      initialPage: state.pages,
    );
    getToken();
  }

  void getToken() async {
    String? token = await messaging.getToken();
    print('token: $token');
    String profile = await UserStore.to.getProfile();
    if (!profile.isEmpty) {
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(
        jsonDecode(profile),
      );
      final data = UserData(
        id: userdata.accessToken,
        name: userdata.displayName,
        email: userdata.email,
        photourl: userdata.photoUrl,
        fcmtoken: token,
        addtime: Timestamp.now(),
      );
      var documentID;
      var collection = FirebaseFirestore.instance
          .collection('users')
          .where("id", isEqualTo: userdata.accessToken);
      var querySnapshots = await collection.get();
      for (var snapshot in querySnapshots.docs) {
        documentID = snapshot.id; // <-- Document ID
      }
      if (documentID != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(documentID)
            .update(data.toFirestore());
      }
    }
  }

  void handlePageChanged(int index) {
    state.pages = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
