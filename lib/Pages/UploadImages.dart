import 'dart:io';
import 'dart:typed_data';
import 'package:firebase/firebase.dart' as fb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_web_app/Pages/Objects/Images.dart';

class UploadImages extends StatefulWidget {
  final String type;
  const UploadImages({Key? key, required this.type}) : super(key: key);

  @override
  _UploadImagesState createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  bool _isImageShowing=false;
  List<PlatformFile> _uploadImages=[];
  List<Widget> _imageTiles=[];
  List<Images> _uploadedImages=[];
  var status=0;
  var uploadImageSize=0;
 bool _showLoad=false;
  Future<void> _selectImages() async {
    setState(() {
      _isImageShowing=true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if(result != null) {
     _uploadImages=result.files;
     setState(() {
       uploadImageSize=_uploadImages.length;
     });

    setState(() {
    _imageTiles=  _uploadImages.map((e) => ImagePreview(image: e.bytes,name: e.name,)).toList();
      _isImageShowing=true;

    });
    } else {
      // User canceled the picker
    }
  }
//adding data to firebase
  void addDataToFirebase() async{
    fb.Database database=fb.database();
    fb.DatabaseReference databaseReference=database.ref("images");
    setState(() {
      _showLoad=true;
    });
       status=0;
      for( var i in _uploadImages){

        fb.StorageReference storageRef=fb.storage().ref("FramesWeb/${i.name}");
        fb.UploadTaskSnapshot uploadTaskSnapshot=await storageRef.put(i.bytes).future ;
        Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        var withOuText=i.name.split(".");

        Images img=Images(imageUri.toString(),withOuText[0]);
        _uploadedImages.add(img);
        //add to realtime database

       await databaseReference.child(withOuText[0]).set(img.toJson());
       setState(() {
         status++;
       });
      }

    setState(() {
      _showLoad=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showLoad?Center(child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('please wait.uploading.$status/$uploadImageSize')
        ],
      ),):!_isImageShowing? _imageTiles.isEmpty?Center(
        child: InkWell(
        onTap: _selectImages,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min
          ,
          children: [
            Icon(Icons.add_a_photo_outlined,color: Colors.blue,size: 50,),
            Text('Select Images',style: TextStyle(color: Colors.black,fontSize: 16),)
          ],
        ),
      ),):Center(
        child: CircularProgressIndicator(),)  : Container(child: GridView.builder(
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:5,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5

          ),
          itemCount: _imageTiles.length,
          shrinkWrap: true,

          itemBuilder: (context,index){
            return _imageTiles[index];
          }),

      ),
      floatingActionButton: InkWell(
        onTap: addDataToFirebase,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple, Colors.blue]
                )
            ),
            child: SizedBox(
              width: 150,
              height: 50,

              child: Row(
                children: [
                  Icon(Icons.upload_outlined,color: Colors.blue,),
                  Text('Upload Images',style: TextStyle(color: Colors.white,fontSize: 16),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ImagePreview extends StatelessWidget {
  final Uint8List? image;
  final String name;
  const ImagePreview({Key? key, required this.image, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      child: Card(
        child: Column(
          children: [
            Image.memory(image!,width: 150,height: 120,),
            Text(name,style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }
}

