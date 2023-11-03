import 'package:flutter_application_1/patient/AddPatient.dart';
import 'package:flutter_application_1/home/auth.dart';
import 'package:flutter_application_1/profile/edit_profile.dart';
import 'package:flutter_application_1/signin/forgot_password.dart';
import 'package:flutter_application_1/home/homePage.dart';
import 'package:flutter_application_1/patient/patientPage.dart';
import 'package:flutter_application_1/profile/profilePage.dart';
import 'package:flutter_application_1/signin/signin_form.dart';
import 'package:flutter_application_1/signin/signup_form.dart';
import 'package:flutter_application_1/home/splash_Page.dart';

var appRoutes = {
  '/': (context) => const HomePage(),
  'Auth': (context) => const Auth(),
  'signupScreen': (context) => const SignUpForm(),
  'signinScreen': (context) => const SignInForm(),
  'AddpatientScreen': (context) => const AddPatient(),
  'homepage': (context) => const homePage(),
  'profilepage': (context) => const profile(),
  'patientpage': (context) => const PatientPage(),
  'editprofilepage': (context) => const editprofile(),
  'forgetpasswordScreen': (context) => const ForgotPasswordForm(),
};
