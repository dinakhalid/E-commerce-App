import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FireBaseHelper.dart';
import 'Login.dart';
import 'Product.dart';
import 'components/CustomTextFormField.dart';
import 'components/customButton.dart';
import 'home_layout.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.prods});
  final List<Product> prods;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
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
                            "Sign Up",
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
                              textController: userNameController,
                              hintText: "username",
                              errorText: " Please enter your name ",
                              icons: Icons.person),
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

                          CustomButton(text: "Sign Up", onTapAction: signUpAction),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(fontSize: 18),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => LogIn(prods: widget.prods)));
                                  },
                                  child: const Text('Sign in',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color.fromRGBO(22, 153, 81, 1),
                                      )))
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

  void signUpAction() async{
    if(formKey.currentState!.validate()){
      showDialog(context: context, builder: (context)
      {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      );
      await FireBaseHelper().signUp(emailController.text.toString(), passwordController.text.toString(), userNameController.text.toString()).then((value) {
        if(value is User)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
              home_layout(prods: widget.prods,userEmail: value.email,userName:userNameController.text.toString())));
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