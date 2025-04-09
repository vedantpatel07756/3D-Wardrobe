import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageSearchPage extends StatefulWidget {
  @override
  _ImageSearchPageState createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isLoading = false;

  // Replace with your API Key and Custom Search Engine ID
  final String _apiKey = 'AIzaSyCNbSltZHn39bagk5LvgjnZ7IOFXVcUnT0';
  final String _cx = 'b15fdaf8573e9455a';

  Future<void> _fetchImages(String query) async {
    setState(() {
      _isLoading = true;
      _imageUrls = [];
    });

    final String url = 'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&key=$_apiKey&searchType=image&num=10';

    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobe Suggestions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter a suggestion',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _fetchImages(_searchController.text);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _imageUrls.isEmpty
                    ? Text('No images found.')
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: _imageUrls.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              _imageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image);
                              },
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
