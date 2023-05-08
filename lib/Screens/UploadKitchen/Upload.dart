import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:kitchen_genius/Screens/Ui/AddSteps.dart';
import 'package:kitchen_genius/Screens/Utili/Clases/Usermodel.dart';
import 'package:kitchen_genius/pallete.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({Key? key}) : super(key: key);

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final _formKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();
  final _recipeTimeController = TextEditingController();
  final _recipeServingsController = TextEditingController();
  final _recipedescController = TextEditingController();
  final List<dynamic> _ingredientes = [];
  final List<TextEditingController> _controllers = [];

  void _agregarIngrediente() {
    setState(() {
      _ingredientes.add(_controllers.last.text);
      _controllers.add(TextEditingController());
    });
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> _recipesStream;
  final User user = FirebaseAuth.instance.currentUser!;
  final databaseReference = FirebaseDatabase.instance.ref();

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
    _controllers.add(TextEditingController());
    _recipesStream = FirebaseFirestore.instance
        .collection('recipes')
        .where(
          'userID',
        )
        .snapshots();
    _loadUserData();
  }

  File? _imageFile;
  File? _ImageSteps;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _pickImageSteps() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _ImageSteps = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sube tu receta',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: Padding(
            padding: EdgeInsets.only(left: 10, right: 5, top: 15, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      _submit();
                      await Fluttertoast.showToast(
                          msg: "Agregado correctamente");
                    },
                    child: Text(
                      "Subir receta",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 5, top: 15, bottom: 10),
              child: Container(
                  alignment: Alignment.center,
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Text(
                    '@${_userModel.username}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ))),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () async {
                    PermissionStatus galeryStatus =
                        await Permission.photos.request();
                    if (galeryStatus == PermissionStatus.granted) {
                      _pickImage();
                    }
                    if (galeryStatus == PermissionStatus.denied) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Necesitamos permisos para funcionar correctamente")));
                    }
                    if (galeryStatus == PermissionStatus.permanentlyDenied) {
                      openAppSettings();
                    }
                  },
                  child: _imageFile != null
                      ? Image.file(
                         
                          _imageFile!,
                          height: 200.0,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                              Text(
                                "Pulsa para subir una foto de tu receta",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )),
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: _recipeNameController,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: '  Nombre de la receta',
                              hintStyle: TextStyle(color: Colors.grey),
                              errorStyle: TextStyle(color: Colors.red)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Es necesario el nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: _recipedescController,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: '  Agrega una pequeña descripción',
                              hintStyle: TextStyle(color: Colors.grey),
                              errorStyle: TextStyle(color: Colors.red)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Es necesario la descripción';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Tiempo de preparacion",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              style: kBodytext,
                              keyboardType: TextInputType.multiline,
                              controller: _recipeTimeController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.schedule_outlined,
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30)),
                                  disabledBorder: InputBorder.none,
                                  hintText: 'Ej: 1h:20min',
                                  hintStyle: TextStyle(color: Colors.grey)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Porfavor agrega el tiempo';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Comensal",
                            style: kBodytext,
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              controller: _recipeServingsController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: 'Ej: 5',
                                hintStyle: kBodyForm,
                                disabledBorder: InputBorder.none,
                              ),
                              maxLines: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Agrega el numero de comensales';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Ingredientes",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 240,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: _controllers.length,
                            itemBuilder: (BuildContext context, int index) {
                              for (var i = 0; i < _controllers.length; i++)
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextField(
                                    enabled: false,
                                    controller: _controllers[index],
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        hintText: 'Indrediente: ${index + 1}',
                                        prefixIcon: Icon(
                                          Icons.receipt_long_outlined,
                                          color: Colors.grey,
                                        ),
                                        suffixIcon: GestureDetector(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _controllers.removeAt(i);
                                              });
                                            },
                                          ),
                                        )),
                                  ),
                                );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controllers.last,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      hintText: 'Introduce el ingrediente'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _agregarIngrediente,
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _agregarIngrediente();
                      },
                      child: const Text(
                        "Agregar Ingrediente",
                        style: kBodytext,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Pasos",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [AddSteps()],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final recipeName = _recipeNameController.text;
      final recipeTime = _recipeTimeController.text;
      final recipeServings = _recipeServingsController.text;
      final recipeIngredients =
          _ingredientes.map((ingredients) => ingredients.toString()).toList();
      final recipeDescription = _recipedescController.text;
      final imageFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('recipes/$imageFileName');
      await firebaseStorageRef.putFile(_imageFile!);
      final imageUrl = await firebaseStorageRef.getDownloadURL();

      final recipe = {
        'name': recipeName,
        'time': recipeTime,
        'servings': recipeServings,
        'ingredients': recipeIngredients,
        'image': imageUrl,
        'description': recipeDescription,
        'username': user?.uid,
        'userid': user?.uid,
      };

      await FirebaseFirestore.instance.collection('recipes').add(recipe);

      Navigator.push(context, MaterialPageRoute(builder: (_) => NavBar()));
    }
  }
}
