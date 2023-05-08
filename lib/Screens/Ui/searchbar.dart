import 'package:flutter/material.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0),
        decoration: const BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    style: BorderStyle.solid,
                    width: 3.0))),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Recetas Populares",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Esta semana",
                  style: TextStyle(
                      color:Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}