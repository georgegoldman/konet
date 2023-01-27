import 'package:flutter/cupertino.dart';

class AddServiceManipulator extends ChangeNotifier {
  List<Map<String, dynamic>> addedService = [];
  Map<String, String> addedLcation = {};
  Map<String, dynamic> user = {};
  bool showLoader = false;
  void updateServiceList(Map<String, dynamic> newService) {
    addedService.add(newService);
    notifyListeners();
  }

  void deleteServiceList(Map<String, dynamic> afftectServiceist) {
    addedService.remove(afftectServiceist);
    notifyListeners();
  }

  void createLocation(Map<String, String> x) {
    addedLcation = x;
  }

  void loginUser(Map<String, dynamic> i) {
    user = i;
  }

  void updateShowLoader() {
    showLoader = !showLoader;
  }

  Map<String, dynamic> getUserToken() {
    return user;
  }
}
