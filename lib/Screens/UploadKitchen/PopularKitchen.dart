import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/UploadKitchen/RecipeInformartion.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

Widget _PopularKitchen() {
  return PopularKitchen();
}

class PopularKitchen extends StatelessWidget {
  const PopularKitchen({
    super.key,
  });
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
                              child: Container(
                                height: 125,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 125.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(data['image']),
                                              fit: BoxFit.cover,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.black26,
                                                      BlendMode.darken))),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['name'],
                                          style: GoogleFonts.quicksand(
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          height: 2.0,
                                          width: 75.0,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 25.0,
                                              width: 25.0,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5),
                                                  image: DecorationImage(
                                                      image:
                                                          NetworkImage("${FirebaseAuth.instance.currentUser!.photoURL}"))),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(document['username'])
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      ).toList(),
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
