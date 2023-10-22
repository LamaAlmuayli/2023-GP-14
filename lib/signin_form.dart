import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'background.dart';

class SignInForm extends StatefulWidget { 
  const SignInForm({super.key}); 

  State<SignInForm> createState() => _SignInState(); 
}

class _SignInState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async { 
    
    await FirebaseAuth.instance.signInWithEmailAndPassword 
    (email: _emailController.text.trim(), password: _passwordController.text.trim(),);

      Navigator.of(context).pushNamed('homepage');

    
  }

  

  void openSignupScreen() {

  Navigator.of(context).pushReplacementNamed('signupScreen');


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
     return Form(
    
     key: _formKey,
      child: Scaffold (
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
          Align(
            alignment: Alignment.bottomCenter, // Align the form to the bottom
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              'Sign in to join',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                 fontFamily: 'Merriweather'
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                      TextFormField(
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'xxxx@xxxxx.xx',
                          border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFF186257), // Blue border in hex
                                ),
                              ),
                          prefixIcon: Icon(Icons.email), // Icon for email
                        ),
                       // validator: validateEmail,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!EmailValidator.validate(value) || RegExp(r'^[A-Za-z][A-Za-z0-9]*$').hasMatch(value)
) {
                          return 'Enter a valid email';
                        } else {
                          // You should add logic to check if the email is already in the database here.
                          // If it is repeated, return an error message.
                          // For now, return null as a placeholder.
                          return null;
                        }
                      },    ),
                          SizedBox(height: 10),
                          TextFormField(
                             autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFF186257), // Blue border in hex
                                ),
                              ),
                              prefixIcon: Icon(Icons.lock), // Lock icon
                            ),
                             validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                          ),
                          SizedBox(height: 20),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 25), 
                          child: GestureDetector (onTap: signIn,
                          
                          child: Container (  
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration( 
                          color: Color(0xFF186257),
                                borderRadius: BorderRadius.circular(15), // Rounded borders
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                   //fontFamily: 'Merriweather', // White text color
                                ),
                         // ElevatedButton(
                           // onPressed: () {
                              // Implement sign-in logic here
                           // },
                            //style: ButtonStyle(
                              //backgroundColor: MaterialStateProperty.all(
                               // Color(0xFF186257), // Button color in hex
                             // ),
                           // 
                           
                          )
                          )) 
                          )
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account yet? ")
                              ,
                            
                               GestureDetector(
                                onTap: openSignupScreen,
                                   child : Text(
                                    'Sign up now',
                                    style: TextStyle(
                                      color: Color(0xFF186257), 
                                       fontFamily: 'Merriweather'// Green color in hex
                                    ),
                                  ),
                                ),
                        
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
  
}