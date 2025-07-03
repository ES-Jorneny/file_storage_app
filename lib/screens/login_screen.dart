import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

 backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
          SizedBox(height: 120,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Center(
                    child: Text("Login",style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Colors.black87
                    ),),
                  ),
                    Center(child: Text("Get started with your account",style: TextStyle(color: Colors.black87),)),
                    SizedBox(height: 30,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: TextFormField(
                          validator: (value)=>value!.isEmpty?"Email cannot be empty.":null,
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black87,
                                  width: 1
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black87,
                                  width: 1
                                )
                            ),
                            labelText: "Email",
                              labelStyle: TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: TextFormField(
                          validator: (value)=>value!.length<8?"Password should have atleast 8 characters.":null,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: 1
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: 1
                                  )
                              ),
                              labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey)

                          ),
                        ),

                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: ElevatedButton(
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                AuthService.loginWithEmail(_emailController.text, _passwordController.text).then((value){
                                  if(value=="Successfully Login"){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Login")));
                                    Navigator.restorablePushNamedAndRemoveUntil(
                                      context,
                                      '/tab',
                                          (Route<dynamic> route) => false, // remove all previous routes
                                    );
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value),backgroundColor: Colors.red.shade400,));
                                  }
                                }
                                );
                              }
                            },
                            child: Text("Login",style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // 👈 your desired radius
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Center(
                      child: RichText(text: TextSpan(
                        children: [
                          TextSpan(text:"Don't have an account? ",style: TextStyle(color: Colors.black87) ),
                          TextSpan(text: "Sign Up",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w700,fontSize: 14),recognizer:  TapGestureRecognizer()..onTap=(){
                            Navigator.pushNamed(context, "/signup");
                          })
                        ]
                      )),
                    )


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
