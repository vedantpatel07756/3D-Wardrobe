
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';
import 'package:wardrope_app/Dashboard/dashboard.dart';

class ANSWERPage extends StatefulWidget {
  final String selectedSkintone, selectedFaceType, dress;
  final List<ColorOption> selectedColors;

  const ANSWERPage({
    super.key,
    required this.selectedSkintone,
    required this.selectedFaceType,
    required this.selectedColors,
    required this.dress,
  });

  @override
  _ANSWERPageState createState() => _ANSWERPageState();
}

class _ANSWERPageState extends State<ANSWERPage> {
  List<String> chunks = [];
  bool isLoading = true;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    fetchData2();
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
        "\n\nUse the following guidelines:"
        "\n\n1. Face Type Descriptions:"
        "\n   - Diamond: Narrow forehead and jawline with wider cheekbones."
        "\n   - Heart: Wider forehead and a narrower chin, resembling a heart."
        "\n   - Oval: Longer than it is wide, with a rounded jawline."
        "\n   - Rectangle: Longer than it is wide, with a squared jawline and hairline."
        "\n   - Round: Almost as wide as it is long, with a rounded jawline and hairline."
        "\n   - Square: Strong, angular jawline and a broad forehead."
        "\n\n2. Fashion Style Categories:"
        "\n   - Formal: Provide suggestions for formal wear."
        "\n   - Traditional: Provide suggestions for traditional wear."
        "\n   - Casual: Provide suggestions for casual wear."
        "\n\n3. Gender-Specific Recommendations:"
        "\n   - For males: Provide fashion recommendations based on the selected face type and dressing style."
        "\n   - For females: Provide fashion recommendations based on the selected face type and dressing style."
        "\n\n4. Accessory Suggestions:"
        "\n   - Recommend accessories that complement the suggested outfits."
        "\n\n5. Color Coordination:"
        "\n   - Suggest color combinations that enhance the user's overall look based on their selected face type and style preferences."
        "\n\n6. Customization Options:"
        "\n   - Allow users to customize their preferences by specifying colors, patterns, and fabric types they prefer or want to avoid."
        "\n\n7. Seasonal and Event-Based Recommendations:"
        "\n   - Offer recommendations based on the current season and upcoming events."
        "\n\nPlease provide the recommendations in a structured format, with separate sections for each face type and dressing style, along with images if available."
         "\n\nMake Sure To Complete Your Answer in 5 Line."
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
        chunks.add(chunk.text?.replaceAll('*', '').trim() ?? "");
      });
    }

    setState(() {
      isLoading = false;
    });
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
        body: Padding(
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
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: chunks.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          chunks[index],
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading) CircularProgressIndicator(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add navigation or other actions
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
    );
  }
}
