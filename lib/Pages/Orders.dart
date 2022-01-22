import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'package:firebase/firebase.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:union_web_app/Constants.dart';
import 'package:union_web_app/Pages/Objects/CustomerObj.dart';
import 'package:union_web_app/Pages/Objects/OrderesObj.dart';
import 'package:union_web_app/Pages/Objects/SubPanels.dart';
import 'package:union_web_app/routes.dart';
import 'dart:ui' as ui;
class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int orderAgent=0;
  int orderLibrary=0;
  final orderAgentList=StreamController<List<Widget>>();
  final orderAgentLibraryList=StreamController<List<Widget>>();
  int numberFrmLibrary=0;
  List<Widget> widgetOrderList=[];

  List<OrdersObj> orderList=[];
  Future<void> getUserDesings() async {

      FirebaseDatabaseWeb.instance.reference()
        .child('UserDesings')
        .onValue.listen((data) async {

        var usd= data.value;
        Map<String,dynamic> json=usd;
        for(Map<String,dynamic> element in json.values) {
          if(element['isSeen']==false){
            CustomerObj customer = await getCustomerList(element['custmer']);
            List<SubPanels> panelList = await getPanels(element['panel']);

            var obj = OrdersObj(customer: customer,
                frame: element['frame'],
                image: element['image'],
                panel: panelList,
                totPrice: element['totprice'],
                isSeen: element['isSeen'] == null ? false : element['isSeen'],
                key: element['custmer'],dateTime: element['dateTime']);
            orderList.add(obj);
            orderList.sort((a,b){
              var adate = a.dateTime;
              var bdate = b.dateTime;
              return adate.compareTo(bdate);
            });
            print("orderListSize:${orderList.length}");
            List<Widget> tempList=[];
            tempList= orderList.map((e) => PrintGate(orderData: e)).toList();
            orderAgentList.add(tempList);
            setState(() {
              orderAgent=orderList.length;
            });
            print(tempList.length);
          }

        }

        });

    // json.forEach((key, value) async {
    //   print(value['custmer']);
    //   CustomerObj customer=await getCustomerList(value['custmer']);
    //   List<SubPanels> panelList=await getPanels(value['panel']);
    //
    //   var obj=OrdersObj(customer: customer, frame: value['frame'], image: value['image'], panel: panelList, totPrice: value['totprice'], isSeen: value['isSeen']==null?false:value['isSeen']);
    //   orderList.add(obj);
    // });




  }
  Future<List<SubPanels>> getPanels(String key){
    Completer<List<SubPanels>> panelList=Completer();
    List<SubPanels> tempList=[];
    FirebaseDatabaseWeb.instance.reference()
        .child('sel_panels')
        .child(key)
        .once().then((selPanels){
      List<dynamic> json=selPanels.value;
      json.forEach((element) {
        // Map<Str>
        SubPanels subPanels=SubPanels.fromJson(element);
        tempList.add(subPanels);
      });
      panelList.complete(tempList);
    });
    return panelList.future;
  }
  Future<CustomerObj> getCustomerList(String key){
    Completer<CustomerObj> custList=Completer();
    var data= FirebaseDatabaseWeb.instance.reference()
        .child('Customer')
        .child(key)
        .once().then((customerList) {
      Map<String,dynamic> list=customerList.value ;
      CustomerObj cus=CustomerObj.fromJson(list);
      //print(cus);
      custList.complete(cus);
      // print(list);
    });
    return custList.future;
  }

  getDataFromFirebase() async {
    //  readLibrary();
    getUserDesings();
  }
  // readLibrary()  {
  //
  //   Database db=database();
  //
  //   DatabaseReference databaseReference=db.ref("UserDesings");
  //   databaseReference.onValue.listen((snap) {
  //  print(snap.snapshot.val());
  //     DataSnapshot snapshot=snap.snapshot;
  //     snapshot.forEach((snapshot)  async {
  //       CustomerObj? customerObj;
  //       List<SubPanels> subPanels=[];
  //       var userDesinges=snapshot.val();
  //
  //       var customer=userDesinges['custmer'];
  //       var panels=userDesinges['panel'];
  //       if(customer==null || panels==null){
  //         print("error here");
  //       }
  //       // print(userDesinges['custmer']);
  //       db.ref('Customer/$customer').onValue.listen((custSnap) {
  //         print(custSnap.snapshot.val());
  //         var dataVal=custSnap.snapshot.val();
  //
  //         print('have alt phone');
  //         var address=dataVal['address']==null?"":dataVal['address'];
  //         var agent=dataVal['agent']==null?"":dataVal['agent'];
  //         var altPhone=dataVal['altPhone']==null?"":dataVal['altPhone'];
  //         var name=dataVal['name']==null?"":dataVal['name'];
  //         var phone=dataVal['phone']==null?"":dataVal['phone'];
  //         var pinCode=dataVal['pinCode']==null?"":dataVal['pinCode'];
  //         var district=dataVal['district']==null?"":dataVal['district'];
  //         customerObj=CustomerObj(address, agent, altPhone,  name, phone,  pinCode, district);
  //
  //       }
  //       );
  //
  //
  //       db.ref("sel_panels/$panels").onValue.listen((panelSnap) {
  //         panelSnap.snapshot.forEach((childSnap){
  //           childSnap.forEach((selPan) {
  //             var imagePos=selPan.child('imagePosition').val().toString()==null?"":selPan.child('imagePosition').val().toString();
  //             var panelName=selPan.child('panel_name').val()==null?"":selPan.child('panel_name').val();
  //             var panelcost=selPan.child('panel_cost').val().toString()==null?"":selPan.child('panel_cost').val().toString();
  //             //subPanels.add(SubPanels(imagePos ,panelcost., panelName));
  //           });
  //         });
  //         print("subpanel ${subPanels.length}");
  //         bool seen=false;
  //         if(userDesinges['isSeen']!=null){
  //           seen=userDesinges['isSeen'];
  //         }
  //         var frame=userDesinges['frame']==null?"":userDesinges['frame'];
  //         var image=userDesinges['image']==null?"":userDesinges['image'];
  //         var total=userDesinges['totprice']==null?"":userDesinges['totprice'];
  //
  //         OrdersObj ordersObj=OrdersObj(customer: customerObj!,frame: frame,image: image,panel: subPanels,totPrice:total ,isSeen: seen);
  //         orderList.add(ordersObj);
  //         print("order size ${orderList.length}");
  //         List<Widget> tempList=[];
  //         tempList= orderList.map((e) => PrintGate(orderData: e)).toList();
  //         orderAgentLibraryList.add(tempList);
  //       }).onData((panelSnap) {
  //
  //       });
  //     });
  //   });
  //   DatabaseReference df=db.ref("Customer");
  //   DatabaseReference dfpanels=db.ref("sel_panels");
  //   databaseReference.onValue.listen((event) { }).onData((snap) {
  //
  //   });
  //
  //
  // }

  @override
  void initState() {

    getDataFromFirebase();
    super.initState();
  }
  @override
  void dispose() {

    orderAgentLibraryList.close();
    orderAgentList.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: PrintGate(),

      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:  Container(
            color: Colors.grey[300],
            child: Column(

              children: [
                NavigationBarContant(context),
                SizedBox(height: 10,),
                orderLibrary==0?Container(): Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Orders From Library',style: TextStyle(fontSize: 30,color: Colors.black),),
                      SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        child: Center(child: Text(orderLibrary.toString(),style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                ),
                orderAgent==0?Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Orders From Agent Creation',style: TextStyle(fontSize: 30,color: Colors.black),),
                      SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        child: Center(child: Text(orderAgent.toString(),style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                ),
                StreamBuilder<List<Widget>>(

                  stream:orderAgentList.stream ,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context,index)=>snapshot.data![index]);
                    }else{
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Please wait...')
                          ],
                        ),
                      );
                    }

                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}
class PrintGate extends StatefulWidget {
  final OrdersObj orderData;
  const PrintGate({Key? key, required this.orderData}) : super(key: key);

  @override
  _PrintGateState createState() => _PrintGateState();
}

class _PrintGateState extends State<PrintGate> {
  GlobalKey _globalKey = new GlobalKey();
  final snackBar = SnackBar(content: Text('text copied!'));
  void copyString(String txt){
    print('copr');
    Clipboard.setData( ClipboardData(text: txt)).then((_){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new io.File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  ScreenshotController screenshotController = ScreenshotController();
  bool _isVisisble=true;
  @override
  Widget build(BuildContext context) {
    var width= MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString();
    var agentCode=widget.orderData.customer.agent.toString()+".\$"+formattedDate;

    String gateCode="";
    String panel1="";
    String panel2="";
    String panel3="";
    String panel4="";
    // var imgPosition=orderData.panel;
    // for(var pos in imgPosition){
    //   switch(pos.imagePosition){
    //     case 1:{
    //       panel1=pos.panelName;
    //     }
    //     break;
    //     case 2:{
    //       panel2=pos.panelName;
    //     }
    //     break;
    //     case 3:{
    //       panel3=pos.panelName;
    //     }
    //     break;
    //     case 4:{
    //       panel4=pos.panelName;
    //     }
    //     break;
    //   }
    // }
    //
    // for (var f in orderData.panel){
    //   switch(f.imagePosition){
    //     case 1:{
    //       panel1=f.panelName;
    //     }
    //     break;
    //     case 2:{
    //       panel2=f.panelName;
    //     }
    //     break;
    //
    //     case 3:{
    //       panel3=f.panelName;
    //     }
    //     break;
    //     case 4:{
    //       panel4=f.panelName;
    //     }
    //     break;
    //   }
    // }
    gateCode=widget.orderData.frame+"\$"+panel1;
    if(panel2.isNotEmpty&&panel3.isNotEmpty&&panel4.isNotEmpty){
      gateCode=gateCode+"\$"+panel2+"\$"+panel3+"\$"+panel4;
    }else if(panel2.isNotEmpty&&panel3.isNotEmpty){
      gateCode=gateCode+"\$"+panel2+"\$"+panel3;
    }else if(panel2.isNotEmpty){
      gateCode=gateCode+"\$"+panel2;
    }
    // // gateCode=orderData.frame+'$'+panel1+panel2+panel3+panel4;
    String district;
    // ignore: unnecessary_null_comparison
    if (widget.orderData.customer.district==null) {
      district = "";
    } else {
      district = widget.orderData.customer.district;
    }
    var customerId=widget.orderData.customer.name+"\$"+district+"\$"+widget.orderData.customer.phone+".";
    String pinCode;
    // ignore: unnecessary_null_comparison
    if (widget.orderData.customer.pinCode==null) {
      pinCode = "";
    } else {
      pinCode = widget.orderData.customer.pinCode;
    }
    String altPhone;
    // ignore: unnecessary_null_comparison
    if (widget.orderData.customer.altPhone==null) {
      altPhone = "";
    } else {
      altPhone = widget.orderData.customer.pinCode;
    }
    var customerDetails=widget.orderData.customer.address+"\$"+pinCode+"\$"+altPhone;
    return Center(
      
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child:_isVisisble? Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width:width*0.8,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textBoxes(title: "AGENT CODE :",data: agentCode, onTap:()=> copyString(agentCode),visibility: true,),
                      ElevatedButton(
                          onPressed: () async {
                           Database db=database();
                           db.ref("UserDesings").child(widget.orderData.key).update({
                             "isSeen":true
                           }).onError((error, stackTrace) => print(error)).whenComplete(() => Navigator.pushReplacementNamed(context, orders));
                           
                            setState(() {
                              _isVisisble=false;
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                          ),
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye_outlined,color: Colors.white,),
                              Text('Seen',style: TextStyle(color: Colors.white),)
                            ],
                          )
                        //  shape:
                      ),
                    ],
                  ),

                  spacer20,
                  Container(
                    width: width*0.7,
                    child: AspectRatio(
                      aspectRatio: 5/2,
                      child: Image.network(widget.orderData.image),
                    ),
                  ),
                  spacer20,
                  textBoxes(title: "GATE CODE :",data: gateCode, onTap: ()=>copyString(gateCode),visibility: true,),
                  spacer20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textBoxes(title: "CUSTOMER ID :",data: customerId,onTap: ()=>copyString(customerId),visibility: true,),
                      ElevatedButton(
                          onPressed: (){
                            screenshotController.captureFromWidget(
                                Center(
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:width*0.8,

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            textBoxes(title: "AGENT CODE :",data: agentCode, onTap:()=> copyString(agentCode),visibility: false,),
                                            spacer20,
                                            Container(
                                              width: width*0.7,
                                              child: AspectRatio(
                                                aspectRatio: 5/2,
                                                child: Image.network(widget.orderData.image),
                                              ),
                                            ),
                                            spacer20,
                                            textBoxes(title: "GATE CODE :",data: gateCode, onTap: ()=>copyString(gateCode),visibility: false,),
                                            spacer20,
                                            textBoxes(title: "CUSTOMER ID :",data: customerId,onTap: ()=>copyString(customerId),visibility: false,),
                                            spacer20,
                                            textBoxes(title: "CUSTOMER DETAILS :",data: customerDetails,onTap: ()=>copyString(customerDetails),visibility: false,)

                                          ],

                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ).then((value)  async {

                              final doc = pw.Document();
                              final image =PdfImage.file(
                                doc.document, bytes: value,

                              );
                              doc.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return pw.Center(
                                      child:pw.Image (pw.ImageProxy(image)),
                                    ); // Center
                                  }));
                              // CircularProgressIndicator();
                              await Printing.sharePdf(bytes:await doc.save(),filename: "$gateCode.pdf"
                              );



                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                          ),
                          child: Text('Save As Pdf',style: TextStyle(color: Colors.white),)
                        //  shape:
                      ),
                    ],
                  ),
                  spacer20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textBoxes(title: "CUSTOMER DETAILS :",data: customerDetails,onTap: ()=>copyString(customerDetails),visibility: true,),
                      ElevatedButton(
                          onPressed: (){
                            screenshotController.captureFromWidget(
                                Center(
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:width*0.9,

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            textBoxes(title: "AGENT CODE :",data: agentCode, onTap:()=> copyString(agentCode),visibility: false,),
                                            spacer20,
                                            Container(
                                              width: width*0.7,
                                              child: AspectRatio(
                                                aspectRatio: 5/2,
                                                child: Image.network(widget.orderData.image),
                                              ),
                                            ),
                                            spacer20,
                                            textBoxes(title: "GATE CODE :",data: gateCode, onTap: ()=>copyString(gateCode),visibility: false,),
                                            spacer20,
                                            textBoxes(title: "CUSTOMER ID :",data: customerId,onTap: ()=>copyString(customerId),visibility: false,),
                                            spacer20,
                                            textBoxes(title: "CUSTOMER DETAILS :",data: customerDetails,onTap: ()=>copyString(customerDetails),visibility: false,)

                                          ],

                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ).then((value)   async {
                              final doc = pw.Document();
                              final image =PdfImage.file(
                                doc.document, bytes: value,

                              );
                              doc.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return pw.Center(
                                      child:pw.Image (pw.ImageProxy(image)),
                                    ); // Center
                                  }));
                              await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async => doc.save());
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                          ),
                          child: Text('Print',style: TextStyle(color: Colors.white),)
                        //  shape:
                      ),


                    ],
                  )

                ],

              ),
            ),
          ),
        ):Container(),
      ),
    );
  }
}
// ignore: camel_case_types
class textBoxes extends StatelessWidget {
  final String title;
  final String data;
  final bool visibility;
  final Function onTap;
  const textBoxes({Key? key, required this.data, required this.title, required this.onTap, required this.visibility}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title,style: TextStyle(fontSize: 16,color: Colors.black),),
          SizedBox(width: 20,),
          Text(data,style: TextStyle(fontSize: 16,color: Colors.black)),
          SizedBox(width: 10,),
          visibility? InkWell(
              onTap:()async {
                Clipboard.setData(ClipboardData(text: data)).then((value){
                  final snackBar=SnackBar(content: Text('Text copied!'),action:SnackBarAction(label: "OK",textColor: Colors.yellowAccent, onPressed: () { ScaffoldMessenger.of(context).removeCurrentSnackBar(); },) ,);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: Icon(Icons.copy,)):Container()
        ],
      ),
    );
  }
}
