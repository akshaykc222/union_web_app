import 'dart:async';

import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:union_web_app/Pages/Objects/Register.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:union_web_app/Pages/SeeImages.dart';
class Agents extends StatefulWidget {
  const Agents({Key? key}) : super(key: key);

  @override
  _AgentsState createState() => _AgentsState();
}

class _AgentsState extends State<Agents> {
  bool _allowed=false;
  bool _active=false;
  List<Register> registerList=[];
  List<DataRow> widgetList=[];
  final registerStream=StreamController<List<DataRow>>();
  Future<void> readAgents() async {
    var data = await FirebaseDatabaseWeb.instance.reference()
        .child("Register")
        .once();
    Map<String, dynamic> json = await data.value;
    for (var js in json.values) {
      Register register = Register(
          js['account_num:']==null?"":js['account_num:'],
          js['address']==null?"":js['address'],
          js['adhar']==null?"":js['adhar'],
          js['isApproved']==null?false:js['isApproved'],
          js['name']==null?"":js['name'],
          js['phone']==null?"":js['phone'],
          js['refered']==null?"":js['refered'],
        js['orderAllowed']==null?false:js['orderAllowed'],);
      registerList.add(register);
      print("register ${registerList.length}");
    }print("register ${registerList.length}");
    setState(() {
      widgetList = registerList.map((e) =>
          DataRow(cells: [
            DataCell(Text(e.name)),
            DataCell(Text(e.phone)),
            DataCell(Text(e.accountNum)),
            DataCell(Text(e.address)),
            DataCell(Padding(
              padding: const EdgeInsets.all(8.0),
              child: LiteRollingSwitch(
                value: e.isApproved,
                textOn: "Active",
                textOff: "Not Active",
                colorOn: Colors.cyan,
                colorOff: Colors.red[400],
                iconOn: Icons.check,
                iconOff: Icons.power_settings_new,
                animationDuration: Duration(milliseconds: 800),
                onChanged: (bool value) async {
                  await FirebaseDatabaseWeb.instance.reference()
                      .child('Register')
                      .child(e.phone)
                      .update({
                    'isApproved':value
                  });
                },
              ),
            )),
            DataCell(Padding(
              padding: const EdgeInsets.all(8.0),
              child: LiteRollingSwitch(
                value: e.allowed,
                textOn: "Allowed",
                textOff: "Disallowed",
                colorOn: Colors.cyan,
                colorOff: Colors.red[400],
                iconOn: Icons.check,
                iconOff: Icons.power_settings_new,
                animationDuration: Duration(milliseconds: 800),
                onChanged: (bool value) async {
                  await FirebaseDatabaseWeb.instance.reference()
                      .child('Register')
                      .child(e.phone)
                      .update({
                    'orderAllowed':value
                  });
                },
              ),
            )),
            DataCell(
              InkWell(onTap:()=> Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>SeeImages(phone: e.phone,))),
                  child: Text('See Images', style: TextStyle(color: Colors.blue),)),),
          ])).toList();
    });
      print(widgetList.length);

      registerStream.add(widgetList);
    }

  @override
  void initState() {
    readAgents();
    super.initState();
  }
  @override
  void dispose() {
    registerStream.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList.isEmpty?Center(child:CircularProgressIndicator()) :SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Account no')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Approve')),
                    DataColumn(label: Text('Allow to Order')),
                    DataColumn(label: Text('proof Images')),

                  ], rows:widgetList,

                ),
          ),
        ),
      ),
    );
        }


  }

class RegisterRow extends StatelessWidget {
  final Register register;
  const RegisterRow({Key? key, required this.register}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [

          TextField(title: "Name"),
          TextField(title: "Name"),
          TextField(title: "Name"),
        ],
      ),
    );
  }
}
class TextField extends StatelessWidget {
  final String title;
  const TextField({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(color: Colors.black),);
  }
}
Widget _buildChip(String label, Color color) {
  return Chip(
    labelPadding: EdgeInsets.all(2.0),
    avatar: CircleAvatar(
      backgroundColor: Colors.white70,
      child: Text(label[0].toUpperCase()),
    ),
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: color,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: EdgeInsets.all(8.0),
  );
}