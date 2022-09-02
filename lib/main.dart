import 'package:basic_chat_app/service/shared_preferences_service.dart';
import 'package:basic_chat_app/pages/home_page.dart';
import 'package:basic_chat_app/pages/login_page.dart';
import 'package:basic_chat_app/shared/constants.dart';
import 'package:basic_chat_app/theme/palette_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  //always define the next line at the top.
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constants.apiKey,
        appId: Constants.appId,
        messagingSenderId: Constants.messagingSenderId,
        projectId: Constants.projectId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

enum signInStatus {
  UNKNOWN,
  LOGGED,
  UNLOGGED,
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  signInStatus _isSignedIn = signInStatus.UNKNOWN;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await SharedPreferenceService.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = (value) ? signInStatus.LOGGED : signInStatus.UNLOGGED;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PaletteColor.normalTheme,
      debugShowCheckedModeBanner: false,
      home: pageSelector(),
    );
  }

  Widget pageSelector() {
    switch (_isSignedIn) {
      case signInStatus.UNKNOWN:
        return emptyWidget();
      case signInStatus.LOGGED:
        return const HomePage();
      case signInStatus.UNLOGGED:
        return const LoginPage();
    }
  }

  Widget emptyWidget() {
    return Scaffold(
      body: Container(),
    );
  }
}
