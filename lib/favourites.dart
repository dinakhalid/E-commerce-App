
import 'package:flutter/material.dart';

import 'Product.dart';
import 'ProductDetails.dart';
import 'sqflite.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key, required this.prods,required this.userEmail});
  final String? userEmail;
  final List<Product> prods;

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  late String? userEmail = widget.userEmail;
  Sqflite sqlDb = Sqflite();
  List favId = [];
  List<Map> favList=[];

  List<Product> products=[];

  void getLikedIds()async{
    List<Map>res=await sqlDb.readData('''
      SELECT id from favourites where email = '$userEmail';
    ''');
    favList = res;
    favId=[];
    for(var i in res)
    {
      favId.add(i.values.first);
    }
    filterProductsByLikes();
    setState(() {});
  }
  void filterProductsByLikes(){
    products=[];
    for(var p in widget.prods)
      {
        if(favId.contains(p.id))
          {
            products.add(p);
          }
      }
  }
  @override
  void initState() {
    super.initState();
    getLikedIds();
  }
  @override
  Widget build(BuildContext context) {

    return  favId.isEmpty?
    const Center(
      child: Text("You have no Items on your favourites list."),
    ) :
    Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: products.length,
                primary: true,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7,crossAxisSpacing: 15,mainAxisSpacing: 15),
                itemBuilder: (context, index) {

                  return Material(

                    child: InkWell(
                      onTap: (){
                        //on Product Tap
                        Navigator.of(context).push( MaterialPageRoute(builder: (context)=>ProductDetails(prod:products[index],userEmail: userEmail)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(

                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width:35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(100),

                                      ),
                                      child: IconButton(
                                        icon: Icon(favId.contains(products[index].id)?Icons.favorite:Icons.favorite_border,color: Colors.red,size: 18,),
                                        onPressed: ()async{
                                          favId.contains(products[index].id)? //delete from DB if product is already liked
                                          await sqlDb.deleteData("Delete from favourites where id=${products[index].id} and email ='$userEmail' ")
                                              : //insert into DB if not liked
                                          await sqlDb.insertData('''
                                            INSERT INTO favourites (id,email) values (${products[index].id}, "$userEmail")
                                          ''');
                                          List<Map>res=await sqlDb.readData('''
                                           Select id from favourites where email = '$userEmail';
                                        ''');
                                          favList = res;
                                          getLikedIds();

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(products[index].title,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                              Text("\$${products[index].price}",style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w900),textAlign: TextAlign.start,)

                            ],

                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}
