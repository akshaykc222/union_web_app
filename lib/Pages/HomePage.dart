

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_web_app/Pages/Frame.dart';
import 'package:union_web_app/routes.dart';
import 'package:union_web_app/Constants.dart';
class HomePage extends StatefulWidget {
  static String routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> menuList=["Frames","Panels","Orders","Library","Agents"];
  List<Widget> menus=[];
  @override
  void initState() {

    createMenu();
    print(menus.length);
    super.initState();
  }
  void createMenu(){
    setState(() {
      menus= menuList.map((e) => MenuItems( name: e,press:()=> navigate(e),)).toList();
      print(menus.length);
    });

  }
void navigate(String name){
  switch(name){
    case "Frames":{
      Navigator.pushNamed(context, '/frames');
    }
    break;
    case "Panels":{
      Navigator.pushNamed(context, panels);
    }
    break;
    case "Orders":{
      Navigator.pushNamed(context, orders);
    }
    break;
    case "Library":{
      Navigator.pushNamed(context, library);
    }
    break;
    case "Agents":{
      Navigator.pushNamed(context, agents);
    }
    break;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavigationBarContant(context),
      SizedBox(height: 20,),
      Expanded(

          child:GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5
              ),
              itemCount: menus.length,
              itemBuilder: (context,index){
                return menus[index];
              })
      )
        ],
      ),
    );
  }
}

Widget _homeBody(){
  return Expanded(

    child:Text(_HomePageState().menus.length.toString())
  );
}
class MenuItems extends StatefulWidget {
  final String name;
  final GestureTapCallback press;
  const MenuItems({Key? key, required this.name, required this.press}) : super(key: key);

  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap:this.widget.press,
        child: Card(
          elevation: 10,
          color: Colors.white,
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}


