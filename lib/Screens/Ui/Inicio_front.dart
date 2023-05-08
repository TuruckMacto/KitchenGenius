import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/Utili/Clases/CustomSearchDelegate.dart';
import 'package:kitchen_genius/Screens/Utili/Clases/Usermodel.dart';

Widget _TopInicio() {
  return _TopInicio();
}

class TopInicio extends StatefulWidget {
  const TopInicio({super.key});

  @override
  State<TopInicio> createState() => _TopInicioState();
}

class _TopInicioState extends State<TopInicio> {
    late Stream<QuerySnapshot<Map<String, dynamic>>> _recipesStream;
  final User user = FirebaseAuth.instance.currentUser!;
  late UserModel _userModel = UserModel(username: "", followers: 0, recipes: 0);
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
      final hour = DateTime.now().hour;
    String gretting;

    if (hour < 12) {
      gretting = "Buenos Dias";
    } else if (hour < 18) {
      gretting = "Buenas Tardes";
    } else {
      gretting = "Buenas Noches";
    }
    return Column(
      children: [
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$gretting",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${_userModel.username}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showSearch(
                          context: context, delegate: CustomSeachDelegate());
                    },
                    child: Container(
                      width: 360,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_outlined,
                            color: Colors.grey[400],
                          ),
                          Text(
                            "Busca Recetas o Perfiles",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        "Categorias",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
      ],
    );
  }
}
