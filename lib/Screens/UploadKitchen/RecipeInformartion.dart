import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/pallete.dart';

class RecipeScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String instructions;
  final String desc;
  final String user;
  final List<dynamic> ingredients; // Nuevo parámetro

  RecipeScreen(
      {required this.title,
      required this.imageUrl,
      required this.instructions,
      required this.ingredients,
      required this.user,
      required this.desc});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool _expandir = false;
  // ..

  void _validationback(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.black,
            content: Text(
              "Seguro que quieres salir?",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white),
                  )),
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Si", style: TextStyle(color: Colors.white)))
            ],
          );
        });
    if (result) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => NavBar()));
    } else
      (result) {
        Navigator.of(context).pop();
      };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 10,
                backgroundColor: Colors.black,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                          },
                          icon: Icon(
                            Icons.bookmark_outline,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
                centerTitle: true,
                stretch: true,
                snap: true,
                floating: true,
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.title,
                    style: GoogleFonts.secularOne(color: Colors.white),
                  ),
                  background: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverFillRemaining(
                  fillOverscroll: false,
                  hasScrollBody: true,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.all(20)),
                          Icon(Icons.microwave_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.title,
                            style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _expandir = !_expandir;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.desc,
                                      textAlign: TextAlign.justify,
                                      overflow: _expandir
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              )
                            ],
                          )),
                      //Ingredientes <3
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(
                          children: [
                            Text(
                              "Ingredientes",
                              style: GoogleFonts.roboto(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                  '${index + 0}:  ${widget.ingredients[index]}'),
                              trailing: const Icon(
                                Icons.receipt_long_outlined,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
