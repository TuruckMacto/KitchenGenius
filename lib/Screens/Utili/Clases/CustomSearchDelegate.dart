import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:kitchen_genius/Screens/UploadKitchen/RecipeInformartion.dart';

class CustomSeachDelegate extends SearchDelegate<dynamic> {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  @override
  String get searchFieldLabel => 'Buscar recetas...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      indicatorColor: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .where('name', isEqualTo: query)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final recipes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeScreen(
                                user: document['username'],
                                title: document["name"],
                                imageUrl: document["image"],
                                instructions: document["servings"],
                                desc: document['description'],
                                ingredients: document['ingredients'],
                              )));
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(recipe['image']),
                    ),
                    title: Text(
                      recipe['name'],
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      recipe['description'],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: query)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoUrl']),
                  ),
                  title: Text(
                    user['displayname'],
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    user['username'],
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle follow button action
                    },
                    child: Text('Follow'),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
}
