import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';
import 'package:wardrope_app/Dashboard/dressingStyle.dart';

class Facetype extends StatefulWidget {
   final String selectedSkintone;
    final List<ColorOption> selectedColors;
  const Facetype({super.key,
                required this.selectedSkintone,
                required this.selectedColors,

  });

  @override
  State<Facetype> createState() => _FacetypeState();
}

// class ColorOption {
//   final Color color;
//   final String name;

//   ColorOption(this.color, this.name);
// }



class _FacetypeState extends State<Facetype> {
  String? gender;
  String? selectedFaceType;

  @override
  void initState() {
    super.initState();
    _loadGender();
  }

  Future<void> _loadGender() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getString('gender') ?? 'Male';
    });
  }

  void _selectFaceType(String faceType) {
    setState(() {
      selectedFaceType = faceType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Face Type"),
        backgroundColor: Config.backgroundColor,
      ),
      body: gender == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    gender == 'Male' ? 'Male Face Types' : 'Female Face Types',
                    style: TextStyle(
                      color: Config.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _buildFaceTypeWidgets(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: selectedFaceType == null
                        ? null
                        : () {
                            // Navigate to the next screen or perform other actions
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DressingStyle(
                                                                        selectedFaceType:selectedFaceType??"Oval",
                                                                        selectedColors:widget.selectedColors,
                                                                        selectedSkintone:widget.selectedSkintone
                      ))).then((value){
                          if(value){
                        Navigator.of(context).pop(true);
                      }
                      }
                      
                      );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.accentColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18,color: Config.backgroundColor)),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildFaceTypeWidgets() {
    final faceTypes = [
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Diamond.jpg', 'label': 'Diamond', 'description': 'This face shape has a narrow forehead and jawline with wider cheekbones.'},
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Heart.jpg', 'label': 'Heart', 'description': 'This face shape has a wider forehead and a narrower chin, resembling a heart.'},
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Oval.jpg', 'label': 'Oval', 'description': 'This face shape is longer than it is wide, with a rounded jawline.'},
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Rectangle.jpg', 'label': 'Rectangle', 'description': 'This face shape is longer than it is wide, with a squared jawline and hairline.'},
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Round.jpg', 'label': 'Round', 'description': 'This face shape is almost as wide as it is long, with a rounded jawline and hairline.'},
      {'image': 'assets/Face/${gender == "Male" ? "boy" : "girl"}/Square.jpg', 'label': 'Square', 'description': 'This face shape has a strong, angular jawline and a broad forehead.'},
      // {'image':"assets/Face//girl/Sqaure.jpg",'label': 'Square', 'description': 'This face shape has a strong, angular jawline and a broad forehead.'}
    ];

    return faceTypes.map((faceType) {
      return GestureDetector(
        onTap: () => _selectFaceType(faceType['label']!),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: (selectedFaceType == faceType['label']?Config.secondaryColor.withOpacity(0.5):Config.backgroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(faceType['image']!, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faceType['label']!,
                        style: TextStyle(
                          color: (selectedFaceType == faceType['label']?Config.backgroundColor:Config.textColor),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        faceType['description']!,
                        style: TextStyle(
                          color: (selectedFaceType == faceType['label']?Config.backgroundColor:Config.textColor),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedFaceType == faceType['label'])
                  Icon(Icons.check_circle, color: Config.accentColor),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}