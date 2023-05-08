import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitchen_genius/Screens/DashBoard/ScreensSec/Guardado.dart';
import 'package:kitchen_genius/Screens/DashBoard/ScreensSec/Inicio.dart';
import 'package:kitchen_genius/Screens/DashBoard/ScreensSec/Profile.dart';
import 'package:kitchen_genius/Screens/UploadKitchen/Upload.dart';
import 'package:kitchen_genius/Screens/User_Login/Login.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectIndex = 1;

  //Varibales para comprobar si el usuario esta conectado a internet
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox(context);
          setState(() => isAlertSet = true);
        }
      });

  /*ShowDialog, Mostrar un dialogo al usurio para 
      decir que no esta conectado a internet
      */

  showDialogBox(context) => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Conectado'),
          content: const Text('Porfavor revisa tu conexión a internet'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancelar');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox(context);
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

  ShowDialogBack(context) => AlertDialog(
        title: const Text("Seguro que quieres salir?"),
        content: const Text("Aun puedes aprender!"),
        actions: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Si"),
          ),
        ],
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0,3)
              )
            ]
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: GNav(
                rippleColor: Colors.blue[300]!,
                hoverColor: Colors.white,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.black,
                tabs: [
                  GButton(
                    text: "Perfil",
                    icon: Icons.person,
                    iconColor: Colors.white,
                    backgroundColor: Colors.black,
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 13,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                        ),
                      ),
                    ),
                  ),
                  const GButton(
                      text: 'Inicio',
                      icon: Icons.home,
                      iconColor: Colors.black),
                  const GButton(
                      text: 'Subir Receta',
                      icon: Icons.upload,
                      iconColor: Colors.black),
                  const GButton(
                      text: 'Guardado',
                      icon: Icons.bookmark,
                      iconColor: Colors.black)
                ],
                selectedIndex: _selectIndex,
                onTabChange: (selectedindex) {
                  setState(() {
                    _selectIndex = selectedindex;
                  });
                },
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          child: getSelectedWidget(index: _selectIndex),
        ),
      ),
    );
  }

  Future<bool> _onWillPopScope() {
    return ShowDialogBack(context);
  }
}

Widget getSelectedWidget({required int index}) {
  Widget widget;
  switch (index) {
    
    case 0:
      widget = Profile();
      break;
    case 1:
      widget = Inicio();
      break;
    case 2:
      widget = UploadPhoto();
      break;
    default:
      widget = const Guardado();
      break;
  }
  return widget;
}
