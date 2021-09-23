
import 'package:flutterdelivery/models/settings.dart';
import 'package:flutterdelivery/models/user.dart';

import 'models/order.dart';

class AppData {
  static bool isOnline = false;
  static Settings settings;
  static User user;

  static List<Order> dashboardOrders = [];
  static List<Order> historyOrders = [];

  static int PENDING = 1;
  static int COMPLETED = 2;
  static int CANCEL = 3;
  static int RETURN = 4;
  static int INPROCESS = 5;
  static int DELIVERED = 6;
  static int DISPATCHED = 7;

}