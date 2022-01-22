import 'dart:async';
import 'dart:collection';

import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Objects/FramesObj.dart';
class ViewFrames extends StatefulWidget {
  const ViewFrames({Key? key}) : super(key: key);

  @override
  _ViewFramesState createState() => _ViewFramesState();
}

class _ViewFramesState extends State<ViewFrames> {
  List<DataRow> frameRow=[];
  List<FramesObj> dataFrames=[];
  final frameRowController=StreamController<List<DataRow>>();
  void getFrames(){
    FirebaseDatabaseWeb.instance.reference().child("Frames").onValue.listen((framesSnap) {
      Map<String,dynamic> frameList=framesSnap.value ;
      for(var i in frameList.values){
        dataFrames.add(FramesObj.fromJson(i));
        print(dataFrames.length);
      }
      print('done');
      createRows();
    }).onDone(() {
      print('done');
    });
  }
  void createRows(){
    print("creating rows ${dataFrames.length}");
    frameRow=dataFrames.map((e) => DataRow(cells: [
      DataCell(Text(e.frameCode)),
      DataCell(Text(e.height.cm)),
      DataCell(Text(e.height.m)),
      DataCell(Text(e.height.inch)),
      DataCell(Text(e.height.feet)),
      DataCell(Text(e.width.cm)),
      DataCell(Text(e.width.m)),
      DataCell(Text(e.width.inch)),
      DataCell(Text(e.width.feet)),
      DataCell(Text(e.frameOuter)),
      DataCell(Text(e.frameInner)),
      DataCell(Text(e.cost)),

    ])).toList();
    frameRowController.sink.add(frameRow);

  }
  @override
  void initState() {
    getFrames();
    super.initState();
  }
  @override
  void dispose() {
    frameRowController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<List<DataRow>>(
          stream: frameRowController.stream,
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
                    DataColumn(label: Text('Frame Code'),),
                    DataColumn(label: Text('height cm'),),
                    DataColumn(label: Text('m'),),
                    DataColumn(label: Text('inch'),),
                    DataColumn(label: Text('feet'),),
                    DataColumn(label: Text('width cm'),),
                    DataColumn(label: Text('m'),),
                    DataColumn(label: Text('inch'),),
                    DataColumn(label: Text('feet'),),
                    DataColumn(label: Text('Frame Outer'),),
                    DataColumn(label: Text('Frame Inner'),),
                    DataColumn(label: Text('Cost'),),

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
                       FirebaseDatabaseWeb.instance.reference().child("Frames").remove();
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
