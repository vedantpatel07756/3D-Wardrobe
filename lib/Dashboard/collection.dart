import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/skintone.dart';
import 'package:wardrope_app/Dashboard/suggestionWithAPI/Fashion5.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final List<String> imgList = [
    'assets/image/Bgrp1.png', // Replace with actual image URLs
    'assets/image/Ggrp1.png',
    'assets/image/Girl2.png',
    'assets/image/Boy2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Center(child: Image.asset("assets/app_icon/app_icon_without_bg.png",width: 300,)),
        backgroundColor: Config.backgroundColor,
      ),
      backgroundColor: Config.backgroundColor,
      body: Column(
        children: [

          
          SizedBox(height: 50),
  
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: imgList.map((item) => Container(
              child: Center(
                child: Image.asset(item, fit: BoxFit.cover, width: 1000)
              ),
            )).toList(),
          ),
          SizedBox(height: 40),

            SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Revamp your wardrobe with pieces that reflect your personality and taste.',
              style: TextStyle(
                color: Config.textColor,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

           SizedBox(height: 20),
          Icon(
            Icons.arrow_downward,
            size: 50,
            color: Config.secondaryColor,
          ),

            SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Navigate to the next page or perform an action
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SkintonePage()));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Config.accentColor),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
         
        
       

        ],
      ),
    );
  }
}
