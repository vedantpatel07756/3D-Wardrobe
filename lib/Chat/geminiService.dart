import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wardrope_app/Config.dart';
import 'package:http_parser/http_parser.dart';


class GeminiService {
  static Future<Map<String, dynamic>> uploadToGemini(File file, String mimeType) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${Config.apikey}'),
    );
    request.headers['Authorization'] = 'Bearer ${Config.apikey}';
    request.files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType('image', mimeType.split('/')[1])));
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception('Failed to upload file');
    }
  }

  static Future<Map<String, dynamic>> getRecommendations(String fileUri) async {
    var url = 'https://ai.google.dev/gemini-api/v1/models/gemini-1.5-flash:generate';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${Config.apikey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'generation_config': {
          'temperature': 1,
          'top_p': 0.95,
          'top_k': 64,
          'max_output_tokens': 8192,
          'response_mime_type': 'text/plain',
        },
        'system_instruction': 'Purpose: To generate outfit and accessory recommendations based on an uploaded image of clothing.\n\nInput:\n\nImage of a piece of clothing (e.g., shirt, dress, pants).\nOutput:\n\nSuggested color combinations for the outfit.\nOptional accessory recommendations.\nInstruction:\n\nImage Upload:\n\nAccept an image file from the user.\nEnsure the image is clear and only contains the piece of clothing to be analyzed.\nImage Analysis:\n\nAnalyze the uploaded image to identify the type of clothing (e.g., shirt, dress, pants).\nExtract the primary color and pattern details of the clothing item.\nOutfit Color Combination Suggestion:\n\nBased on the primary color and pattern of the uploaded clothing item, suggest color combinations that complement the item.\nProvide at least three different color combinations for various outfit options (e.g., shirts, pants, skirts, etc.).\nAccessory Recommendations (Optional):\n\nSuggest accessories that match the suggested outfits. This may include items such as belts, shoes, hats, jewelry, etc.\nProvide at least two accessory options for each suggested outfit.\nUser Feedback:\n\nAllow the user to provide feedback on the recommendations to improve future suggestions.',
        'history': [
          {
            'role': 'user',
            'parts': [
              {'file': fileUri},
              'Which Lower Will suit With this Shirt\n',
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get recommendations');
    }
  }
}
