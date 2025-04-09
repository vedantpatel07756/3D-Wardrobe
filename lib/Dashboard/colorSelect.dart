import 'package:flutter/material.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/facetype.dart';

class ColorPage extends StatefulWidget {
  final String selectedSkintone;
  const ColorPage({super.key, required this.selectedSkintone});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  final List<ColorOption> _colorOptions = [];
  final List<ColorOption> _selectedColors = [];

  @override
  void initState() {
    super.initState();
    _initializeColors();
  }

  void _initializeColors() {
    if (widget.selectedSkintone == "Warm") {
      _colorOptions.addAll([
        ColorOption(Colors.red, "Tomato Red"),
        ColorOption(Colors.orange, "Peach"),
        ColorOption(Colors.yellow, "Mustard"),
        ColorOption(Colors.green, "Olive"),
        ColorOption(Colors.brown, "Caramel"),
        ColorOption(Colors.brown[300]!, "Chocolate"),
        ColorOption(Colors.brown[200]!, "Taupe"),
        ColorOption(Colors.brown[100]!, "Warm Beige"),
      ]);
    } else if (widget.selectedSkintone == "Cool") {
      _colorOptions.addAll([
        ColorOption(Colors.blue[800]!, "Sapphire"),
        ColorOption(Colors.blue, "Cobalt"),
        ColorOption(Colors.blue[900]!, "Navy"),
        ColorOption(Colors.green[400]!, "Emerald"),
        ColorOption(Colors.green[200]!, "Mint"),
        ColorOption(Colors.purple, "Lavender"),
        ColorOption(Colors.purple[800]!, "Plum"),
        ColorOption(Colors.pink, "Rose"),
        ColorOption(Colors.pink[800]!, "Fuchsia"),
        ColorOption(Colors.red, "Cherry"),
        ColorOption(Colors.red[900]!, "Burgundy"),
        ColorOption(Colors.grey, "Cool Gray"),
        ColorOption(Colors.white, "White"),
        ColorOption(Colors.blue[100]!, "Icy Blue"),
      ]);
    } else if (widget.selectedSkintone == "Neutral") {
      _colorOptions.addAll([
        ColorOption(Colors.blue[600]!, "Teal"),
        ColorOption(Colors.blue[300]!, "Turquoise"),
        ColorOption(Colors.green[600]!, "Jade"),
        ColorOption(Colors.green[200]!, "Seafoam"),
        ColorOption(Colors.pink[200]!, "Blush"),
        ColorOption(Colors.pink[300]!, "Dusty Rose"),
        ColorOption(Colors.purple[300]!, "Mauve"),
        ColorOption(Colors.purple, "Violet"),
        ColorOption(Colors.red, "True Red"),
        ColorOption(Colors.red[300]!, "Berry"),
        ColorOption(Colors.white, "Ivory"),
        ColorOption(Colors.grey[800]!, "Charcoal"),
        ColorOption(Colors.white70, "Soft White"),
      ]);
    }
  }

  void _toggleSelection(ColorOption option) {
    setState(() {
      if (_selectedColors.contains(option)) {
        _selectedColors.remove(option);
      } else if (_selectedColors.length < 3) {
        _selectedColors.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Colors"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _colorOptions.length,
                itemBuilder: (context, index) {
                  final option = _colorOptions[index];
                  return GestureDetector(
                    onTap: () =>{
                      if(_selectedColors.length==3){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have to  Select Any Three Color",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),backgroundColor: Config.accentColor,)),

                      },
                             _toggleSelection(option),
                      
                     
                    } ,
                    child: Container(
                      decoration: BoxDecoration(
                        color: option.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedColors.contains(option)
                              ? Colors.amberAccent
                              : Colors.black,
                          width: 5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedColors.length == 3
                  ? () {
                      // Navigate to next screen with selected colors
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Facetype(
                                                          selectedSkintone:widget.selectedSkintone,
                                                          selectedColors:_selectedColors,
                      ))).then((value){
                          if(value){
                        Navigator.of(context).pop(true);
                      }
                      }
                      
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Config.accentColor,
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
    );
  }
}

class ColorOption {
  final Color color;
  final String name;

  ColorOption(this.color, this.name);
}
