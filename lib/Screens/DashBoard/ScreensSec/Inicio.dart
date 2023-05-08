import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitchen_genius/Screens/FireBase_db/RecentRecipies.dart';
import 'package:kitchen_genius/Screens/Ui/Category.dart';
import 'package:kitchen_genius/Screens/Ui/Foodcard.dart';
import 'package:kitchen_genius/Screens/Ui/Inicio_front.dart';
import 'package:kitchen_genius/Screens/Ui/searchbar.dart';
import 'package:kitchen_genius/Screens/UploadKitchen/PopularKitchen.dart';

class Inicio extends StatefulWidget {
  const Inicio({
    super.key,
  });

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final User user = FirebaseAuth.instance.currentUser!;
  final databaseReference = FirebaseDatabase.instance.ref();
  late StreamSubscription subscription;
  final FirebaseAuth auth = FirebaseAuth.instance;

  ShowDialogBack(context) => AlertDialog(
        title: const Text("Seguro que quieres salir?"),
        content: const Text("Aun puedes aprender!"),
        actions: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Si"),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final _firestore = FirebaseFirestore.instance;
     // Formatea la fecha y hora en el formato deseado
    String formattedDate =
        DateFormat('EEEE d' ' MMMM ' 'y', 'es_ES').format(now);
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPopScope,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TopInicio(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Category(),
                      const SizedBox(
                        height: 20,
                      ),
                      const SearchBar(),
                      const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                      Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 15.0),
                        height: 129.0,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: const [
                            PopularKitchen()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: const Text(
                          "Recetas Recientes",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const RecentRecipes(),
                      const SizedBox(
                        height: 5,
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPopScope() {
    return ShowDialogBack(context);
  }
}
