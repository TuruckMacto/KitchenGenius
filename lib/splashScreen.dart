import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/Screens/User_Login/Login.dart';
import 'package:kitchen_genius/widgets/background-image.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = "Login";

  @override
  void initState() {
    super.initState();
    GoogleGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              const BackgroundImage(
                image: 'assets/Images/Fondo.jpg',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    "assets/Lottie/Cooking.json",
                    width: 900,
                    height: 600,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (Platform.isIOS)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                    )
                  else
                    CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Preparando Ingredientes",
                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void GoogleGo() async {
    var SharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = SharedPref.getBool(KEYLOGIN);

    if (isLoggedIn != null) {
      if (isLoggedIn) {
        Future.delayed(const Duration(seconds: 6), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NavBar()));

            Fluttertoast.showToast(msg: "Bienvenido de vuelta",
            textColor: Colors.white,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            );

        });
      } else {
        Future.delayed(const Duration(seconds: 6), () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 6), () async{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
