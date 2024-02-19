import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:otp_auth/services/internet_connectivity_service.dart';

class InternetConnectivityProvider extends ChangeNotifier {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  final InternetConnectivityServices _connectivityServices =
      InternetConnectivityServices();

  Future getInternetConnectivity(BuildContext context) async {
    _connectivityServices.getConnectivity(context);
    isDeviceConnected = _connectivityServices.isDeviceConnected;
    isAlertSet = _connectivityServices.isAlertSet;
    subscription = _connectivityServices.subscription;
  }

  notifyListeners();
}
