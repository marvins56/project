import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'main.dart';



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage  imgCamera;

  //initialising camera
  initCamera(){

  cameraController = CameraController(cameras[0], ResolutionPreset.medium);
  cameraController.initialize().then((value){
if(!mounted){
  return;
}
else{
  setState(() {
    cameraController.startImageStream((imagesFromStream) => {
if(!isWorking){
  isWorking = true,
  imgCamera = imagesFromStream

}


    });
  });
}

  });
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image2.jpg")
              ),

            ),
          ),
        ),
      ),
    );
  }
}
