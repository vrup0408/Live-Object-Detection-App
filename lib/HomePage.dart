// import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:obj_detection_app/SubPage.dart';
import 'package:obj_detection_app/main.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isWorking = false;
  String result="";
  late CameraController cameraController;
  late CameraImage imgCamera=initCamera();

  loadModel() async{
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  initCamera()
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
          if(!isWorking){
            isWorking = true,
            imgCamera = imageFromStream,
            runModelOnStreamFrames(),
          }
        });
      });
    });
  }

  runModelOnStreamFrames() async{
    if(imgCamera!=null){
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane) {
          return plane.bytes;
        }).toList(),

        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";

      recognitions!.forEach((response) {
        result += "Object: " + response["label"] + "\nConfidence: " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
      });

      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  @override
  void dispose() async{
    super.dispose();

    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Live Object Detection"),
            backgroundColor: Color(0xffff6f69),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubPage()));
                },
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("assets/jarvis.jpg")
                  // )
                  color: Color(0xffD9D7F1),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color(0xff51E1ED),
                  //     Color(0xff207398)
                  //   ]
                  // )
                ),
            child: Column(
              children: [
                Stack(
                      children: [
                        Center(
                          child: Container(
                            color: Color(0xffFFFDDE),
                            height: 340,
                            width: 600,
                            // child: Image.asset("assets/camera.jpg"),
                          ),
                        ),
                        Center(
                          child: FlatButton(
                            onPressed: (){
                              initCamera();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 35),
                              // height: 270,
                              // width: 360,
                              height: 270,
                              width: 600,
                              child: imgCamera == null
                                  ? Container(
                                height: 270,
                                width: 600,
                                child: Icon(Icons.photo_camera_front, color: Colors.blueAccent, size: 60,),
                              )
                                  : AspectRatio(
                                aspectRatio: cameraController.value.aspectRatio,
                                child: CameraPreview(cameraController),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 55.0),
                        child: SingleChildScrollView(
                          child: Text(
                            result,
                            style: TextStyle(
                              backgroundColor: Color(0xff0E4985),
                              fontSize: 25.0,
                              color: Color(0xff54E346),
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
