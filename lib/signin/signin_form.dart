import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/services/authentic.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInState();
}

class _SignInState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  // Future signIn() async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );

  //     Navigator.of(context).pushNamed('homepage');

  //     // Registration successful
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('The email or password is incorrect ')));
  //       } else {
  //         // Handle other FirebaseAuthException errors or display a generic error message.
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('An error occurred: ${e.message}')));
  //       }
  //     }
  //   }
  // }

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupScreen');
  }

  void openForgotpasswordScreen() {
    Navigator.of(context).pushReplacementNamed('forgetpasswordScreen');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
        key: _formKey,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: const Color(0xFF186257), // Replace with your background color
                child: Image.asset(
                  "assets/images/background.jpeg",
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment:
                    Alignment.bottomCenter, // Align the form to the bottom
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align to the bottom
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(
                                child: Text(
                                  'Sign in to join',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Merriweather'),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'xxxx@xxxxx.xx',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFF186257), // Blue border in hex
                                    ),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.email), // Icon for email
                                ),
                                // validator: validateEmail,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  } else if (!EmailValidator.validate(value) ||
                                      RegExp(r'^[A-Za-z][A-Za-z0-9]*$')
                                          .hasMatch(value)) {
                                    return 'Enter a valid email';
                                  } else {
                                    // You should add logic to check if the email is already in the database here.
                                    // If it is repeated, return an error message.
                                    // For now, return null as a placeholder.
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFF186257), // Blue border in hex
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.lock), // Lock icon
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
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: GestureDetector(
                                      onTap: () {
                                        String email =
                                            _emailController.text.trim();
                                        String password =
                                            _passwordController.text.trim();
                                        AuthService()
                                            .signIn(email, password, context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF186257),
                                            borderRadius: BorderRadius.circular(
                                                15), // Rounded borders
                                          ),
                                          child: const Center(
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
                                          ))))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account yet? "),
                                  GestureDetector(
                                    onTap: openSignupScreen,
                                    child: const Text(
                                      'Sign up now',
                                      style: TextStyle(
                                          color: Color(0xFF186257),
                                          fontFamily:
                                              'Merriweather' // Green color in hex
                                          ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: openForgotpasswordScreen,
                                    child: const Text(
                                      '                         '
                                      'Forgot password?',
                                      style: TextStyle(
                                          color: Color(0xFF186257),
                                          fontFamily:
                                              'Merriweather' // Green color in hex
                                          ),
                                    ),
                                  )
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
