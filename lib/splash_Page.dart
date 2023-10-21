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
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //  backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: height,
            color: blackBG,
            child: Image.asset(
              "assets/images/background.jpeg",
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'The greatest wealth is health.',
                        style: headlineDot.copyWith(color: Colors.white),
                      ),
                    ]),
                  ),
                  Mainbutton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => SignInForm()));
                    },
                    btnColor: Color.fromARGB(255, 255, 255, 255),
                    text: 'Get Started',
                    txtColor: Color(0xFF186257),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
