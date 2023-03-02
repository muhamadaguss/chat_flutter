import 'package:chat_flutter/common/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatState {
  RxList<QueryDocumentSnapshot<Msg>> messages =
      <QueryDocumentSnapshot<Msg>>[].obs;
}
