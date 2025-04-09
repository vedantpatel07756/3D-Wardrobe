import 'package:flutter/material.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Starter/second.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
                    child: Image.asset("assets/image/boy1.png",height: 450,)),
                   Positioned(
                    bottom: 0,
                     child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(0),
                      
                      decoration: BoxDecoration(
                          color: Config.backgroundColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                      ),
                      child: Container(
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          
                            Padding(
                              padding: const EdgeInsets.only(top:38.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 
                               Text("Welcome to",style: TextStyle(fontFamily: 'AntonSC',fontSize: 60,color: Config.textColor),),
                              Text("3D Wardrope",style: TextStyle(fontFamily: 'AntonSC',fontSize: 60,color: Config.textColor),),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 20,),

                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Secondpage()));
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