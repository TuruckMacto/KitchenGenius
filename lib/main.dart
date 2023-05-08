import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kitchen_genius/Screens/DashBoard/NavBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen_genius/splashScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

const kBackgroundColor = Color(0xFF202020);
const kPrimaryColor = Colors.white;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  await initializeDateFormatting();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove;
  runApp(const Kitchen_Genius());
}

//Inicializar NotificationsPush

class Kitchen_Genius extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const Kitchen_Genius({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, currentMode, child) {
          return MaterialApp( 
            debugShowCheckedModeBanner: false ,
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: SplashScreen()
          );
        });
  }
}
