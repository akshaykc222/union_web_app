


import 'package:flutter/widgets.dart';
import 'package:union_web_app/Pages/Agents.dart';
import 'package:union_web_app/Pages/Frame.dart';
import 'package:union_web_app/Pages/HomePage.dart';
import 'package:union_web_app/Pages/Library.dart';
import 'package:union_web_app/Pages/Login.dart';
import 'package:union_web_app/Pages/Orders.dart';
import 'package:union_web_app/Pages/Panels.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  HomePage.routeName:(context)=>HomePage(),
  Frames.routeName:(context)=>Frames(),
  panels:(context)=>Panels(),
  orders:(context)=>Orders(),
  library:(context)=>Library(),
  agents:(context)=>Agents(),
  login:(context)=>Login()
};
const String home="/home";
const String panels="/panels";
const String orders="/orders";
const String library="/library";
const String agents="/agents";
const String login="/login";
