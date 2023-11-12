import 'package:flutter/material.dart';

class bottomNavBar extends StatefulWidget {
  const bottomNavBar({super.key});
  @override
  _bottomNavBarState createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.pushNamed(context, 'homepage');
          break;
        case 1:
          Navigator.pushNamed(context, 'communitypage');
          break;
        case 2:
          Navigator.pushNamed(context, 'empty'); //change later
          break;
        case 3:
          Navigator.pushNamed(context, 'empty'); //chaneg later
          break;
        case 4:
          Navigator.pushNamed(context, 'profilepage');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.publish),
            label: 'Publish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xFF186257), // Change the selected icon color
        unselectedItemColor: Colors.grey, // Change the unselected icon color
        onTap: _onItemTapped,
      ),
    );
  }
}
