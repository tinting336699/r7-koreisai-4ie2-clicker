import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// firebase関連のパッケージ
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import "scenes/registration_scene.dart";
import "helper/values.dart";
import "helper/constants.dart";

// Firestoreのデータベースインスタンスを定義
late final FirebaseFirestore db;

void main() async {
  // Firebase初期化（おまじない）
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // データベースを指定
  db = FirebaseFirestore.instanceFor(
    app: Firebase.app() 
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScoreHolder()),
        ChangeNotifierProvider(create: (_) => NameHolder()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegistrationScene(),
    );
  }
}