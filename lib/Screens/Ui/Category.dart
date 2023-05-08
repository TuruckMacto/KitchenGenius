import 'package:flutter/material.dart';
import 'package:kitchen_genius/Screens/Ui/CategortList.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> categorias = [
    'Desayunos',
    'Almuerzos',
    'Cena',
    'Postres',
    'Comida saludable',
    'Comida Vegana',
    'Comida sin gluten',
    'Comida sin lactosa',
    'Comida internacional',
  ];
  String categoriaSeleccionada = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  categoriaSeleccionada = categorias[index];
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ListaRecetas(categoria: categorias[index])));
              },
              style: TextButton.styleFrom(
                  backgroundColor: categoriaSeleccionada == categorias[index]
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0)),
              child: Text(
                categorias[index],
                style: TextStyle(
                    color: categoriaSeleccionada == categorias[index]
                        ? Colors.white
                        : Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
