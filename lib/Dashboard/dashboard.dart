import 'package:flutter/material.dart';
import 'package:wardrope_app/CSE/searchEngine.dart';
import 'package:wardrope_app/Chat/chat.dart';
import 'package:wardrope_app/Chat/chat2.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Dashboard/collection.dart';
import 'package:wardrope_app/Dashboard/suggestionWithAPI/Fashion5.dart';
import 'package:wardrope_app/Profile/Profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Image.asset("assets/app_icon/app_icon_without_bg.png",width: 300,)),
      //   backgroundColor: Config.backgroundColor,
      // ),
      backgroundColor: Config.backgroundColor,
      body:(_currentIndex==0)?CollectionPage():((_currentIndex==1)?Chat2():((_currentIndex==2)?ImageSearchPage():ProfilePage()))
         

      
,
bottomNavigationBar:  BottomNavBar() ,

    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      
    });
  }

  BottomNavigationBar BottomNavBar() {


    return BottomNavigationBar(
       type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home,),
        ),
        BottomNavigationBarItem(
          label: "Chat",
          icon: Icon(Icons.chat),
        ),
        BottomNavigationBarItem(
          label: "Trending",
          icon: Icon(Icons.trending_up),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(Icons.person),
        ),
      ],
    );
  }

 

}