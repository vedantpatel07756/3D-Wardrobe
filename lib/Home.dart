import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';

class HomeScreen extends StatefulWidget {
  final String selectedSkintone,selectedFaceType,dress;
    final List<ColorOption> selectedColors;

  const HomeScreen({super.key,
                   required this.selectedSkintone,
                      required this.selectedFaceType,
                      required this.selectedColors, 
                      required this.dress,
   });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = "Fetching data...";

  @override
  void initState() {
    super.initState();
    // fetchData2();
  }

  

  Future<void> fetchData2() async {
    final prefs=await SharedPreferences.getInstance();
    String gender= prefs.getString('gender')??"Male";
    
    // Configuration
      final apiKey = Config.apikey;
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

// TExt 
  String text="•	Suggested clothing types Casual wear  for Female •	Recommended colors and patterns that complement the given Dark Skin tone and Bollywood theme•	Accessories that would enhance the overall look for Freshers  Party •	Hairstyle suggestions suitable for the Square shape Face and Triangle Shape Body";


  final content = [Content.text(text)];
  final response = await model.generateContentStream(content);

  await for (final chunk in response){

    print(chunk.text);

    setState(() {
      result=chunk.text??"Not Fountd";
  });
  }
 

  }

  @override
  Widget build(BuildContext context) {
    print("${widget.dress},${widget.selectedColors[0].color},${widget.selectedFaceType},${widget.selectedSkintone}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobe App Vedant'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Text(result),
        ),
      ),
    );
  }
}
