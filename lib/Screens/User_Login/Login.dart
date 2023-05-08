import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/Screens/FirebaseServices/firebase_Services.dart';
import 'package:kitchen_genius/Screens/User_Login/reusable.dart';
import 'package:kitchen_genius/main.dart';
import 'package:kitchen_genius/splashScreen.dart';
import 'package:kitchen_genius/widgets/background-image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future Progress() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.blue,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(
          image: 'assets/Images/login_bg.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    'Kitchen Genius',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Text(
                "Bienvenido, Inicia sesion",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                height: 30,
              ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(
                  width: 50,
                  child: InkWell(
                    onTap: () async {
                      Progress();
                    var Sharedpref = await SharedPreferences.getInstance();
                    Sharedpref.setBool(SplashScreenState.KEYLOGIN, true);
                    await FirebaseServices().signInWithGoogle();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavBar()));
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/google.png",
                          scale: 2,
                          ),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
               SizedBox(
                  width: 50,
                  child: InkWell(
                    onTap: () async {
                      Progress();
                    var Sharedpref = await SharedPreferences.getInstance();
                    Sharedpref.setBool(SplashScreenState.KEYLOGIN, true);
                    await FirebaseServices().signInWithGoogle();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavBar()));
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/facebook.png",
                          scale: 4,
                          ),
                    ),
                  )),
              ],
             ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No tienes Cuenta?  ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      SignInMethodGA(context);
                    },
                    child: const Text(
                      "Registrate aqui",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        )
      ],
    );
  }
}
