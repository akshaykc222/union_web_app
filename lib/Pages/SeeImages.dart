import 'dart:async';


import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:union_web_app/Constants.dart';
import 'package:union_web_app/Pages/Objects/Proofs.dart';

class SeeImages extends StatefulWidget {
  final String phone;
  const SeeImages({Key? key, required this.phone}) : super(key: key);

  @override
  _SeeImagesState createState() => _SeeImagesState();
}

class _SeeImagesState extends State<SeeImages> {
  final _imageStream=StreamController<List<String>>();
  List<Proofs> imageList=[];
  int _radioSelected = 1;
  bool _radioVal=false;
  bool _isVisible = true;
  Future<void> getImages() async {

    //print("imageList:${imageList.length}");
   // _imageStream.sink.add(imageList);
   // print("imageStream:${_imageStream.stream.length}");

      Database db=database();
      db.ref("Proofs").orderByChild("phone").equalTo(widget.phone).onValue.listen((event) {
        Map<String,dynamic> data=event.snapshot.val();
        print(data);
        for(var i in data.values){
          setState(() {
            imageList.add(Proofs(i['image'], i['phone']));
          });
        }
       

        print("imageList:${imageList.first}");

      });

  }
  Future<void> getVisibility() async{
  var data=await  FirebaseDatabaseWeb.instance.reference()
        .child('Register')
        .child(widget.phone)
        .once();
  Map<String,dynamic> json=data.value;
  if(json.containsKey('imageVerified')){
    setState(() {
      _isVisible=false;
    });
  }else{
    setState(() {

      _isVisible=true;
    });
  }
  }
  @override
  void initState() {
   getVisibility();
    getImages();
    super.initState();
  }
  @override
  void dispose() {
    _imageStream.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print('widget${imageList.length}');
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            NavigationBarContant(context),
           imageList.length==0?Center(child: CircularProgressIndicator(),):
               GridView.builder(
                  itemCount: imageList.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 3
                   ), itemBuilder: (BuildContext context, int index) {
                      return Padding(padding: EdgeInsets.all(10)
                      ,child: Container(
                        child: Column(
                          children: [
                            InkWell(onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreenImage(imageUrl: imageList[index].image))),
                                child: CachedNetworkImage(imageUrl: imageList[index].image,width: 250,height: 250,placeholder:(context,url)=> Center(child: CircularProgressIndicator(),),)),
                            SizedBox(height: 10,),
                            Visibility(
                              visible: _isVisible,
                                child: Column(
                              children: [
                                Text('Image verified?',style: TextStyle(fontSize: 20),),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(onPressed: (){
                                      FirebaseDatabaseWeb.instance.reference()
                                          .child("Register")
                                          .child(imageList[index].phone)
                                          .update({
                                        'imageVerified':true
                                      }).whenComplete(() {
                                      setState(() {
                                        _isVisible=false;
                                      });
                                      });
                                    }, child: Text('Yes',style: TextStyle(color: Colors.white),),style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)),),
                                    SizedBox(width: 20,),
                                    ElevatedButton(onPressed: (){
                                      FirebaseDatabaseWeb.instance.reference()
                                          .child("Register")
                                          .child(imageList[index].phone)
                                          .update({
                                        'imageVerified':false
                                      }).whenComplete(() {
                                        _isVisible=false;
                                      });
                                    }, child: Text('No',style: TextStyle(color: Colors.white),),style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)),),
                                  ],
                                )
                              ],
                            )
                            )

                          ],
                        ),
                      ),
                      );
                 },
               )

          ],
        ),
      ),
    );
  }
}
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      )
    );
  }
}
