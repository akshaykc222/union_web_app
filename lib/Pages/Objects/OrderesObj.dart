
import 'package:union_web_app/Pages/Objects/CustomerObj.dart';
import 'package:union_web_app/Pages/Objects/SubPanels.dart';

class OrdersObj{
  final CustomerObj customer;
  final String frame;
  final String image;
  final List<SubPanels> panel;
  final String totPrice;
  final bool isSeen;
  final String key;
  final dateTime;
  OrdersObj(  {required this.customer, required this.frame, required this.image, required this.panel,
      required this.totPrice, required this.isSeen,required this.key,required this.dateTime,});
}