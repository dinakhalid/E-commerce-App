import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import 'DioHelper.dart';
import 'Login.dart';
import 'Product.dart';
import 'home_layout.dart';
import 'theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=> ThemeProvider(),
    child: Consumer<ThemeProvider>(
      builder: (context,themeProvider,_){

    return MaterialApp(
    theme: themeProvider.getTheme(),
    debugShowCheckedModeBanner: false,
    home: AnimatedSplashScreen(
    splashIconSize: 180,
    splashTransition: SplashTransition.fadeTransition,
    nextScreen: const firstScreen(),
    splash: const CircleAvatar(
    radius: 85,
    backgroundImage: AssetImage("assets/images/cartIcon.jpg"),
    ),

    ),

    );
    }
    ),
    );
  }
}
class firstScreen extends StatefulWidget {
  const firstScreen({super.key});

  @override
  State<firstScreen> createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> {


  List<Product> products=[];
  Future<void>fetchProducts () async {
    List prods = await DioHelper().getData();
    products = Product.convertToProduct(prods);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Widget start()
  {
    if(FirebaseAuth.instance.currentUser!=null)
    {
      return home_layout(prods: products,userEmail: FirebaseAuth.instance.currentUser!.email,userName: FirebaseAuth.instance.currentUser!.displayName);
    }
    else {
      return LogIn(prods: products);
    }
  }



  @override
  Widget build(BuildContext context) {
    return  products.isEmpty?
    Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(
            color: Color.fromRGBO(22, 153, 81, 1),
            backgroundColor: Colors.white,
        ),
      ),
    ) :Scaffold(
      body: start(),
    );
  }
}
