import 'package:flutter/material.dart'hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart' show CarouselController, CarouselOptions, CarouselSlider;
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/Answer.dart';
import 'package:wardrope_app/Dashboard/Answer2.dart';
import 'package:wardrope_app/Dashboard/Answertry.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';
import 'package:wardrope_app/Home.dart';

class DressingStyle extends StatefulWidget {
     final String selectedSkintone,selectedFaceType;
    final List<ColorOption> selectedColors;
    
  const DressingStyle({super.key,
                      required this.selectedSkintone,
                      required this.selectedFaceType,
                      required this.selectedColors, 
  }
  );

  @override
  State<DressingStyle> createState() => _DressingStyleState();
}

class _DressingStyleState extends State<DressingStyle> {
  String? gender;
  int _current = 0;
  final List<String> dressingStyles = ['Formal', 'Traditional', 'Casual'];
  // final CarouselController _controller = CarouselController();
    final CarouselController _controller = CarouselController();
    // final carousel_slider.CarouselController _controller = carousel_slider.CarouselController();

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

  @override
  Widget build(BuildContext context) {
    final styleImages = {
      'Formal': 'assets/dress/${gender == "Male" ? "male" : "female"}/Formal.png',
      'Traditional': 'assets/dress/${gender == "Male" ? "male" : "female"}/Traditional.png',
      'Casual': 'assets/dress/${gender == "Male" ? "male" : "female"}/Causal.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Dressing Style"),
        backgroundColor: Config.backgroundColor,
      ),
      body: gender == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                CarouselSlider(
                  items: dressingStyles.map((style) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  styleImages[style]!,
                                  // fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                style,
                                style: TextStyle(
                                  color: Config.textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dressingStyles.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Config.primaryColor)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the next screen or perform other actions
                      String dress="Formal";
                      if(_current==1){
                        dress="Traditional";
                      }else if(_current==2){
                             dress="Casual";
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Answertry(
                                                                        selectedFaceType:widget.selectedFaceType,
                                                                        selectedColors:widget.selectedColors,
                                                                        selectedSkintone:widget.selectedSkintone,
                                                                        dress:dress,


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
                    child: const Text('Select', style: TextStyle(fontSize: 18,color: Colors.white),),
                  ),
                ),
              ],
            ),
    );
  }
}


