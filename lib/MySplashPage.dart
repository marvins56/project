import 'package:flut/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({Key? key}) : super(key: key);

  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 12,
     navigateAfterSeconds: HomePage(),
      imageBackground: Image.asset("assets/image.jpg").image,
      useLoader: true,
      loaderColor: Colors.pink,
      loadingText: Text('loading',style: TextStyle(color: Colors.white),),

    );
  }
}
