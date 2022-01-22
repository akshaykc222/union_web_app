import 'dart:async';

import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:union_web_app/Pages/Objects/PanelsObj.dart';

class ViewPanels extends StatefulWidget {
  const ViewPanels({Key? key}) : super(key: key);

  @override
  _ViewPanelsState createState() => _ViewPanelsState();
}

class _ViewPanelsState extends State<ViewPanels> {
  List<DataRow> listData=[];
  List<PanelsObj> panelsList=[];

  final panelStream=StreamController<List<DataRow>>();
  void getData(){
    FirebaseDatabaseWeb.instance.reference().child("Panels").onValue.listen((framesSnap) {
      Map<String,dynamic> panelList=framesSnap.value ;
      // for(Map<String,dynamic> i in panelList.values){
      //   for(Map<String,dynamic> j in i.values){
      //     for(Map<String,dynamic> k in j.values){
      //       panelsList.add(PanelsObj.fromJson(k));
      //       print(panelList.length);
      //     }
      //
      //   }
      // }
      panelList.values.forEach(( i) {
        Map<String,dynamic> keyMap=i as Map<String,dynamic>;
        keyMap.values.forEach((j) {
          Map<String,dynamic> sizeMap=j as Map<String,dynamic>;
          sizeMap.values.forEach((k) {
           // print(k);
            Map<String,dynamic> lastMap=k as Map<String,dynamic>;
            panelsList.add(PanelsObj.fromJson(lastMap));
            print(panelsList.length);
          });
        });
      });
      print('done');
      createRows();
    });
  }
  void createRows(){
    print("creating rows ${panelsList.length}");


    for(var e in panelsList){
      var dataRow=  DataRow(cells: [
        DataCell(Text(e.panelCode)),
        DataCell(Text(e.panelPrice)),
        DataCell(Text(e.height)),
        DataCell(Text(e.width)),

        DataCell(Text(e.type)),
        DataCell(Text(e.desc2)),
        //DataCell(Text(e.size)),

      ]);
      listData.add(dataRow);

    }

    panelStream.sink.add(listData);
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  void dispose() {
    panelStream.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<List<DataRow>>(
          stream: panelStream.stream,
          builder: (context,snapShot){
            if (!snapShot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Panel Code'),),
                      DataColumn(label: Text('Price'),),
                      DataColumn(label: Text('Height'),),
                      DataColumn(label: Text('Width'),),
                      DataColumn(label: Text('Desc1'),),
                      DataColumn(label: Text('Desc2'),),

                    ],
                    rows:snapShot.data!,
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 50,

        child: InkWell(
          onTap: (){
            showDialog(
              context: context, builder: (BuildContext context) {
              return AlertDialog(
                title: Text('This will delete all frames'),
                content: Text('press ok to continue.'),
                actions: [
                  TextButton(onPressed: (){ Navigator.pop(context);}, child: Text('Cancel',style: TextStyle(color: Colors.blue),)),
                  TextButton(onPressed: (){
                    FirebaseDatabaseWeb.instance.reference().child("Panels").remove();
                  }, child: Text('Delete',style: TextStyle(color: Colors.red),))
                ],
              );
            },


            );

          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text('Delete All',style: TextStyle(color: Colors.white),))),
        ),
      ),
    );
  }
}
