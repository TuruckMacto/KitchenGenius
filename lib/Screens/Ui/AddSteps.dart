import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen_genius/pallete.dart';
import 'package:permission_handler/permission_handler.dart';

Widget _AddSteps() {
  return AddSteps();
}

class AddSteps extends StatefulWidget {
  const AddSteps({
    super.key,
  });

  @override
  State<AddSteps> createState() => _AddStepsState();
}

class _AddStepsState extends State<AddSteps> {
  final _formKey = GlobalKey<FormState>();
  final _stepTextController = TextEditingController();
  File? _imageSteps;
  List<String> _steps = [];
  List<File> _stepImages = [];

  @override
  void dispose() {
    _stepTextController.dispose();
    super.dispose();
  }

  void _pickImageSteps() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageSteps = File(pickedFile.path);
      });
    }
  }

  void _addStep() {
    setState(() {
      _steps.add(_stepTextController.text);
      _stepImages.add(_imageSteps!);
      _stepTextController.clear();
      _imageSteps = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
           ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _steps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(_steps[index]),
                        trailing: _stepImages[index] != null
                            ? Image.file(_stepImages[index])
                            : null, // Mostrando la imagen del paso si existe
                      );
                    }),
                    SizedBox(height: 5,),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                  ),
                  child: TextFormField(
                    controller: _stepTextController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '   Agrega los pasos',
                        
                        hintStyle: kBodyForm),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    PermissionStatus galleryStatus =
                        await Permission.photos.request();
                    if (galleryStatus == PermissionStatus.granted) {
                      _pickImageSteps();
                    }
                    if (galleryStatus == PermissionStatus.denied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Necesitamos permisos para funcionar correctamente",
                          ),
                        ),
                      );
                    }
                    if (galleryStatus == PermissionStatus.permanentlyDenied) {
                      openAppSettings();
                    }
                  },
                  child: _imageSteps != null
                      ? Image.file(
                          _imageSteps!,
                          height: 50,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: _addStep,
                        icon: Icon(
                          Icons.add_outlined,
                          color: Colors.grey,
                        )),
                    TextButton(onPressed: _addStep, child: Text('Agregar paso', style: TextStyle(color: Colors.grey),),)
                  ],
                ),
                SizedBox(
                  height: 29,
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
