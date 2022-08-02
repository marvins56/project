import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
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
//loading model
  loadModel() async{
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }
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
  imgCamera = imagesFromStream,
  runModelOnStreamFrames(),

}


    });
  });
}

  });
}


  runModelOnStreamFrames() async{
    if(imgCamera != null ){
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: imgCamera.planes.map((plane) {
            return plane.bytes;
          }).toList(),// required
          imageHeight: imgCamera.height,
          imageWidth: imgCamera.width,
          imageMean: 127.5,   // defaults to 127.5
          imageStd: 127.5,    // defaults to 127.5
          rotation: 90,       // defaults to 90, Android only
          numResults: 3,      // defaults to 5
          threshold: 0.1,     // defaults to 0.1
          asynch: true        // defaults to true
      );
      result = "";

      recognitions?.forEach((response) {

        result += response["label"]+ " " + (response["confidence"] as double).toStringAsFixed(3) +"\n\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }
// function called each time someone views the home page
@override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
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
            child: Column(
              children: [
             Stack(
               children: [
                 Center(
                   child: Container(
                     // color: Colors.black,
                     height: 320,
                     width: 330,
                     child: Image.asset("assets/image2.jpg"),
                   ),
                 ),
                 Center(
                   child: TextButton(
                     onPressed: (){
                       initCamera();
                     },

                     child: Container(
                       margin: EdgeInsets.only(top:35),
                       height: 370,
                       width: 360,
                       child:
                       imgCamera == null ? Container(
                         height: 370,
                         width: 360,
                         child: Icon(Icons.photo_camera_front,color: Colors.blueAccent, size: 40,),
                       ): AspectRatio(aspectRatio: cameraController.value.aspectRatio,
                           child: CameraPreview(cameraController)),

                     ),

                   ),
                 ),
               ],
             ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55.0),
                    child: SingleChildScrollView(
                        child: Text(result,
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 30.0,
                        ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
