import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/dashboard.dart';
import 'package:wardrope_app/Home.dart'; // Ensure this import matches your project's structure
import 'dart:io';

import 'package:wardrope_app/Starter/first.dart';

Future<void> main() async {
  // Print the current working directory
  // print("Current working directory: ${Directory.current.path}");

  // try {
  //   await dotenv.load(fileName: ".env");
  //   print("Loaded .env file from: ${File('.env').absolute.path}");
  // } catch (e) {
  //   print('Error loading .env file: $e');
  //   exit(1);
  // }

  final apiKey = Config.apikey;
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }

  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  runApp(MyApp(model: model));
}

class MyApp extends StatelessWidget {
  final GenerativeModel model;

  const MyApp({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Wardrobe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Config.secondaryColor,
                                           primary: Config.primaryColor,
        ),
        useMaterial3: true,
      ),
      home: FirstPage(),
    );
  }
}
