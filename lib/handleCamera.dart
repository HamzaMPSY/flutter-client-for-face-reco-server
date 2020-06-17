import 'dart:async';
import 'package:camera/camera.dart';
import 'package:faces_reco/display.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:faces_reco/main.dart';


class Camera extends StatefulWidget  {
  List<CameraDescription> cameras;
  Camera(this.cameras);
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int cam = 1;

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      _initializeControllerFuture = _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    }
    catch (e) {
      print(e);
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription =
          cameras.firstWhere((description) => description.lensDirection ==
              CameraLensDirection.back);
    }
    else {
      newDescription =
          cameras.firstWhere((description) => description.lensDirection ==
              CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    }
    else {
      print('Asked camera not available');
    }
  }

  @override
  void initState(){
    super.initState();
    _initCamera(cameras[cam]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture'),actions: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.swap_horizontal_circle),
            onPressed: (){
              _toggleCameraLens();
            },
          ),
        )
      ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPicture(imagePath : path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}