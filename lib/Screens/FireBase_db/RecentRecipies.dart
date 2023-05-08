import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kitchen_genius/Screens/Utili/Clases/Usermodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen_genius/Screens/UploadKitchen/RecipeInformartion.dart';
import 'package:lottie/lottie.dart';

class RecentRecipes extends StatefulWidget {
  const RecentRecipes({
    super.key,
  });

  @override
  State<RecentRecipes> createState() => _RecentRecipesState();
}
 



class _RecentRecipesState extends State<RecentRecipes> {
   late UserModel _userModel = UserModel(username: "", followers: 0, recipes: 0);
    bool _isLoading = true;
      late Stream<QuerySnapshot<Map<String, dynamic>>> _recipesStream;


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
    return Container(
      color: Colors.white,
      width: 400,
      height: 270,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recipes')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.grey.withOpacity(0.5),
                            Colors.grey.withOpacity(0.3),
                            Colors.grey.withOpacity(0.5),
                          ],
                          stops: const [0.35, 0.5, 0.65],
                        ),
                        child: SizedBox(
                          height: 10,
                          width: 50,
                        ),
                      );
                    }
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Lottie.network(
                            "https://assets5.lottiefiles.com/packages/lf20_szviypry.json"),
                      );
                    }

                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60)),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          String userName = data['username'] ?? '';
                          String userPhoto = data['user_photo'] ?? '';

                          return SizedBox(
                            height: 100,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeScreen(
                                              user: document['username'],
                                              title: document["name"],
                                              imageUrl: document["image"],
                                              instructions:
                                                  document["servings"],
                                              desc: document['description'],
                                              ingredients: List<String>.from(
                                                  document['ingredients']),
                                            )));
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ShaderMask(
                                        shaderCallback: (rect) =>
                                            const LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ).createShader(rect),
                                        blendMode: BlendMode.darken,
                                        child: Container(
                                          height: 200,
                                          width: 330,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(data["image"]),
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                                Colors.black54,
                                                BlendMode.darken),
                                          )),
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Guardado en favoritos");
                                                    },
                                                    icon: const Icon(
                                                      Icons.bookmark_outline,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 2),
                                      child: Text(
                                        document['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(data['description']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Subido por @",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 1,
                                          ),
                                          Text(
                                            '@${_userModel.username}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
