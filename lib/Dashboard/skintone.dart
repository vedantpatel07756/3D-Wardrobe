import 'package:flutter/material.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/colorSelect.dart';

class SkintonePage extends StatefulWidget {
  const SkintonePage({super.key});

  @override
  State<SkintonePage> createState() => _SkintonePageState();
}

class _SkintonePageState extends State<SkintonePage> {
  String? selectedSkintone;

  void selectSkintone(String skintone) {
    setState(() {
      selectedSkintone = skintone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Skin Tone"),
        backgroundColor: Config.backgroundColor,
      ),
      body: Center(
        child: Container(
          width: 300,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Config.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Config.textColor.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              skintoneOption(
                "assets/Hand/hand2.png",
                "People with cool undertone have blue or purple looking veins",
                "Cool",
              ),
              skintoneOption(
                "assets/Hand/hand1.png",
                "People with neutral undertone have purple or light green looking veins",
                "Neutral",
              ),
              skintoneOption(
                "assets/Hand/hand3.png",
                "People with warm undertone have green looking veins",
                "Warm",
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedSkintone == null
                    ? null
                    : () {
                        // Navigate to next screen
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColorPage(selectedSkintone:selectedSkintone??"Neutral"))).then((value){
                          if(value){
                        Navigator.of(context).pop(true);
                      }
                      }
                      
                      );
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Config.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget skintoneOption(String imagePath, String description, String skintone) {
    bool isSelected = selectedSkintone == skintone;

    return GestureDetector(
      onTap: () => selectSkintone(skintone),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Config.accentColor.withOpacity(0.2) : Config.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Config.accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Config.textColor,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
