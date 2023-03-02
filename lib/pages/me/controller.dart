import 'dart:convert';

import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/common/store/store.dart';
import 'package:chat_flutter/pages/me/index.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MeController extends GetxController {
  final state = MeState();
  MeController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void onInit() {
    super.onInit();
    asyncLoadData();
    List MyList = [
      {
        "name": "Account",
        "icon": "assets/icons/1.png",
        "route": '/account',
      },
      {
        "name": "Chat",
        "icon": "assets/icons/2.png",
        "route": '/chat',
      },
      {
        "name": "Notification",
        "icon": "assets/icons/3.png",
        "route": '/notification',
      },
      {
        "name": "Privacy",
        "icon": "assets/icons/4.png",
        "route": '/privacy',
      },
      {
        "name": "Help",
        "icon": "assets/icons/5.png",
        "route": '/help',
      },
      {
        "name": "About",
        "icon": "assets/icons/6.png",
        "route": '/about',
      },
      {
        "name": "Logout",
        "icon": "assets/icons/7.png",
        "route": '/logout',
      },
    ];

    for (var i = 0; i < MyList.length; i++) {
      MeListItem result = MeListItem();
      result.icon = MyList[i]['icon'];
      result.name = MyList[i]['name'];
      result.route = MyList[i]['route'];
      state.meList.add(result);
    }
  }

  Future<void> onLogout() async {
    UserStore.to.onLogout();
    await _googleSignIn.signOut();
    Get.offAndToNamed(
      AppRoutes.SIGN_IN,
    );
  }

  asyncLoadData() async {
    String profile = await UserStore.to.getProfile();
    if (!profile.isEmpty) {
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(
        jsonDecode(profile),
      );
      state.headDetail.value = userdata;
    }
  }
}
