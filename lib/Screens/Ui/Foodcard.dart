

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

Widget _foodCard() {

    return FoodCard();
  }


class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      width: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.0),
                image:
                    DecorationImage(image: AssetImage("assets/balanced.jpg"))),
            height: 125.0,
            width: 100.0,
          ),
          const SizedBox(width: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Grilled Chicken',
                style: TextStyle(fontFamily: 'Quicksand', color: Colors.black),
              ),
              const Text(
                'con Fruta Salada',
                style: TextStyle(fontFamily: 'Quicksand', color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30)),
                height: 2.0,
                width: 75.0,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text('Alejandro',
                      style: TextStyle(
                          fontFamily: 'Quicksand', color: Colors.black))
                ],
              ),
              Row(
                children: [
                  LikeButton(
                    likeCount: 3,
                    likeBuilder: (istapped) {
                      return Icon(Icons.bookmark,
                          color: istapped ? Colors.red : Colors.black);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  LikeButton(
                    likeCount: 1,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
