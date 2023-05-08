import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListaRecetas extends StatefulWidget {
  final String categoria;
  const ListaRecetas({Key? key, required this.categoria}) : super(key: key);

  @override
  State<ListaRecetas> createState() => _ListaRecetasState();
}

class _ListaRecetasState extends State<ListaRecetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          widget.categoria,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    );
  }
}
