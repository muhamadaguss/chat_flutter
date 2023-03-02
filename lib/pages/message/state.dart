import 'package:chat_flutter/common/entities/entities.dart';
import 'package:get/get.dart';

class MessageState {
  RxList<Msgcontent> msgContentList = <Msgcontent>[].reversed.toList().obs;
  var toUid = "".obs;
  var toName = "".obs;
  var toAvatar = "".obs;
  var toLocation = "unknown".obs;
  var fromUid = "".obs;
  var fromName = "".obs;
  var fromAvatar = "".obs;
}
