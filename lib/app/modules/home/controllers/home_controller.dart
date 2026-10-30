import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentNavIndex = 0.obs;

  void changeTabIndex(int index) {
    currentNavIndex.value = index;
  }
}

