import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/Screens/FirebaseServices/firebase_Services.dart';
import 'package:kitchen_genius/Screens/Ui/EditProfile.dart';
import 'package:kitchen_genius/Screens/User_Login/Login.dart';
import 'package:kitchen_genius/Screens/Utili/Clases/Usermodel.dart';
import 'package:kitchen_genius/pallete.dart';
import 'package:lottie/lottie.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _recipesStream;
  final User user = FirebaseAuth.instance.currentUser!;
  final databaseReference = FirebaseDatabase.instance.ref();

  late UserModel _userModel = UserModel(username: "", followers: 0, recipes: 0);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _recipesStream = FirebaseFirestore.instance
        .collection('recipes')
        .where(
          'userID',
        )
        .snapshots();
    _loadUserData();
  }

  void _loadUserData() async {
    final User user = FirebaseAuth.instance.currentUser!;

    if (user != null) {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("users")
          .child(user.uid)
          .once()
          .then((DatabaseEvent snapshot) {
        // Cambia el tipo de la función
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
        setState(() {
          _userModel = UserModel(
            username: data!['username'],
            followers: data['followers'],
            recipes: data['recipes'],
          );
          _isLoading = false;
        });
      }).catchError((error) {
        print("Error: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mis Perfil',
          style: kBodyForm,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    FirebaseServices().googleSignOut();
                    await Fluttertoast.showToast(msg: 'Sesion cerrada');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
              width: 320,
              height: 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProFilEdit()));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                              FirebaseAuth.instance.currentUser!.photoURL!)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Usuario:",
                    style: kBodyForm,
                  ),
                  Text(
                    '@${_userModel.username}',
                    style:
                        GoogleFonts.roboto(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Seguidores: ${_userModel.followers}'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Recetas subidas: ${_userModel.recipes}'),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(10, 10),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: SizedBox(
                      height: 30,
                      width: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            "Editar",
                            style: kBodyForm,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(25.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Busca tus recetas ',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
