import 'package:chat_flutter/common/entities/entities.dart';
import 'package:get/get.dart';

class MeState {
  var headDetail = Rx<UserLoginResponseEntity?>(null);
  RxList<MeListItem> meList = <MeListItem>[].obs;
}
