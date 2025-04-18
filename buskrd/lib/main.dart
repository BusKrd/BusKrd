import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:buskrd/screen/splash_screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: "AIzaSyA1r8F1cnW9ZDIf3iRBnmGfxrwZhu7DqFc",
    appId: "1:875415667877:android:311fe4dee48b890d24794c",
    messagingSenderId: "875415667877",
    projectId: "buskrd-14490",
  );

  const FirebaseOptions iosOptions = FirebaseOptions(
    apiKey: "AIzaSyA9d13tUMQvsNVxrwiezvJQctfdtIbXrC0",
    appId: "1:875415667877:ios:5d55238be69896e524794c",
    messagingSenderId: "875415667877",
    projectId: "buskrd-14490",
    iosBundleId: "com.example.buskrd",
    storageBucket: "buskrd-14490.appspot.com",
  );

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp(options: iosOptions);
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(options: androidOptions);
  } else {
    throw UnsupportedError("This platform is not supported.");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BusKRD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 33, 32, 70),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
