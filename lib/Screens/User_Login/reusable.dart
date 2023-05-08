import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/FirebaseServices/firebase_Services.dart';
import 'package:kitchen_genius/Screens/User_Login/Register.dart';
import 'package:kitchen_genius/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void SignInMethodGA(context) {
  final TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  late final User? user = FirebaseAuth.instance.currentUser;

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

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40))),
    context: context,
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Registrate",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
          ),
          SizedBox(
            height: 19,
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                elevation: 30,
                onPressed: () async {
                  Progress();
                  var sharedpref = await SharedPreferences.getInstance();
                  sharedpref.setBool(SplashScreenState.KEYLOGIN, true);
                  await FirebaseServices().signInWithGoogle();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UsernamePage(user: user!)));
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/google.png",
                      width: 30,
                    ),
                    const Spacer(),
                    const Text("Registrate con Google",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
            SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                elevation: 30,
                onPressed: () async {},
                color: Color.fromARGB(255, 0, 106, 244),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 0, 106, 244),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/facebook.png",
                      width: 30,
                    ),
                    const Spacer(),
                    const Text("Registrate con Facebook",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}
