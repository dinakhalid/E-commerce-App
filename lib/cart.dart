
import 'package:flutter/material.dart';


import 'Product.dart';
import 'ProductDetails.dart';
import 'sqflite2.dart';



class Cart extends StatefulWidget {

  Cart({super.key, required this.prods,required this.userEmail});
  final String? userEmail;
  final List<Product> prods;


  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late String? userEmail = widget.userEmail;

  Sqflite2 sqlDb = Sqflite2();
  List cartId = [];
  List<Map>? cartList=[];
  Map<int,int> count={};
  List<Product> products=[];
  int totalPrice=0;

  void getCartIds()async{
    List<Map>res=await sqlDb.readData('''
      SELECT id from cart where email = '${userEmail}';
    ''');
    cartList = res;
    cartId=[];
    for(var i in res)
    {
      cartId.add(i.values.first);
    }
    filterProductsByCart();
    initializeMap();
    calculateCost();
    setState(() {});
  }

  void filterProductsByCart(){
    products=[];
    for(var p in widget.prods)
    {
      if(cartId.contains(p.id))
      {
        products.add(p);
      }
    }
  }

  void initializeMap(){
    for(var id in cartId)
      {
        count[id] = 1;
      }
  }

  void handleIncrement(int id){
      int? num = count[id]!;
      num+=1;
      count[id] = num;
      calculateCost();
      setState(() {});

  }

  void handleDecrement(int id)
  {
    int? num = count[id]!;
    num -=1;
    if(num ==0)
      {
        count[id] = 1;
      }
    else {
      count[id] = num;
    }
    calculateCost();
    setState(() {});
  }

  void calculateCost()
  {
    totalPrice=0;
    for(var prod in products)
      {
        totalPrice+= (prod.price*count[prod.id]!);
      }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCartIds();
  }

  @override
  Widget build(BuildContext context) {
    return  cartId.isEmpty?
    const Center(
      child: Text("You have no Items in your Cart."),
    ) :
    Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(22, 153, 81, 1),

          centerTitle: true,
          title: Text("You'll pay \$$totalPrice",style: const TextStyle(fontSize: 14),),
        ),

        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  itemCount: products.length,
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 1.2,crossAxisSpacing: 15,mainAxisSpacing: 15),
                  itemBuilder: (context, index) {

                    return Dismissible(
                      background: Container(
                        color: Colors.redAccent,
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction)async
                      {
                        await sqlDb.deleteData("Delete from cart where id=${products[index].id} and email ='$userEmail' ");
                        products.removeAt(index);
                        getCartIds();
                      },
                      child: Material(
                        borderRadius:BorderRadius.circular(20) ,
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push( MaterialPageRoute(builder: (context)=>ProductDetails(prod:products[index],userEmail: userEmail)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(

                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:double.infinity,
                                    height:150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image:DecorationImage(
                                          image:NetworkImage(products[index].images[0]),
                                        )
                                    ),

                                  ),
                                  Text(products[index].title,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                  Text("\$${products[index].price}",style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w900),textAlign: TextAlign.start,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(onPressed: (){
                                        handleDecrement(products[index].id);
                                        },
                                          icon: const Icon(Icons.minimize_outlined)),
                                      Text("${count[products[index].id]}"),
                                      IconButton(onPressed: (){
                                        handleIncrement(products[index].id);
                                      },
                                          icon: const Icon(Icons.add)),
                                    ],
                                  )
                                ],

                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
            const SizedBox(height:70),
          ],
        )
    );
  }
}
