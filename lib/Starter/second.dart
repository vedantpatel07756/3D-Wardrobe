import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/dashboard.dart';
import 'dart:convert';
import 'dart:io';


class Secondpage extends StatefulWidget {
  const Secondpage({super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}




class _SecondpageState extends State<Secondpage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'Male';
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('gender', _selectedGender);
    await prefs.setString('height',_heightController.text);
    await prefs.setString('weight',_weightController.text);
     await prefs.setBool('isLoggin',true);
  }
  List<String> item=['Male', 'Female'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 800,
             
              
              child: Stack(
                
                children: [
                 
                  Positioned(
                   top: 0, 
                    child: Image.asset("assets/image/Girl1.png",height: 450,)),
                   Positioned(
                    bottom: 0,
                     child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                       child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(0),
                        
                        decoration: BoxDecoration(
                            color: Config.backgroundColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                       
                        ),
                        child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20),


      Container(
        width: 500,
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                   Text('Gender:', style: TextStyle(fontSize: 18)),
        
        
        
                  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              DropdownButton<String>(
                value: _selectedGender,
                hint: Text('Select Gender'),
                items: <String>["Male", "Female"].map((String gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue??"Male";
                  });
                },
              ),
          
             
            ],
          ),
        ),
          ],
        ),
      ),

     
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (in)'),
                keyboardType: TextInputType.number,
          
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              GestureDetector(
                                onTap: (){
          
                                   _saveData();
          
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Dashboard()));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Config.textColor,
                                  radius: 40,
                                  child:Container(
                                    child: Icon(Icons.arrow_forward,color: Config.backgroundColor,size: 40,),
                                  ),
                                ),
                              )
            ],
          ),
        ),
      ),)
                     ),
                   ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}