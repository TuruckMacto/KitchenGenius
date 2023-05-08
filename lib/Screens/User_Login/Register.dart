import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/Screens/User_Login/Login.dart';
import 'package:kitchen_genius/pallete.dart';
import 'package:kitchen_genius/widgets/background-image.dart';
import 'package:kitchen_genius/widgets/signupform.dart';

class UsernamePage extends StatefulWidget {
  final User user;

  UsernamePage({required this.user});

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  void saveUsername(String username) {
    if (user != null) {
      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference.child("users").child(widget.user.uid).set({
        'username': username,
        'followers': 0,
        'recipes': 0,
      });
    }
  }

  bool isChecked = false;

  void toggleCheckbox(bool value) {
    setState(() {
      isChecked = value;
    });
  }

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
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Crea una cuenta",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    Text(
                      "Ya tengo una cuenta",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        Progress();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Iniciar sesion",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: SignUpForm(
                  user: user!,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: CheckBox("Acepto los terminos y condiciones")),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: CheckBox("Tengo 18 años"),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
