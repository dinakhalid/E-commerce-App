
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';


import 'AccountDetails.dart';
import 'FireBaseHelper.dart';
import 'Login.dart';
import 'Product.dart';
import 'ProductsHome.dart';
import 'cart.dart';
import 'favourites.dart';

class home_layout extends StatefulWidget {

  const home_layout({Key? key, required this.prods, required this.userEmail, required this.userName}) : super(key: key);
  final String? userEmail;
  final String? userName;
  final List<Product> prods;
  @override
  State<home_layout> createState() => _home_layoutState();
}

class _home_layoutState extends State<home_layout> {

  late String? userEmail = widget.userEmail;
  late String? userName = widget.userName;
  late List<Product> products=widget.prods;
  int ci=0;



  void _onItemTapped(int index) {
    setState(() {
      ci=index;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:Container(
          margin: const EdgeInsets.only(left:15),
          decoration: const BoxDecoration(
          ),
          child: IconButton(onPressed: (){},
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ),
        centerTitle: true,
        title: const Row(
          children: [
            SizedBox(width: 80,),
            Text(
              'Shop',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Now',
              style: TextStyle(
                color: Color.fromRGBO(22, 153, 81, 1),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () async{
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LogIn(prods: products)));
            await FireBaseHelper().signOut();
          },
              icon: const Icon(
                Icons.logout,
              )
          )
        ],
      ),
      body: products.isEmpty?
      Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(22, 153, 81, 1),
            backgroundColor: Colors.white,
          ),
        ),
      ):
      ci==0?ProductsHome(prods: widget.prods,userEmail: userEmail):
      ci==1?Cart(prods:widget.prods,userEmail: userEmail):
      ci==2?Favourites(prods: widget.prods,userEmail: userEmail):
      AccountDetails(userEmail: userEmail,userName: userName),
        floatingActionButton: DotNavigationBar(
        marginR: const EdgeInsets.only(left:30),
        backgroundColor: Colors.black,
        currentIndex:ci,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          DotNavigationBarItem(
            icon:const Icon(Icons.home),
            selectedColor: Colors.white,

          ),
          DotNavigationBarItem(
            icon:const Icon(Icons.shopping_cart_outlined),
            selectedColor: Colors.white,

          ),
          DotNavigationBarItem(
            icon:const Icon(Icons.favorite_border),
            selectedColor: Colors.white,

          ),
          DotNavigationBarItem(
            icon:const Icon(Icons.person),
            selectedColor: Colors.white,

          )
        ],
      ),


    );
  }
}

