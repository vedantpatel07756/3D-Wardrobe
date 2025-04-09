

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateImageWidget extends StatefulWidget {
  @override
  _GenerateImageWidgetState createState() => _GenerateImageWidgetState();
}

class _GenerateImageWidgetState extends State<GenerateImageWidget> {
  String? _imageUrl; // Updated to allow null

  Future<void> generateImage() async {
    var url = Uri.parse("https://modelslab.com/api/v6/realtime/text2img");
    var headers = {
      'Content-Type': 'application/json'
    };
    var body = json.encode({
      "key": "8ixtgVQfiYxIfenUSzDGMXhrH0p3RWs4CdJAjy79xFMmkWRbe9xZe1j9axJt",  // Add your key here
      "prompt": "ultra realistic close up portrait ((beautiful pale cyberpunk female with heavy black eyeliner))",
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
      print(jsonResponse);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Generate Image'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: generateImage,
              child: Text('Generate Image'),
            ),
            SizedBox(height: 20),
            _imageUrl != null 
                ? Expanded(
                    child: Image.network(_imageUrl!),
                  )
                : Text('No image generated yet.'),
          ],
        ),
      ),
    );
  }
}

