import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:faces_reco/handleCamera.dart';
List<CameraDescription> cameras ;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Home()
    ),
  );
}

class Home extends StatefulWidget{
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Welcome to Face Recognition')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/sanstitre.png"),
            fit : BoxFit.fill,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Camera(cameras)
          ));
        },
        child: Icon(Icons.add_a_photo),
      ),

    );
  }
}
