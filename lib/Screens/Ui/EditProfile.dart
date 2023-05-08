import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProFilEdit extends StatefulWidget {
  const ProFilEdit({super.key});

  @override
  State<ProFilEdit> createState() => _ProFilEditState();
}

class _ProFilEditState extends State<ProFilEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 400,
            height: 100,
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL!)),
            ),
          )
        ],
      ),
    );
  }
}
