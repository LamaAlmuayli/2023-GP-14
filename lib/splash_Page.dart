import 'package:flutter/material.dart';
import 'package:flutter_application_1/AddPatient.dart';
import 'package:flutter_application_1/signin_form.dart';
// ignore: depend_on_referenced_packages
import '/core/colors.dart';
import '/core/space.dart';
import '/core/text_style.dart';
import '/widget/main_button.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Add a delay and then animate the opacity of the content
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF186257), // Replace with your background color
            child: Image.asset(
              "assets/images/background.jpeg",
              height: height,
              fit: BoxFit.contain, 
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1), // Adjust the duration as needed
            bottom: 0,
            left: 0,
            right: 0,
            height: height / 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black], // Adjust gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(seconds: 1), // Adjust the duration as needed
                    opacity: opacity,
                    child: Text(
                      'The greatest wealth is health',
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'KaushanScript',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: Duration(seconds: 1), // Adjust the duration as needed
                    opacity: opacity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                         minimumSize: Size(200, 60),  // Button background color
                      ), 
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInForm(),
                            
                          ),
                        );
                      },
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Color(0xFF186257),
                          fontSize: 18,
                          fontFamily: 'Merriweather',
                        )
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
