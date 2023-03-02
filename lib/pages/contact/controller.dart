import 'dart:convert';

import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/common/store/store.dart';
import 'package:chat_flutter/pages/contact/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final state = ContactState();
  ContactController();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData userData) async {
    var fromMessage = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where('from_uid', isEqualTo: token)
        .where(
          'to_uid',
          isEqualTo: userData.id,
        )
        .get();

    var toMessage = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where('from_uid', isEqualTo: userData.id)
        .where(
          'to_uid',
          isEqualTo: token,
        )
        .get();
    String profile = await UserStore.to.getProfile();
    UserLoginResponseEntity userLoginResponseEntity =
        UserLoginResponseEntity.fromJson(
      jsonDecode(profile),
    );
    if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
      var msgData = Msg(
        from_uid: userLoginResponseEntity.accessToken,
        to_uid: userData.id,
        from_name: userLoginResponseEntity.displayName,
        to_name: userData.name,
        from_avatar: userLoginResponseEntity.photoUrl,
        to_avatar: userData.photourl,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      await db
          .collection('message')
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          )
          .add(msgData)
          .then((value) {
        Get.toNamed(AppRoutes.Message, parameters: {
          "doc_id": value.id,
          "to_uid": userData.id ?? "",
          "to_name": userData.name ?? "",
          "to_avatar": userData.photourl ?? "",
          "from_uid": userLoginResponseEntity.accessToken ?? "",
          "from_name": userLoginResponseEntity.displayName ?? "",
          "from_avatar": userLoginResponseEntity.photoUrl ?? "",
        });
      });
    } else {
      if (fromMessage.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Message, parameters: {
          "doc_id": fromMessage.docs.first.id,
          "to_uid": userData.id ?? "",
          "to_name": userData.name ?? "",
          "to_avatar": userData.photourl ?? "",
          "from_uid": userLoginResponseEntity.accessToken ?? "",
          "from_name": userLoginResponseEntity.displayName ?? "",
          "from_avatar": userLoginResponseEntity.photoUrl ?? "",
        });
      }
      if (toMessage.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Message, parameters: {
          "doc_id": toMessage.docs.first.id,
          "to_uid": userData.id ?? "",
          "to_name": userData.name ?? "",
          "to_avatar": userData.photourl ?? "",
          "from_uid": userLoginResponseEntity.accessToken ?? "",
          "from_name": userLoginResponseEntity.displayName ?? "",
          "from_avatar": userLoginResponseEntity.photoUrl ?? "",
        });
      }
    }
  }

  asyncLoadAllData() async {
    var usersBase = await db
        .collection('users')
        .where("id", isNotEqualTo: token)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, options) => userData.toFirestore(),
        )
        .get();

    for (var doc in usersBase.docs) {
      state.contactList.add(
        doc.data(),
      );
      print(
        doc.toString(),
      );
    }
  }
}
