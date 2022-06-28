import 'package:flutter/material.dart';
import 'package:obj_detection_app/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({Key? key}) : super(key: key);

  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 12,
      navigateAfterSeconds: HomePage(),
      imageBackground: Image.asset("assets/back.jpg").image,
      useLoader: true,
      loaderColor: Color(0xff1A237E),
      loadingText: Text("Loading... Please wait...", style: TextStyle(color: Color(0xff797EF6), fontSize: 20),),
    );
  }
}
