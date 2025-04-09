// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wardrope_app/Config.dart';
// import 'package:wardrope_app/Dashboard/colorSelect.dart';
// import 'package:wardrope_app/Dashboard/dashboard.dart';
// import 'package:wardrope_app/GenerateImage/image.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class ANSWERPage2 extends StatefulWidget {
//   final String selectedSkintone, selectedFaceType, dress;
//   final List<ColorOption> selectedColors;

//   const ANSWERPage2({
//     super.key,
//     required this.selectedSkintone,
//     required this.selectedFaceType,
//     required this.selectedColors,
//     required this.dress,
//   });

//   @override
//   _ANSWERPageState createState() => _ANSWERPageState();
// }

// class _ANSWERPageState extends State<ANSWERPage2> {
//   String fullResponse = '';
//   bool isLoading = true;
//   bool isDarkMode = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData2();
//   }

//   Future<void> fetchData2() async {
//     final prefs = await SharedPreferences.getInstance();
//     String gender = prefs.getString('gender') ?? "Male";

//     // Configuration
//     final apiKey = Config.apikey;
//     if (apiKey == null) {
//       print('No \$API_KEY environment variable');
//       exit(1);
//     }

//     final model = GenerativeModel(
//       model: 'gemini-1.5-flash', 
//       apiKey: apiKey,
//       systemInstruction: Content.text(
//         "You are an AI Fashion Advisor. Based on the user's gender and face type, provide personalized fashion recommendations. The user will select their gender (Male/Female) and face type (Diamond, Heart, Oval, Rectangle, Round, Square), as well as the dressing style they prefer (Formal, Traditional, Casual)."
//         "\n\nUse the following guidelines:"
//         "\n\n1. Face Type Descriptions:"
//         "\n   - Diamond: Narrow forehead and jawline with wider cheekbones."
//         "\n   - Heart: Wider forehead and a narrower chin, resembling a heart."
//         "\n   - Oval: Longer than it is wide, with a rounded jawline."
//         "\n   - Rectangle: Longer than it is wide, with a squared jawline and hairline."
//         "\n   - Round: Almost as wide as it is long, with a rounded jawline and hairline."
//         "\n   - Square: Strong, angular jawline and a broad forehead."
//         "\n\n2. Fashion Style Categories:"
//         "\n   - Formal: Provide suggestions for formal wear."
//         "\n   - Traditional: Provide suggestions for traditional wear."
//         "\n   - Casual: Provide suggestions for casual wear."
//         "\n\n3. Gender-Specific Recommendations:"
//         "\n   - For males: Provide fashion recommendations based on the selected face type and dressing style."
//         "\n   - For females: Provide fashion recommendations based on the selected face type and dressing style."
//         "\n\n4. Accessory Suggestions:"
//         "\n   - Recommend accessories that complement the suggested outfits."
//         "\n\n5. Color Coordination:"
//         "\n   - Suggest color combinations that enhance the user's overall look based on their selected face type and style preferences."
//         "\n\n6. Customization Options:"
//         "\n   - Allow users to customize their preferences by specifying colors, patterns, and fabric types they prefer or want to avoid."
//         "\n\n7. Seasonal and Event-Based Recommendations:"
//         "\n   - Offer recommendations based on the current season and upcoming events."
//         "\n\nPlease provide the recommendations in a structured format, with separate sections for each face type and dressing style, along with images if available."
//         "\n\nMake Sure To Complete Your Answer in 5 Line."
//       ),
//     );

//     // Constructing the color list
//     String colorList = widget.selectedColors
//         .map((colorOption) => '${colorOption.name} (${colorOption.color.toString()})')
//         .join(', ');

//     // Constructing the prompt
//     String text = '''
//       • Suggested clothing types ${widget.dress} wear for $gender
//       • Recommended colors and patterns that complement the given ${widget.selectedSkintone} skin tone and ${widget.dress} theme. Selected colors: $colorList.
//       • Accessories that would enhance the overall look for the selected occasion
//       • Hairstyle suggestions suitable for the ${widget.selectedFaceType} shape face
//     ''';

//     final content = [Content.text(text)];
//     final response = await model.generateContentStream(content);

//     await for (final chunk in response) {
//       setState(() {
//         fullResponse += chunk.text?.replaceAll('*', '').trim() ?? "";
//       });
//     }

//     setState(() {
//       isLoading = false;
//     });

    
//     await generateImage(fullResponse);
//   }


//   // Generate Image 

//    String? _imageUrl; // Updated to allow null

//   Future<void> generateImage(String prompt) async {
//     var url = Uri.parse("https://modelslab.com/api/v6/realtime/text2img");
//     var headers = {
//       'Content-Type': 'application/json'
//     };
//     var body = json.encode({
//       "key": "8ixtgVQfiYxIfenUSzDGMXhrH0p3RWs4CdJAjy79xFMmkWRbe9xZe1j9axJt",  // Add your key here
//       "prompt": "${prompt}",
//       "negative_prompt": "bad quality",
//       "width": "512",
//       "height": "512",
//       "safety_checker": false,
//       "seed": null,
//       "samples": 1,
//       "base64": false,
//       "webhook": null,
//       "track_id": null
//     });

//     var response = await http.post(url, headers: headers, body: body);
//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);
//       print(jsonResponse);
//       setState(() {
//         _imageUrl = jsonResponse['output'][0];
//       });
//     } else {
//       setState(() {
//         _imageUrl = null;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Request failed with status: ${response.statusCode}.')),
//         );
//       });
//     }
//   }


//   Future<void> _handleRefresh() async {
//     setState(() {
//       isLoading = true;
//     });
//     await fetchData2();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(fullResponse);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Config.primaryColor,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: Config.primaryColor,
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Image.asset("assets/app_icon/check.png"),
//           backgroundColor: isDarkMode ? Colors.black : Colors.white,
//           actions: [
//             IconButton(
//               icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
//               onPressed: () {
//                 setState(() {
//                   isDarkMode = !isDarkMode;
//                 });
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Your Fashion Recommendations:',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),

//                // Generate Image 
//               SizedBox(
//                 height: 300,
//                 // width: 200,
//                 child: Row(
//                   children: [
//                     Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
                        
//                                 SizedBox(height: 20),
//                                 _imageUrl != null 
//                       ? Expanded(
//                           child: Image.network(_imageUrl!),
//                         )
//                       : Text(''),
//                               ],
//                             ),
//                           ),

//                        SizedBox(
//                         height: 10,
//                          child: GestureDetector(
//                           onTap:() async {
//                                 print("Refresh");
//                                if (fullResponse.isNotEmpty) {
//                                  await generateImage(fullResponse);
//                                } else {
//                                  // If fullResponse is empty or null, you might want to handle this case
//                                  // For example, you could show a message or fetch new data
//                                  print('No response to generate image from.');
//                                }
//                              },
//                            child:  Icon(Icons.refresh)
//                          ),
//                        )  
//                   ],
//                 ),
//               ),

//               // Generate Image 
//               // GenerateImageWidget(),
//               SizedBox(height: 16),
//               Expanded(
//                 child: isLoading ? TypingAnimation() : SingleChildScrollView(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 5),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         fullResponse,
//                         style: TextStyle(
//                           fontSize: 16,
//                           height: 1.5,
//                           color: isDarkMode ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // // Generate Image 
//               // SizedBox(
//               //   height: 300,
//               //   child: Padding(
//               //           padding: const EdgeInsets.all(16.0),
//               //           child: Column(
//               //             children: [
                    
//               //               SizedBox(height: 20),
//               //               _imageUrl != null 
//               //     ? Expanded(
//               //         child: Image.network(_imageUrl!),
//               //       )
//               //     : Text('No image generated yet.'),
//               //             ],
//               //           ),
//               //         ),
//               // ),

//               // // Generate Image 
//           // SizedBox(height: 16),
//           //      SizedBox(
//           //       height: 300, // Adjust height as needed
//           //       child: GenerateImageWidget(),
//           //     ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GenerateImageWidget()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Config.accentColor,
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 child: Text(
//                   'Go to Dashboard',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TypingAnimation extends StatefulWidget {
//   @override
//   _TypingAnimationState createState() => _TypingAnimationState();
// }

// class _TypingAnimationState extends State<TypingAnimation> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }


 

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Fetching recommendations...',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           SizedBox(height: 10),
//           AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               return Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   for (int i = 0; i < 3; i++)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                       child: Opacity(
//                         opacity: (1.0 - (((_controller.value + (i / 3)) % 1.0) * 2.0 - 1.0).abs()),
//                         child: const Dot(),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Dot extends StatelessWidget {
//   const Dot();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 8,
//       height: 8,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';
import 'package:wardrope_app/Dashboard/dashboard.dart';
import 'package:wardrope_app/GenerateImage/image.dart';
import 'package:http/http.dart' as http;

class ANSWERPage2 extends StatefulWidget {
  final String selectedSkintone, selectedFaceType, dress;
  final List<ColorOption> selectedColors;

  const ANSWERPage2({
    super.key,
    required this.selectedSkintone,
    required this.selectedFaceType,
    required this.selectedColors,
    required this.dress,
  });

  @override
  _ANSWERPageState createState() => _ANSWERPageState();
}

class _ANSWERPageState extends State<ANSWERPage2> {
  String fullResponse = '';
  bool isLoading = true;
  bool isDarkMode = true;
  String? _imageUrl; // Updated to allow null

  @override
  void initState() {
    super.initState();
    fetchData2();
  }

  Future<void> generateImage(String prompt) async {
    var url = Uri.parse("https://modelslab.com/api/v6/realtime/text2img");
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      "key": "TpIlxnSWymduJC7RETRnYvQnVx4MNEP6Heqrox8fxsYYxTauCoSbtFZMWvq9",  // Add your key here
      "prompt": prompt,
      "negative_prompt": "bad quality",
      "width": "512",
      "height": "512",
      "safety_checker": false,
      "seed": null,
      "samples": 1,
      "base64": false,
      "webhook": null,
      "track_id": null
    });

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      setState(() {
        _imageUrl = jsonResponse['output'][0];

      
      });
    } else {
      setState(() {
        _imageUrl = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed with status: ${response.statusCode}.')),
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
        // "\n\nUse the following guidelines:"
        // "\n\n1. Face Type Descriptions:"
        // "\n   - Diamond: Narrow forehead and jawline with wider cheekbones."
        // "\n   - Heart: Wider forehead and a narrower chin, resembling a heart."
        // "\n   - Oval: Longer than it is wide, with a rounded jawline."
        // "\n   - Rectangle: Longer than it is wide, with a squared jawline and hairline."
        // "\n   - Round: Almost as wide as it is long, with a rounded jawline and hairline."
        // "\n   - Square: Strong, angular jawline and a broad forehead."
        // "\n\n2. Fashion Style Categories:"
        // "\n   - Formal: Provide suggestions for formal wear."
        // "\n   - Traditional: Provide suggestions for traditional wear."
        // "\n   - Casual: Provide suggestions for casual wear."
        // "\n\n3. Gender-Specific Recommendations:"
        // "\n   - For males: Provide fashion recommendations based on the selected face type and dressing style."
        // "\n   - For females: Provide fashion recommendations based on the selected face type and dressing style."
        // "\n\n4. Accessory Suggestions:"
        // "\n   - Recommend accessories that complement the suggested outfits."
        // "\n\n5. Color Coordination:"
        // "\n   - Suggest color combinations that enhance the user's overall look based on their selected face type and style preferences."
        // "\n\n6. Customization Options:"
        // "\n   - Allow users to customize their preferences by specifying colors, patterns, and fabric types they prefer or want to avoid."
        // "\n\n7. Seasonal and Event-Based Recommendations:"
        // "\n   - Offer recommendations based on the current season and upcoming events."
        // "\n\nPlease provide the recommendations in a structured format, with separate sections for each face type and dressing style, along with images if available."
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

  // Future<void> generateImage(String prompt) async {
  //   var url = Uri.parse("https://modelslab.com/api/v6/realtime/text2img");
  //   var headers = {'Content-Type': 'application/json'};
  //   var body = json.encode({
  //     "key": "8ixtgVQfiYxIfenUSzDGMXhrH0p3RWs4CdJAjy79xFMmkWRbe9xZe1j9axJt",  // Add your key here
  //     "prompt": prompt,
  //     "negative_prompt": "bad quality",
  //     "width": "512",
  //     "height": "512",
  //     "safety_checker": false,
  //     "seed": null,
  //     "samples": 1,
  //     "base64": false,
  //     "webhook": null,
  //     "track_id": null
  //   });

  //   var response = await http.post(url, headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     setState(() {
  //       _imageUrl = jsonResponse['output'][0];
  //     });
  //   } else {
  //     setState(() {
  //       _imageUrl = null;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Request failed with status: ${response.statusCode}.')),
  //       );
  //     });
  //   }
  // }

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
                          ? Image.network(
                              _imageUrl!,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Image failed to load.${error}'),
                                      SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () async{
                                          print("Referesh => ${_imageUrl}");
                                          setState(() {
                                            // _imageUrl = _imageUrl; // Clear the current image URL
                                          });
                                           setState(() {
                            // isLoading = fa;
                            
                            _imageUrl = null;
                          });
                            // await generateImage(fullResponse);
                                          // Reload the page
                                        },
                                        child: Text('Reload'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(child: Text('Image Generating')),
                    ),

                    // Expanded(
                    //   child: _imageUrl != null
                    //       ? Image.network(_imageUrl!)
                    //       : Center(child: Text('No image generated yet.')),
                    // ),
                    SizedBox(
                      width: 50,
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          setState(() {
                            // isLoading = fa;
                            
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
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Opacity(
                        opacity: (1.0 - (((_controller.value + (i / 3)) % 1.0) * 2.0 - 1.0).abs()),
                        child: const Dot(),
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

class Dot extends StatelessWidget {
  const Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
