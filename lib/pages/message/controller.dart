import 'dart:convert';
import 'dart:io';

import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/store/store.dart';
import 'package:chat_flutter/common/utils/security.dart';
import 'package:chat_flutter/pages/message/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class MessageController extends GetxController {
  final state = MessageState();
  MessageController();
  var docId = null;
  final textEditingController = TextEditingController();
  ScrollController msgController = ScrollController();
  FocusNode focusNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    var data = Get.parameters;
    docId = data['doc_id'];
    state.toUid.value = data['to_uid'] ?? "";
    state.toName.value = data['to_name'] ?? "";
    state.toAvatar.value = data['to_avatar'] ?? "";
    state.fromUid.value = data['from_uid'] ?? "";
    state.fromName.value = data['from_name'] ?? "";
    state.fromAvatar.value = data['from_avatar'] ?? "";
    super.onInit();
  }

  sendImageMessage(String url) async {
    var msg = Msgcontent(
      uid: user_id,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );
    await db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .add(msg)
        .then((DocumentReference documentReference) {
      print('Document added with ID: ${documentReference.id}');
      textEditingController.clear();
      Get.focusScope?.unfocus();
    });

    await db.collection('message').doc(docId).update({
      'last_msg': '[ image  ]',
      'last_time': Timestamp.now(),
    });
  }

  Future imagePicker(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      uploadImage();
    } else {
      print('file not selected');
    }
  }

  Future getImageUrl(String url) async {
    final spaceRef = FirebaseStorage.instance.ref('chat').child(url);
    var str = await spaceRef.getDownloadURL();
    return str ?? '';
  }

  Future? uploadImage() async {
    if (imageFile == null) return null;
    final fileName = getRandomString(15) + p.extension(imageFile!.path);

    try {
      final ref = FirebaseStorage.instance.ref('chat').child(fileName);
      await ref.putFile(imageFile!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.success:
            String url = await getImageUrl(fileName);
            sendImageMessage(url);
            break;
          case TaskState.error:
            break;
          case TaskState.canceled:
            break;
        }
      });
    } catch (e) {
      print("uploadImage error: $e");
    }
  }

  sendMessage(String value) async {
    // String msgContent = textEditingController.text;
    String msgContent = value;
    final content = Msgcontent(
      content: msgContent,
      addtime: Timestamp.now(),
      type: 'text',
      uid: user_id,
    );

    await db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .add(content)
        .then((DocumentReference documentReference) {
      print('Document added with ID: ${documentReference.id}');
      textEditingController.clear();
      Get.focusScope?.unfocus();
    });

    await db.collection('message').doc(docId).update({
      'last_msg': msgContent,
      'last_time': Timestamp.now(),
    });

    var userBase = await db
        .collection('users')
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where(
          'id',
          isEqualTo: state.toUid.value,
        )
        .get();

    if (userBase.docs.isNotEmpty) {
      var fcm = userBase.docs[0].data().fcmtoken;
      sendFcm(fcm!, state.fromName.value, msgContent);
    }
  }

  void sendFcm(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":
              "key=AAAAKHenWeQ:APA91bF_-vz0xAAPlBwqAZ-TbzL37w_666GRj2sMR-tOgkRAJrGSl4mr1raXoB9BOSZA0Sk5oH28-5mFegcD1HbFrUIshWuxhAuGl8qNvbdYPJNY9MyGNOCiwjleJ7oLTBwzYrzS5A20",
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'normal',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'data': <String, dynamic>{
                'screen': 'chat',
                'doc_id': docId,
                'to_uid': state.toUid.value,
                'to_name': state.toName.value,
                'to_avatar': state.toAvatar.value,
                'from_uid': state.fromUid.value,
                'from_name': state.fromName.value,
                'from_avatar': state.fromAvatar.value,
              }
            },
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'android_channel_id': 'chat_flutter',
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void onReady() {
    super.onReady();
    var messages = db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .orderBy(
          "addtime",
          descending: false,
        );
    state.msgContentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var item in event.docChanges) {
        switch (item.type) {
          case DocumentChangeType.added:
            if (item.doc.data() != null) {
              state.msgContentList.insert(0, item.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (e) {
      print('error: $e');
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    listener.cancel();
    super.dispose();
  }
}
