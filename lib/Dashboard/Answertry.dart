import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';
import 'package:wardrope_app/Dashboard/dashboard.dart';
import 'package:wardrope_app/GenerateImage/image.dart';
import 'package:http/http.dart' as http;

class Answertry extends StatefulWidget {
  final String selectedSkintone, selectedFaceType, dress;
  final List<ColorOption> selectedColors;

  const Answertry({
    super.key,
    required this.selectedSkintone,
    required this.selectedFaceType,
    required this.selectedColors,
    required this.dress,
  });

  @override
  _ANSWERPageState createState() => _ANSWERPageState();
}

class _ANSWERPageState extends State<Answertry> {
  String fullResponse = '';
  bool isLoading = true;
  bool isDarkMode = true;
  String? _imageUrl; // Updated to allow null
 Uint8List? _imageBytes; // Use Uint8List to hold the image bytes
  @override
  void initState() {
    super.initState();
    fetchData2();
  }

   Future<void> generateImage(String prompt) async {
    var url = Uri.parse("https://api.stability.ai/v2beta/stable-image/generate/core");
    var headers = {
      'authorization': 'Bearer sk-wDMdt6SKq2W65E6b3RwRCVGKTuKL0ci8H0lzoDVJ2FfZK5ez',
      'accept': 'image/*', // To receive the image in the specified format
    };

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['prompt'] = prompt
      ..fields['output_format'] = 'webp'; // Specify the desired output format

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Success");
      var bytes = await response.stream.toBytes();

      setState(() {
        _imageBytes = bytes; // Update your UI to display the image from these bytes
      });
    } else {
      setState(() {
        _imageBytes = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate image")),
        );
      });
    }
  }

  Future<void> fetchData2() async {
    final prefs = await SharedPreferences.getInstance();
    String gender = prefs.getString('gender') ?? "Male";

    // Configuration
    final apiKey = Config.apikey;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(
        "You are an AI Fashion Advisor. Based on the user's gender and face type, provide personalized fashion recommendations. The user will select their gender (Male/Female) and face type (Diamond, Heart, Oval, Rectangle, Round, Square), as well as the dressing style they prefer (Formal, Traditional, Casual)."
        "\n\n  Make Sure To Complete Your Answer in 5 Line."
      ),
    );

    // Constructing the color list
    String colorList = widget.selectedColors
        .map((colorOption) => '${colorOption.name} (${colorOption.color.toString()})')
        .join(', ');

    // Constructing the prompt
    String text = '''
      • Suggested clothing types ${widget.dress} wear for $gender
      • Recommended colors and patterns that complement the given ${widget.selectedSkintone} skin tone and ${widget.dress} theme. Selected colors: $colorList.
      • Accessories that would enhance the overall look for the selected occasion
      • Hairstyle suggestions suitable for the ${widget.selectedFaceType} shape face
    ''';

    final content = [Content.text(text)];
    final response = await model.generateContentStream(content);

    await for (final chunk in response) {
      setState(() {
        fullResponse += chunk.text?.replaceAll('*', '').trim() ?? "";
      });
    }

    setState(() {
      isLoading = false;
    });

    await generateImage(fullResponse);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Config.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Config.primaryColor,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset("assets/app_icon/check.png"),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Fashion Recommendations:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: _imageUrl != null
                            ? Image.memory(_imageBytes!)
                            : Center(child: Text('')),
                      ),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            setState(() {
                              _imageUrl = null;
                            });
                            await generateImage(fullResponse);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                isLoading
                    ? TypingAnimation()
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          fullResponse,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.accentColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Go to Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TypingAnimation extends StatefulWidget {
  @override
  _TypingAnimationState createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Fetching recommendations...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 10),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Transform.scale(
                        scale: _controller.value * 0.5 + 0.5,
                        child: Icon(
                          Icons.circle,
                          size: 8.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
