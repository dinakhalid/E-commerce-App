import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FireBaseHelper.dart';
import 'Product.dart';
import 'SignUp.dart';
import 'components/CustomTextFormField.dart';
import 'components/customButton.dart';
import 'home_layout.dart';


class LogIn extends StatefulWidget {

  LogIn({required this.prods});
  final List<Product> prods;

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in ",
                            style: TextStyle(
                                color: Color.fromRGBO(22, 153, 81, 1),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height:30),
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage("assets/images/cartIcon.jpg"),
                          ),
                          const SizedBox(height:30),
                          CustomTextFormField(
                              textController: emailController,
                              hintText: "email",
                              errorText: " Please enter your email ",
                              icons: Icons.mail),
                          CustomTextFormField(
                              textController: passwordController,
                              hintText: "password",
                              errorText: " Please enter your password ",
                              icons: Icons.lock),

                          CustomButton(text: "Log In", onTapAction: signInAction),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 18),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SignUp(prods: widget.prods)));
                                  },
                                  child: const Text('Sign Up!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color.fromRGBO(22, 153, 81, 1),
                                      )
                                    )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void signInAction() async{
    if(formKey.currentState!.validate()){
      showDialog(context: context, builder: (context)
      {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      );
      FireBaseHelper().signIn(emailController.text.toString(), passwordController.text.toString()).then((value) {
        if(value is User)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
              home_layout(prods: widget.prods,userEmail: value.email,userName: value.displayName)
            )
          );
        }
        else if (value is String)
        {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
        }


      });



    }

  }
}