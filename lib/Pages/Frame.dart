import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'dart:html';

import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_web_app/Constants.dart';
import 'package:union_web_app/Pages/HomePage.dart';
import 'package:union_web_app/Pages/Objects/FramesObj.dart';
import 'package:union_web_app/Pages/Objects/Measurement.dart';
import 'package:union_web_app/Pages/UploadImages.dart';
import 'package:union_web_app/Pages/ViewFrames.dart';
import 'package:union_web_app/routes.dart';
import 'package:uuid/uuid.dart';

class Frames extends StatefulWidget {
  static String routeName = "/frames";
  const Frames({Key? key}) : super(key: key);

  @override
  _FramesState createState() => _FramesState();
}

class _FramesState extends State<Frames> with SingleTickerProviderStateMixin{
  late Uint8List uploadedImage;
  List<FramesObj> framesLst=[];
  bool isOpened = false;
   var _animationController;
   var _animateColor;
   var _animateIcon;
   bool _uploading=false;
  List<DataRow> data=[];
  final frameController=StreamController<List<DataRow>>();
  Curve _curve = Curves.easeOut;
  List<File> _uploadingImages=[];

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  //add images from folder
  void addImages(){

  }

  //get data from firebase
  Future<bool> checkFrames(String frameCode) async{
    bool _haveChild=false;
    Database db=database();
     DatabaseReference ref=db.ref("Frames");
    await ref.onValue.listen((event) {
      DataSnapshot snapshot=event.snapshot;
      if(snapshot.hasChild(frameCode)){
        _haveChild=true;

      }
    });
    print(_haveChild);
    return _haveChild;
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
    if(framesLst.isEmpty){
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('loading'),
            content: Text('please wait.This may take a long'),
            
          );
        },
      );
      Database db=database();
      DatabaseReference ref=db.ref("Frames");
      for(var obj in framesLst){
        if(await checkFrames(obj.frameCode)){
         await ref.child(obj.frameCode).update(obj.toJson()).whenComplete(() => print('update')).onError((error, stackTrace) => print(error));

        }else{
         await ref.child(obj.frameCode).set(obj.toJson());
        }

      }
      setState(() {
        _uploading=false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    }


  }
//method to load image and update `uploadedImage`

void startAnimation(){
  _animationController =
  AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    ..addListener(() {
      setState(() {});
    });
  _animateIcon =
      Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  _animateColor = ColorTween(
    begin: Colors.blue,
    end: Colors.red,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(
      0.00,
      1.00,
      curve: _curve,
    ),
  ));
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

            List<FramesObj>? frameList=[];
            var excel = Excel.decodeBytes(uploadedImage);
           print("sheets${ excel.sheets.length}");
          if(excel.sheets.length==1){
            for (var table in excel.tables.keys) {
              print(table); //sheet Name
              print(excel.tables[table]!.maxCols);
              print(excel.tables[table]!.maxRows);
              if(excel.tables[table]!.maxCols!=12){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('error'),
                      content: Text('file need to have only 12 columns.Now file have ${excel.tables[table]!.maxCols}'),
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
                var frameCode=row[0]!.value.toString();
                var numPanels=frameCode[0];
                bool is300=false;
                bool is500=false;
                bool is1200=false;

                switch(int.parse(numPanels)){
                  case 1:{
                    var frameAttr=frameCode.split("-");
                    var types= frameAttr[0].substring(3,frameAttr[0].length);
                    print(types);
                    if(types=="00"){
                      is1200=true;
                      is500=false;
                      is300=false;
                    }
                  }
                  break;
                  case 2:{
                    var frameAttr=frameCode.split("-");
                    var types= frameAttr[0].substring(3,frameAttr[0].length);
                    print(types);
                    if(types=="00"){
                      is1200=true;
                      is500=true;
                      is300=false;
                    }else if(types=="NR"){
                      is500=true;
                      is1200=false;
                      is300=false;
                    }
                  }
                  break;
                  case 3:{
                    var frameAttr=frameCode.split("-");
                    var types= frameAttr[0].substring(3,frameAttr[0].length);
                    print(types);
                    if(types=="00"){
                      is500=true;
                      is300=false;
                      is1200=false;
                    }else if(types=="WD") {
                      is300=true;
                      is1200=true;
                      is500=false;
                    }
                  }
                  break;
                  case 4:{
                    var frameAttr=frameCode.split("-");
                    var types= frameAttr[0].substring(3,frameAttr[0].length);
                    print(types);
                    if(types=="35"){
                      is300=true;
                      is500=true;
                      is1200=false;
                    }
                  }
                }
                print(" number of panels $numPanels");
                // print("$row");
                Uuid uuid=Uuid();
                Measurement height=Measurement(row[1]!.value.toString(), row[2]!.value.toString(), row[3]!.value.toString(), row[4]!.value.toString() );
                Measurement width=Measurement(row[5]!.value.toString(), row[6]!.value.toString(), row[7]!.value.toString(), row[8]!.value.toString() );
                FramesObj frame= FramesObj(uuid.v1().toString(),frameCode,  height, width, row[9]!.value, row[10]!.value, row[11]!.value.toString(), is300,is500, is1200, numPanels,false );
                frameList.add(frame);

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

            framesLst=frameList;
            print("framlst ${framesLst.length}");
            createRows();

            var frameJson=jsonEncode(frameList.map((e) => e.toJson()).toList());
            // print(frameJson);
          }
          );
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            print("Some Error occured while reading the file");
          });
        });

        reader.readAsArrayBuffer(file);
      }
    });
  }


  void createRows(){
    print("creating rows ${framesLst.length}");
    data=framesLst.map((e) => DataRow(cells: [
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
    frameController.sink.add(data);

  }
  //saving to realtime database
  void saveData(){

  }
  @override
  void dispose() {
    frameController.close();
    _animationController.dispose();
    super.dispose();
  }
  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }
  Widget add() {
    return GestureDetector(
      onTap:  _startFilePicker,
      child: new Container(

        child: SizedBox(
          width: 50,
          height: 50,
          child: Card(
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.import_export),
                Text('Import',style: TextStyle(fontSize: 15),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget insert() {
    return new Container(
      child: FloatingActionButton(
        onPressed:null ,
        tooltip: 'Insert',
        child: SizedBox(
          width: 100,
          height: 50,
          child: Card(
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text('Insert',style: TextStyle(fontSize: 15),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget update() {
    return new Container(
      child: FloatingActionButton(
        onPressed:()=>_startFilePicker() ,
        tooltip: 'Import',
        child: SizedBox(
          width: 100,
          height: 50,
          child: Card(
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.import_export),
                Text('Import',style: TextStyle(fontSize: 15),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: (){
      //  animate();
        Scaffold.of(context).openEndDrawer();
       /* if(Scaffold.of(context).isEndDrawerOpen){
          Navigator.of(context).pop();
        }else{

        }*/

      },
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }
  @override
  void initState() {

    startAnimation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: data.length==0 ? Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: _startFilePicker, child: Icon(Icons.add,size: 120,color: Colors.grey,)),
              Text('Click + icons to Import excel file',style: TextStyle(color: Colors.grey,fontSize: 16),),
              Text('null row is not allowed,only one sheet is allowed.Need 12 columns'),
              Image.asset("frame.png")
            ],
          ),
        ),
      ) : _uploading?Center( child: CircularProgressIndicator(),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              NavigationBarContant(context),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<List<DataRow>>(
                  stream: frameController.stream,
                  builder: (context, snapshot) {

                    return snapshot.hasData? DataTable(
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
                      rows:data,
                    ):Center(child: CircularProgressIndicator(),);
                  }
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
       backgroundColor: _animateColor.value,
        onPressed: (){
         animate();

          _key.currentState!.openEndDrawer();
          /* if(Scaffold.of(context).isEndDrawerOpen){
          Navigator.of(context).pop();
        }else{

        }*/

        },
        tooltip: 'Toggle',
       child: Icon(
         Icons.menu
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
              leading: Icon(Icons.image_sharp),
              title: Text('Insert Images',style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) =>ViewFrames()));
              },
              leading: Icon(Icons.preview_outlined),
              title: Text('View Frames',style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
class Import extends StatefulWidget {
  const Import({Key? key}) : super(key: key);

  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> {
  String? _fileName;
  List<PlatformFile>? _paths;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _FramesState()._startFilePicker(),
      child: SizedBox(
        width: 100,
        height: 50,
        child: Card(
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.import_export),
              Text('Import',style: TextStyle(fontSize: 15),)
            ],
          ),
        ),
      ),
    );
  }
}
class TableData extends StatefulWidget {
  final List<FramesObj> frames;
  const TableData({Key? key, required this.frames}) : super(key: key);

  @override
  _TableDataState createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  List<DataRow> data=[];
  void createRows(){
    data=widget.frames.map((e) => DataRow(cells: [
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

  }
  @override
  void initState() {
    print("widget size ${widget.frames.length}");
    setState(() {
      createRows();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
            DataColumn(label: Text('m'),)
          ],
          rows:data,
          ),
    );
    
  }
}
