import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/common/store/store.dart';
import 'package:chat_flutter/pages/chat/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatController extends GetxController {
  final state = ChatState();
  ChatController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  var to_uid = '';
  var to_avatar = '';
  var to_name = '';
  var from_uid = '';
  var from_avatar = '';
  var from_name = '';

  // @override
  // void onInit() {
  //   refreshController = RefreshController(
  //     initialRefresh: true,
  //   );
  //   super.onInit();
  // }

  // @override
  // void dispose() {
  //   refreshController.dispose();
  //   super.dispose();
  // }

  void onRefresh() {
    asyncLoadAllData().then((value) {
      refreshController.refreshCompleted(
          // resetFooterState: true,
          );
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((value) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  goChat(QueryDocumentSnapshot<Msg> item) async {
    refreshController = RefreshController(
      initialRefresh: false,
    );
    if (item.data().from_uid == token) {
      to_uid = item.data().to_uid ?? '';
      to_avatar = item.data().to_avatar ?? '';
      to_name = item.data().to_name ?? '';
      from_uid = item.data().from_uid ?? '';
      from_avatar = item.data().from_avatar ?? '';
      from_name = item.data().from_name ?? '';
    } else {
      to_uid = item.data().from_uid ?? '';
      to_avatar = item.data().from_avatar ?? '';
      to_name = item.data().from_name ?? '';
      from_uid = item.data().to_uid ?? '';
      from_avatar = item.data().to_avatar ?? '';
      from_name = item.data().to_name ?? '';
    }

    final result = await Get.toNamed(
      AppRoutes.Message,
      parameters: {
        "doc_id": item.id,
        "to_uid": to_uid,
        "to_avatar": to_avatar,
        "to_name": to_name,
        "from_uid": from_uid,
        "from_avatar": from_avatar,
        "from_name": from_name,
      },
    );
    if (result != null) {
      asyncLoadAllData();
    }
  }

  asyncLoadAllData() async {
    var fromMessage = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where(
          'from_uid',
          isEqualTo: token,
        )
        .get();

    var toMessage = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where('to_uid', isEqualTo: token)
        .get();
    state.messages.clear();

    if (fromMessage.docs.isNotEmpty) {
      state.messages.assignAll(fromMessage.docs);
    }
    if (toMessage.docs.isNotEmpty) {
      state.messages.assignAll(toMessage.docs);
    }
  }
}
