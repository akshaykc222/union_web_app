import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_web_app/Constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:union_web_app/Pages/Objects/Gates.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Forms();
  }
}
class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  bool _uploading=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _gateCode=TextEditingController();
  TextEditingController _gateDesc=TextEditingController();
  TextEditingController _gateCost=TextEditingController();
  TextEditingController _gateImg=TextEditingController();
  Uint8List? fileBytes;
  String fileName="";
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _uploading=true;
    });
    uploadImage();
  }
  Future<void> uploadImage() async {
    if(fileBytes!.isEmpty){
      print('empty');
      final snackBar=SnackBar(content: Text('Please Select Image'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      print('loading');
      StorageReference storageReference=fb.storage().ref("gates/$fileName");
      fb.UploadTaskSnapshot uploadTaskSnapshot=await storageReference.put(fileBytes).future ;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      addToFirebase(imageUri.toString());
    }

  }
  void addToFirebase(String url){
    print('adding');
    Database db=database();
    DatabaseReference ref=db.ref("Gates");
    var range=rangeRe();
    Gates gates=Gates(_gateCode.text,_gateDesc.text,double.parse(_gateCost.text),url);
    print(gates.toJson());
    ref.child(range).push().set(gates.toJson() ).whenComplete(() {
      print('completed');
      setState(() {
       // _formKey.currentState!.reset();
        _uploading=false;
        _gateCost.text="";
        _gateDesc.text="";
        _gateCode.text="";
        _gateImg.text="";

      });
    }).onError((error, stackTrace) => print(error));
  }
  String rangeRe(){

    var price=double.parse(_gateCost.text);
    var range;
    if(price<=30000){
      range=30000;
    }else if(price>30000 && price<=50000){
      range=50000;
    }else if(price>50000 && price <=70000){
      range=70000;
    }else if(price>70000){
      range=80000;
    }
    return range.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_uploading?Container(child: Center(child: CircularProgressIndicator(),),): Column (
         children: [
           NavigationBarContant(context),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text("Add Gate To Library",style: TextStyle(color: Colors.black,fontSize: 25),),
           ),
           SizedBox(height: 25,),
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Container(
               width: MediaQuery.of(context).size.width*0.5,
               child: Form(

                 key: _formKey,
                 child: Column(
                   children: [
                     _formFiled(_gateCode, "Gate Code :"),
                     SizedBox(height: 20,),
                     _formFiled(_gateDesc, "Gate Description :"),
                     SizedBox(height: 20,),
                     _formFiled(_gateCost, "Gate Cost :"),
                     SizedBox(height: 20,),
                     TextFormField(

                       controller: _gateImg,
                       validator: (value){
                         if(value!.isEmpty){
                           return "Empty field";
                         }
                         return null;
                       },
                       onTap: () async {
                         FilePickerResult? result = await FilePicker.platform.pickFiles();

                         if (result != null) {
                           fileBytes = result.files.first.bytes;
                            fileName = result.files.first.name;
                           _gateImg.text=fileName;

                         }
                       },
                       decoration: InputDecoration(
                         labelText: "Image",
                         hintText: "Select Image",
                         // If  you are using latest version of flutter then lable text and hint text shown like this
                         // if you r using flutter less then 1.20.* then maybe this is not working properly
                         floatingLabelBehavior: FloatingLabelBehavior.auto,
                         border: OutlineInputBorder(),
                       ),
                     )
                   ],
                 ),
               ),
             ),
           ),
           SizedBox(height: 20,),
           InkWell(
             onTap: _submit,
             child: Container(
               width: MediaQuery.of(context).size.width*0.1,
               height: 50,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.red
               ),
               child: Center(child: Text('Add',style: TextStyle(color: Colors.white),)),
             ),
           )
         ]
      ),
    );
  }
}

Widget _formFiled(TextEditingController _controller,String label){
  return TextFormField(

    controller: _controller,
    validator: (value){
      if(value!.isEmpty){
        return "Empty field";
      }
      return null;
    },
    inputFormatters:label=="Gate Cost :"?[FilteringTextInputFormatter.allow(RegExp('^[0-9]+[0-9.]*\$'))]:[],

    decoration: InputDecoration(
      labelText: label,
      hintText: "Enter $label",

      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(),
    ),
  );
}