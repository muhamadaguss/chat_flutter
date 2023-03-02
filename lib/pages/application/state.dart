import 'package:get/get.dart';

class ApplicationState {
  final _page = 0.obs;
  int get pages => _page.value;
  set pages(value) => _page.value = value;
}
