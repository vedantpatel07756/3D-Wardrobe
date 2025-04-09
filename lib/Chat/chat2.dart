

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wardrope_app/Config.dart';
// import 'package:wardrope_app/Dashboard/colorSelect.dart';
// import 'package:wardrope_app/Dashboard/dashboard.dart';
// import 'package:wardrope_app/GenerateImage/image.dart';
// import 'package:http/http.dart' as http;
// class Chat2 extends StatefulWidget {
//   const Chat2({super.key});

//   @override
//   _ANSWERPageState createState() => _ANSWERPageState();
// }

// class _ANSWERPageState extends State<Chat2> {
//   String fullResponse = '';
//   bool isLoading = false;
//   bool isDarkMode = true;
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatMessage> _messages = [];
//   File? _imageFile;
//     String keywordsSection='';

//   @override
//   void initState() {
//     super.initState();
//   }


// // cse 
//   List<String> _imageUrls = [];
//   bool _isLoading = false;
//   // Replace with your API Key and Custom Search Engine ID
//   final String _apiKey = 'AIzaSyCNbSltZHn39bagk5LvgjnZ7IOFXVcUnT0';
//   final String _cx = 'b15fdaf8573e9455a';

//   Future<void> _fetchImages(String query) async {
//     setState(() {
//       _isLoading = true;
//       _imageUrls = [];
//     });

//     final String url = 'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&key=$_apiKey&searchType=image&num=10';

//     try {
//       final response = await http.get(Uri.parse(url));
//       print(response.body);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List items = data['items'];
        
//         setState(() {
//           _imageUrls = items.map((item) => item['link'] as String).toList();

//           _isLoading = false;
//         });
//       } else {
//         print("Failed to load images: ${response.statusCode}");
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }



// // cse 








//   List<Content> history = [
//     Content.text('Your Name is Vedant'),
//     Content.model([TextPart('The shirt is a grey plaid, which is a versatile pattern that can be styled in many ways. Here are some lower options that would look great with this shirt:\n\n**Option 1: Classic and Chic**\n\n* **Lower:**  Dark wash denim jeans\n* **Color Combination:** Grey plaid shirt, dark wash denim jeans, white sneakers \n* **Accessories:**  A brown leather belt, a silver watch\n\n**Option 2: Casual and Comfortable**\n\n* **Lower:** Khaki chinos \n* **Color Combination:** Grey plaid shirt, khaki chinos, brown leather loafers\n* **Accessories:** A brown leather belt, a brown leather watch \n\n**Option 3:  Smart Casual**\n\n* **Lower:** Black dress pants\n* **Color Combination:** Grey plaid shirt, black dress pants, black leather Chelsea boots\n* **Accessories:**  A black leather belt, a silver watch \n')])
//   ];

//   Future<void> fetchData2(String message, {Uint8List? imageBytes, String? mimeType}) async {
//     final prefs = await SharedPreferences.getInstance();
//     String gender = prefs.getString('gender') ?? "Male";
//     final apiKey = Config.apikey;
//     if (apiKey == null) {
//       print('No \$API_KEY environment variable');
//       return;
//     }

// final model = GenerativeModel(
//   model: 'gemini-1.5-flash',
//   apiKey: apiKey,
//   systemInstruction: Content.system('Provide a concise fashion recommendation based on question or Photo Provided with 5 key points (short and crips) on current trends. use bullet point to represent. Conclude with 5 relevant fashion-related keywords is Complusory and very important. Keep the last line like"Keywords : ...,...,...,...,... ."'),
// );


//     history.add(Content.text(message));

//     if (imageBytes != null && mimeType != null) {
//       history.add(Content.data(mimeType, imageBytes));
//     }

//     final chat = model.startChat(history: history);
//     setState(() {
//       isLoading = true;
//     });

//     var responses = chat.sendMessageStream(Content.text(message));
//     String fullResponse = "";
//     await for (final response in responses) {
//       setState(() {
//         fullResponse += response.text?.replaceAll('*', '').trim() ?? "";
//       });

//       history.add(Content.model([TextPart(response.text?.replaceAll('*', '').trim() ?? "")]));
//     }
    
//       // Find the keywords section
// keywordsSection = fullResponse.substring(fullResponse.indexOf("Keywords:"));
// print(keywordsSection);
// _fetchImages(keywordsSection);
//     setState(() {
//       isLoading = false;
//       _messages.add(ChatMessage(
//         text: fullResponse,
//         isBotMessage: true,
//       ));
//     });
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty || _imageFile != null) {
//       fullResponse = '';

//       Uint8List? imageBytes;
//       String? mimeType;

//       if (_imageFile != null) {
//         imageBytes = await _imageFile!.readAsBytes();
//         mimeType = 'image/${_imageFile!.path.split('.').last}';
//       }

//       fetchData2(_messageController.text, imageBytes: imageBytes, mimeType: mimeType);
//       setState(() {
//         _messages.add(ChatMessage(
//           text: _messageController.text,
//           imageFile: _imageFile,
//         ));
//         _messageController.clear();
//         _imageFile = null;
//       });
//     }
//   }

//   Future<void> _pickImageFromGallery() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
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
//           title: isDarkMode ? Image.asset("assets/app_icon/check.png") : Image.asset("assets/app_icon/addiconhead.png", width: 250),
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
//         body: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index];
//                     return Column(
//                       crossAxisAlignment: message.isBotMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//                       children: [
//                         if (message.imageFile != null)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Image.file(message.imageFile!, scale: 0.5),
//                           ),
//                         Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: message.isBotMessage ? (isDarkMode ? Colors.grey[800] : Colors.grey[200]) : Config.accentColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             message.text,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: isDarkMode ? (message.isBotMessage ? Colors.white : Colors.black) : (message.isBotMessage ? Colors.black : Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             if (isLoading) TypingAnimation(),
//             Container(
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Config.accentColor,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.image, color: Config.backgroundColor),
//                     onPressed: _pickImageFromGallery,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.camera_alt, color: Config.backgroundColor),
//                     onPressed: _pickImageFromCamera,
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       style: TextStyle(color: Config.backgroundColor),
//                       decoration: InputDecoration(
//                         hintText: "Type the message",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send, color: Config.backgroundColor),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final File? imageFile;
//   final bool isBotMessage;

//   ChatMessage({
//     required this.text,
//     this.imageFile,
//     this.isBotMessage = false,
//   });
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
//                       child: Dot(
//                         color: Colors.grey,
//                         offset: i,
//                         controller: _controller,
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
//   final AnimationController controller;
//   final int offset;
//   final Color color;

//   Dot({
//     required this.controller,
//     required this.offset,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: Tween(begin: 0.3, end: 1.0)
//           .chain(CurveTween(curve: Interval(
//             offset * 0.2,
//             0.6 + offset * 0.2,
//             curve: Curves.easeInOut,
//           )))
//           .animate(controller),
//       child: Container(
//         width: 8,
//         height: 8,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:http/http.dart' as http;

class Chat2 extends StatefulWidget {
  const Chat2({super.key});

  @override
  _ANSWERPageState createState() => _ANSWERPageState();
}

class _ANSWERPageState extends State<Chat2> {
  String fullResponse = '';
  bool isLoading = false;
  bool isDarkMode = true;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  File? _imageFile;
  String keywordsSection = '';

  // CSE variables
  List<String> _imageUrls = [];
  bool _isLoading = false;
  final String _apiKey = 'AIzaSyCNbSltZHn39bagk5LvgjnZ7IOFXVcUnT0';
  final String _cx = 'b15fdaf8573e9455a';

  Future<void> _fetchImages(String query) async {
    setState(() {
      _isLoading = true;
      _imageUrls = [];
    });

    final String url = 'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&key=$_apiKey&searchType=image&num=5'; 

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List items = data['items'];

        setState(() {
          _imageUrls = items.map((item) => item['link'] as String).toList();
          _isLoading = false;
        });
      } else {
        print("Failed to load images: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Content> history = [
    
  ];

  // Future<void> fetchData2(String message, {Uint8List? imageBytes, String? mimeType}) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String gender = prefs.getString('gender') ?? "Male";
  //   final apiKey = Config.apikey;
  //   if (apiKey == null) {
  //     print('No \$API_KEY environment variable');
  //     return;
  //   }

  //   final model = GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: apiKey,
  //     systemInstruction: Content.system('Provide a concise fashion recommendation based on question or Photo Provided with 5 key points (short and crisp) on current trends. Use bullet points to represent. Conclude with 5 relevant fashion-related keywords is compulsory and very important. Keep the last line like "Keywords : ...,...,...,...,... ."'),
  //   );

  //   history.add(Content.text(message));

  //   if (imageBytes != null && mimeType != null) {
  //     history.add(Content.data(mimeType, imageBytes));
  //   }

  //   final chat = model.startChat(history: history);
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var responses = chat.sendMessageStream(Content.text(message));
  //   String fullResponse = "";
  //   await for (final response in responses) {
  //     setState(() {
  //       fullResponse += response.text?.replaceAll('*', '').trim() ?? "";
  //     });

  //     history.add(Content.model([TextPart(response.text?.replaceAll('*', '').trim() ?? "")]));
  //   }

  //   // Find the keywords section
  //   keywordsSection = fullResponse.substring(fullResponse.indexOf("Keywords:"));
  //   print(keywordsSection);
  //   _fetchImages(keywordsSection); // Fetch images based on keywords
  //   setState(() {
  //     isLoading = false;
  //     _messages.add(ChatMessage(
  //       text: fullResponse,
  //       isBotMessage: true,
  //     ));
  //   });
  // }

Future<void> fetchData2(String message, {Uint8List? imageBytes, String? mimeType}) async {
  final prefs = await SharedPreferences.getInstance();
  String gender = prefs.getString('gender') ?? "Male";
  final apiKey = Config.apikey;
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    return;
  }

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    systemInstruction: Content.system('Provide a concise fashion recommendation based on question or Photo Provided with 5 key points (short and crisp) on current trends. Use bullet points to represent. Conclude with 5 relevant fashion-related keywords is compulsory and very important. Keep the last line like "Keywords : ...,...,...,...,... ."'),
  );

  history.add(Content.text(message));

  if (imageBytes != null && mimeType != null) {
    history.add(Content.data(mimeType, imageBytes));
  }

  final chat = model.startChat(history: history);
  setState(() {
    isLoading = true;
  });

  var responses = chat.sendMessageStream(Content.text(message));
  String fullResponse = "";
  await for (final response in responses) {
    setState(() {
      fullResponse += response.text?.replaceAll('*', '').trim() ?? "";
    });

    history.add(Content.model([TextPart(response.text?.replaceAll('*', '').trim() ?? "")]));
  }

  // Find the keywords section
  int keywordsStartIndex = fullResponse.indexOf("Keywords");
  if (keywordsStartIndex != -1) {
    keywordsSection = fullResponse.substring(keywordsStartIndex);
    print(keywordsSection);
    _fetchImages(keywordsSection); // Fetch images based on keywords
  } else {
    print("Keywords section not found in the response.");
  }

  setState(() {
    isLoading = false;
    _messages.add(ChatMessage(
      text: fullResponse,
      isBotMessage: true,
    ));
  });
}


  void _sendMessage() async {
    if (_messageController.text.isNotEmpty || _imageFile != null) {
      fullResponse = '';

      Uint8List? imageBytes;
      String? mimeType;

      if (_imageFile != null) {
        imageBytes = await _imageFile!.readAsBytes();
        mimeType = 'image/${_imageFile!.path.split('.').last}';
      }

      fetchData2(_messageController.text, imageBytes: imageBytes, mimeType: mimeType);
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
          imageFile: _imageFile,
        ));
        _messageController.clear();
        _imageFile = null;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
          title: isDarkMode ? Image.asset("assets/app_icon/check.png") : Image.asset("assets/app_icon/addiconhead.png", width: 250),
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
        body: Column(
          children: [
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _messages.length + _imageUrls.length,
                  itemBuilder: (context, index) {
                    // If index is less than number of messages, return chat message
                    if (index < _messages.length) {
                      final message = _messages[index];
                      return Column(
                        crossAxisAlignment: message.isBotMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          if (message.imageFile != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.file(message.imageFile!, scale: 0.5),
                            ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message.isBotMessage ? (isDarkMode ? Colors.grey[800] : Colors.grey[200]) : Config.accentColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? (message.isBotMessage ? Colors.white : Colors.black) : (message.isBotMessage ? Colors.black : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    } 
                    // If index is equal or greater than number of messages, return image
                    else {
                      int imageIndex = index - _messages.length; // Adjusting index for images
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.network(_imageUrls[imageIndex], fit: BoxFit.cover),
                      );
                    }
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _messageController,
            //           decoration: InputDecoration(
            //             hintText: 'Type a message...',
            //             border: OutlineInputBorder(),
            //           ),
            //         ),
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.send),
            //         onPressed: _sendMessage,
            //       ),
            //     ],
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.camera),
            //       onPressed: _pickImageFromCamera,
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.photo),
            //       onPressed: _pickImageFromGallery,
            //     ),
            //   ],
            // ),
            if (_isLoading) TypingAnimation(),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Config.accentColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Config.backgroundColor),
                    onPressed: _pickImageFromGallery,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Config.backgroundColor),
                    onPressed: _pickImageFromCamera,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Config.backgroundColor),
                      decoration: InputDecoration(
                        hintText: "Type the message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Config.backgroundColor),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
            // if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isBotMessage;
  final File? imageFile;

  ChatMessage({
    required this.text,
    this.isBotMessage = false,
    this.imageFile,
  });
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
                      child: Dot(
                        color: Colors.grey,
                        offset: i,
                        controller: _controller,
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
  final AnimationController controller;
  final int offset;
  final Color color;

  Dot({
    required this.controller,
    required this.offset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0)
          .chain(CurveTween(curve: Interval(
            offset * 0.2,
            0.6 + offset * 0.2,
            curve: Curves.easeInOut,
          )))
          .animate(controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

