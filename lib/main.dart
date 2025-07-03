
import 'package:file_storage_app/screens/home_screen.dart';
import 'package:file_storage_app/screens/login_screen.dart';
import 'package:file_storage_app/screens/signup_screen.dart';
import 'package:file_storage_app/screens/tab_bar_screen.dart';
import 'package:file_storage_app/screens/upload_area.dart';
import 'package:file_storage_app/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Drive',
      initialRoute: "/check",
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,            // blinking cursor color
          selectionColor: Colors.grey.shade300, // text selection background color
          selectionHandleColor: Colors.black,   // 👈 ye wala drop shape handle ka color hai
        ),
      ),
      routes: {
        "/check":(context)=>CheckUser(),
        "/upload":(context)=>UploadArea(),
        "/login":(context)=>LoginScreen(),
        "/signup":(context)=>SignupScreen(),
        "/tab":(context)=>TabBarScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
   AuthService.isLoggedIn().then(
       (value){
         if(value){
           Navigator.pushReplacementNamed(context, "/tab");

         }else{
           Navigator.pushReplacementNamed(context, "/login");
         }
   }
   );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.black87,),
      ),
    );
  }
}



