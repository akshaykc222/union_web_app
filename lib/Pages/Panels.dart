import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:union_web_app/Pages/Objects/PanelsObj.dart';
import 'package:union_web_app/Pages/ViewPanels.dart';

import '../Constants.dart';
import 'HomePage.dart';
import 'UploadImages.dart';

class Panels extends StatefulWidget {
  const Panels({Key? key}) : super(key: key);

  @override
  _PanelsState createState() => _PanelsState();
}

class _PanelsState extends State<Panels> {
  bool _clicked=false;
  bool _uploading=false;
  final imageStream =StreamController<List<DataRow>>();
  List<DataRow> data=[];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Uint8List uploadedImage;
  List<PanelsObj> panelList=[];
  List<DataRow> listData=[];
  List<String> catList=[];
  final uploadingStream=StreamController<int>();
  //get data from firebase
  Future<bool> checkPanels(String panelCode) async{
    bool _haveChild=false;
    Database db=database();
    DatabaseReference ref=db.ref("panels");
   // ref.orderByKey().eq

      if(await ref.orderByKey().equalTo(panelCode).onValue.isEmpty){
        _haveChild=false;
      }else{
        _haveChild=true;
      }

    print(_haveChild);
    return _haveChild;
  }
  Future<void> getCategories() async {
    String item="";
    for(var i in panelList){
      if(item!=i.type){
        item=i.type;
        if(!catList.contains(item)){
          catList.add(item);
          print(item);
        }
      }
    }
    for(var i in catList){
      Database db=database();
      DatabaseReference ref=db.ref("panelTypes");
      if(await ref.orderByKey().equalTo(i.replaceAll(".", "")).onValue.isEmpty){
        FirebaseDatabaseWeb.instance.reference().child("panelTypes").child(i.replaceAll(".", "")).set({"type":i});
      }

    }

  }
  void addFirebaseData(BuildContext ctx) async{
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        if(data.isEmpty){
          Navigator.pop(ctx);
        }else{
          Navigator.pop(ctx);
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }

      },
    );
    AlertDialog dialog=AlertDialog(
      title: Text('Error'),
      content: Text('Empty list.Please upload excel'),
      actions: [
        okButton
      ],
    );
    AlertDialog alertDialog=AlertDialog(
      title: Text('Added'),
      content: Text('List added to database.'),
      actions: [
        okButton
      ],
    );
    if(panelList.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }else{
      Navigator.pop(ctx);
      setState(() {
        _uploading=true;
      });
      double percentage=0.0;
      var i=0;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder<int>(
            initialData: 0,
            stream: uploadingStream.stream,
            builder: (context, snapshot) {
              return AlertDialog(
                title: Text('Adding data'),
                content: Container(

                  child:   Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20,),
                        Text('please wait.This take a while ${snapshot.data}/${panelList.length}'),
                        SizedBox(width: 10,),
                        //Text("$i/${panelList.length}")
                      ],
                    ),

                ),
              );
            }
          );
        },
      );
      Database db=database();
      DatabaseReference ref=db.ref("Panels");

      for(var obj in panelList){

        if(await checkPanels(obj.panelCode)){
         await ref.child(obj.type.replaceAll(".", "")).child(obj.size).child(obj.panelCode).update(obj.toJson());
        }else{
         await ref.child(obj.type.replaceAll(".", "")).child(obj.size).child(obj.panelCode).set(obj.toJson());
        }

          i++;

      uploadingStream.sink.add(i);

        print("$i/${panelList.length}");
      }
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
      setState(() {
        _uploading=false;
      });


    }


  }
  void createRows(){
   print("creating rows ${panelList.length}");


      for(var e in panelList){
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

   imageStream.sink.add(listData);
  }
  void showAlert(String title,String msg){
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);

      },
    );
    AlertDialog dialog=AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton
      ],
    );
    AlertDialog alertDialog=AlertDialog(
      title: Text('Added'),
      content: Text('List added to database.'),
      actions: [
        okButton
      ],
    );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );

  }
  _startFilePicker() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept=".xlsx,.xls";
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        FileReader reader =  FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImage = reader.result as Uint8List;
            // var file=File.fromRawPath(uploadedImage);

            //List<PanelsObj>? panelList=[];
            try{
              var excel = Excel.decodeBytes(uploadedImage);
              if(excel.sheets.length==1){
                for (var table in excel.tables.keys) {
                  print(table); //sheet Name
                  print(excel.tables[table]!.maxCols);
                  print(excel.tables[table]!.maxRows);
                  if(excel.tables[table]!.maxCols!=6){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('error'),
                          content: Text('only 6 columns allowed.current ${excel.tables[table]!.maxCols}'),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);

                              },
                            )
                          ],
                        );
                      },
                    );
                    break;
                  }
                  for (var row in excel.tables[table]!.rows) {

                    var panelCode=row[0]!.value.toString().split("-");
                    String type="";
                    switch(panelCode[1]){
                      case "030":{type="300";}
                      break;
                      case "050":{type="500";}
                      break;
                      case "120":{type="1200";}
                      break;
                    }
                    PanelsObj obj=PanelsObj(row[0]!.value.toString(), row[1]!.value.toString(), row[2]!.value.toString(), row[3]!.value.toString(), row[4]!.value.toString(),  row[5]!.value.toString(), type,false);
                    panelList.add(obj);
                  }

                }
              }else{
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('error'),
                      content: Text('more than 1 sheets not allowed'),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);

                          },
                        )
                      ],
                    );
                  },
                );
              }

              _clicked=true;
            }catch(E){
              print(E);
      showAlert("Error", E.toString());
              _clicked=false;
            }
            getCategories();
            createRows();

            var frameJson=jsonEncode(panelList.map((e) => e.toJson()).toList());
            // print(frameJson);
          }
          );
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            _clicked=false;
            print("Some Error occured while reading the file");
          });
        });

        reader.readAsArrayBuffer(file);
      }else{
        _clicked=false;
      }
    });
  }
  @override
  void dispose() {
    uploadingStream.close();
  imageStream.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body:!_clicked?Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: _startFilePicker, child: Icon(Icons.add,size: 120,color: Colors.grey,)),
              Text('Click + icons to Import excel file',style: TextStyle(color: Colors.grey,fontSize: 16),),
              Text('null row is not allowed,only one sheet is allowed.Need 6 columns'),
              Image.asset("panel_excel.png")
            ],
          ),
        ),
      ) : StreamBuilder<List<DataRow>>(
        stream: imageStream.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  children: [
                    NavigationBarContant(context),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [

                          DataColumn(label: Text('Panel Code'),),
                          DataColumn(label: Text('Price'),),
                          DataColumn(label: Text('Height'),),
                          DataColumn(label: Text('Width'),),
                          DataColumn(label: Text('Desc1'),),
                          DataColumn(label: Text('Desc2'),),
                          //DataColumn(label: Text('inch'),),


                        ],
                        rows:snapshot.data!,
                      ),
                    ),

                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('please wait ...')
                ],
              ),
            );
          }

        }
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){


          _key.currentState!.openEndDrawer();
          /* if(Scaffold.of(context).isEndDrawerOpen){
          Navigator.of(context).pop();
        }else{

        }*/

        },
        tooltip: 'Toggle',
        child: Icon(
         Icons.menu,
         color: Colors.white,
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 30,),
            ListTile(
              onTap: (){
                addFirebaseData(context);

              },
              leading: Icon(Icons.add),
              title: Text('Insert',style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) =>UploadImages(type: "F",)));
              },
              leading: Icon(Icons.add_a_photo_outlined),
              title: Text('Insert Images',style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) =>ViewPanels()));
              },
              leading: Icon(Icons.preview_outlined),
              title: Text('View Panels',style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
class ProgressDialogCustom extends StatefulWidget {
  const ProgressDialogCustom({Key? key}) : super(key: key);

  @override
  _ProgressDialogCustomState createState() => _ProgressDialogCustomState();
}

class _ProgressDialogCustomState extends State<ProgressDialogCustom> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
