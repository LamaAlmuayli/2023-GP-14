import 'package:flutter/material.dart';
//import 'package:flutter_application_1/publishPage.dart';
import 'homePage.dart';


class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String selectedIcon = 'home'; // Set the default selected icon

  void selectIcon(String iconName, Widget pageName) {
    setState(() {
      selectedIcon = iconName;
    });

    String coloredIconPath = 'images/colored_$iconName.png';
    precacheImage(Image.asset(coloredIconPath).image, context);

    // Navigate to the corresponding page based on the selected icon
    Navigator.push(context, MaterialPageRoute(builder: (context) => pageName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            imagePath: 'images/home.png',
            isSelected: selectedIcon == 'home',
            onTap: () => selectIcon('home', homePage()),
          ),
          // NavBarItem(
          //   imagePath: 'images/community.png',
          //   isSelected: selectedIcon == 'community',
            //onTap: () => selectIcon('community', communityPage()),
          // ),
          //NavBarItem(
           // imagePath: 'images/publish.png',
          //   isSelected: selectedIcon == 'publish',
          //  // onTap: () => selectIcon('publish', publishPage()),
          // ),
          // NavBarItem(
          //   imagePath: 'images/chatbot.png',
          //   isSelected: selectedIcon == 'chatbot',
          //   onTap: () => selectIcon('chatbot', chatbotPage()),
          // ),
          NavBarItem(
            imagePath: 'images/profile.png',
            isSelected: selectedIcon == 'profile',
            onTap: (() => Navigator.of(context).pushNamed('homepage'))
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  NavBarItem({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            '$imagePath',
            width: 25,
            height: 25,
          ),
        ],
      ),
    );
  }
}