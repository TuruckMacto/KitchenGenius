import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';

class SignUpForm extends StatefulWidget {
  final User user;
  SignUpForm({required this.user});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  final TextEditingController _usernameController = TextEditingController();
  void saveUsername(String username) {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("users").child(widget.user.uid).set({
      'username': username,
      'followers': 0,
      'recipes': 0,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('@Nombre de Usuario', false),
        buildInputemail('${FirebaseAuth.instance.currentUser!.email}', false),
        Button('Registrate', false)
      ],
    );
  }

  Padding buildInputForm(String hint, bool pass) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: _usernameController,
          style: TextStyle(color: Colors.white),
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ))
                : null,
          ),
        ));
  }

  Padding buildInputemail(String hint, bool pass) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          enabled: false,
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ))
                : null,
          ),
        ));
  }

  Padding Button(String hint, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            String username = _usernameController.text;
            if (username.isNotEmpty) {
              saveUsername(username);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => NavBar()));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            )
          ),
          child: Text('Registrate', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  final String text;
  const CheckBox(this.text);
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: _isSelected
                    ? Icon(
                        Icons.check,
                        size: 17,
                        color: Colors.green,
                      )
                    : null,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              widget.text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
