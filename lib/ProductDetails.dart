import 'package:flutter/material.dart';

import 'Product.dart';
import 'sqflite2.dart';



class ProductDetails extends StatefulWidget {

  const ProductDetails({Key? key, required this.prod,required this.userEmail}) : super(key: key);  //const ProductDetails({super.key});
  final Product prod;
  final String? userEmail;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Sqflite2 sqlDb = Sqflite2();
  int imageIdx = 0;
  late Product product = widget.prod;
  late String? userEmail = widget.userEmail;

  Future<bool> checkIfInDatabase(int id)async{
    List<Map>res=await sqlDb.readData('''
      SELECT $id from cart where email = '$userEmail' and id=$id;
    ''');
    return res.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(product.images[imageIdx],fit: BoxFit.contain,height: 200,width: double.infinity,)),
              const SizedBox(height:50),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   InkWell(
                      onTap: (){
                        setState(() {
                          imageIdx=0;
                        });
                      },
                       child: ClipRRect(borderRadius: BorderRadius.circular(3),child: Container(
                           decoration: BoxDecoration(
                             border: imageIdx==0?Border.all(color: const Color.fromRGBO(22, 153, 81, 1),width: 2):Border.all(width:0),
                           ),
                           child: Image.network(product.images[0],width: 70)))
                   ),
                    InkWell(

                        onTap: (){
                          setState(() {
                            imageIdx=1;
                          });
                        },
                        child: ClipRRect(borderRadius: BorderRadius.circular(3),child: Container(
                            decoration: BoxDecoration(
                              border: imageIdx==1?Border.all(color: const Color.fromRGBO(22, 153, 81, 1),width: 2):Border.all(width:0),
                            ),
                            child: Image.network(product.images[1],width: 70)))
                    ),
                    InkWell(

                        onTap: (){
                          setState(() {
                            imageIdx=2;
                          });
                        },
                        child: ClipRRect(borderRadius: BorderRadius.circular(3),child: Container(
                            decoration: BoxDecoration(
                              border: imageIdx==2?Border.all(color: const Color.fromRGBO(22, 153, 81, 1),width: 2):Border.all(width:0),
                            ),
                            child: Image.network(product.images[2],width: 70)))
                    ),
                    InkWell(

                        onTap: (){
                          setState(() {
                            imageIdx=3;
                          });
                        },
                        child: ClipRRect(borderRadius: BorderRadius.circular(3),child: Container(
                            decoration: BoxDecoration(
                              border: imageIdx==3?Border.all(color: const Color.fromRGBO(22, 153, 81, 1),width: 2):Border.all(width:0),
                            ),
                            child: Image.network(product.images[3],width: 70)))
                    ),
                  ],
                ),
              ),
              const SizedBox(height:40),
              Text(product.title,
                style: const TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
              const SizedBox(height:20),
              Text("\$${product.price}",
                style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              const SizedBox(height:10),
              Container(
                width:85,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.1),
                  borderRadius: BorderRadius.circular(15)
                ),

                child: Row(

                  children: [
                    const Icon(Icons.star,color: Colors.orangeAccent),
                    Text("${product.rating} / 5"),
                  ],
                ),
              ),
              const SizedBox(height:20),
              Text("Sold by ${product.brand}",
                style: const TextStyle(fontSize: 16),),
              const SizedBox(height:50),
              Container(height: 1,width: double.infinity,color: Colors.black12,),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MaterialButton(
                    color: const Color.fromRGBO(22, 153, 81, 1),
                    minWidth: 300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.all(15),
                    onPressed: ()async{

                      bool found = await checkIfInDatabase(product.id);
                      if(!found)
                        {
                          //insert if item not in db
                          await sqlDb.insertData('''
                                INSERT INTO cart (id,email) values (${product.id}, "$userEmail")
                                            ''');
                        }

                    } ,
                    child: const Text("Add To Cart",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  ),
                ),
              )
            ],

          ),
        ),

      ),
    );
  }
}
