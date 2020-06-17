import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

class DisplayPicture extends StatefulWidget {
  final  String imagePath;
  final String predictLink = "http://192.168.1.103:8000/predict";
  final String addLink = "http://192.168.1.103:8000/add";


  const DisplayPicture({Key key, this.imagePath}) : super(key: key);
  DisplayPictureState createState() => DisplayPictureState();

}

class DisplayPictureState extends State<DisplayPicture>{
  String name = "Who is it?";
  String addName ;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _upload(File file,int type) async{
    if (file == null) return;
    if (type == 1){
      FormData formData = new FormData.from({
        "img": new UploadFileInfo(file,  Random().nextInt(9999).toString() + ".jpg")
      });
      var response = await Dio().post(widget.predictLink, data: formData);
      name = response.data;

    }
    if (type == 2){
      if (addName == ""){
        SnackBar(content: Text("Please add the name of person in picture!"));
      }
      else {
        FormData formData = new FormData.from({
          "name" : addName,
          "img": new UploadFileInfo(file,  Random().nextInt(9999).toString() + ".jpg")
        });
        var response = await Dio().post(widget.addLink, data: formData);
        name = response.data;
      }
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    File file = File(widget.imagePath);
    return Scaffold(

      appBar: AppBar(title: Text('Picture')),
      body: Stack(

        children: <Widget>[
          Align(
            alignment: Alignment(0, -1),
            child: Image.file(file,width: 240,height: 360,alignment: Alignment.topCenter,),
          ),
          Align(
            alignment: Alignment(1, 0.9),

            child: FlatButton(
              color: Colors.pink,
              textColor: Colors.white,
              disabledColor: Colors.pink,
              disabledTextColor: Colors.white,
              onPressed: () async {
                _upload(file,1);

              },
              child: Text("Predict"),
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          Align(
            alignment: Alignment(-1, 0.9),
            child: FlatButton(
              color: Colors.pink,
              textColor: Colors.white,
              disabledColor: Colors.pink,
              disabledTextColor: Colors.white,
              child: Text("Add"),
              onPressed: () async {
                addName = myController.text;

                _upload(file,2);

              },
            ),
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: Text(name),
            ),
          Align(
            alignment: Alignment(0, 0.7),
            child: TextField(

              textAlign: TextAlign.center,
              controller: myController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter the name',
                fillColor: Colors.white


              ),
            ),
          ),
        ],
      ),

    );
  }
}