

import 'package:flutter/material.dart';
import 'package:projects/sqflite.dart';

import 'Product.dart';
import 'ProductDetails.dart';
class ProductsHome extends StatefulWidget {
   const ProductsHome({super.key, required this.prods, required this.userEmail});
   final String? userEmail;
   final List<Product> prods;
   @override
   State<ProductsHome> createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
 Sqflite sqlDb=Sqflite();
  List<Map> favList = [];
  List<int> favId=[];
  late String? userEmail = widget.userEmail;
  late List<Product> products=widget.prods;
  List<Product> temp=[];
  late List<Product> allProds= widget.prods;
  List<String> categories = List.filled(0, "",growable: true);
  String dropDownVal = "all";

  void fetchProducts () async {
    temp = products;
    populateCategories();
    List<Map>res=await sqlDb.readData('''
      SELECT id from favourites where email = '$userEmail';
    ''');
    favList = res;
    updateIdsInList();
    setState(() {});
  }
  void updateIdsInList(){
    favId=[];
    for(var i in favList)
    {
      favId.add(i.values.first);
    }
  }
  void populateCategories(){
    categories.add("all");
    for(var prod in products)
    {
      if(!categories.contains(prod.category))
      {
        categories.add(prod.category);
      }
    }
    setState(() {});
  }

  void searchFilter(String text){

    products = [];
    for(var p in allProds)
      {
        if(p.title.toLowerCase().contains(text.toLowerCase()) && (dropDownVal==p.category || dropDownVal=="all"))
          {
            products.add(p);
          }
      }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Column(
        children: [

          Center(
            child: Container(
                height: 45,

                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.black38
                    ),
                    onChanged: searchFilter,
                    cursorColor: Colors.black,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: '          what are you looking for?',
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      focusColor: Colors.deepOrange,
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            ),
          ),
          const SizedBox(height:10),
          Row(

            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                  width:25
              ),
              DropdownButton(
                value: dropDownVal,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: const Color.fromRGBO(22, 153, 81, 1)
                ),
                iconEnabledColor:const Color.fromRGBO(22, 153, 81, 1),
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                  onChanged: (String? value) {

                  setState(() {
                  dropDownVal = value!;

                  products = temp.where((element) => element.category==dropDownVal || dropDownVal=="all").toList();
                  });
                  },
              ),

            ],
          ),
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
                                          //delete from DB if product is already liked
                                          favId.contains(products[index].id)?
                                          await sqlDb.deleteData("Delete from favourites where id=${products[index].id} and email ='$userEmail' ")
                                              : //insert into DB if not liked
                                          await sqlDb.insertData('''
                                            INSERT INTO favourites (id,email) values (${products[index].id}, "$userEmail")
                                          ''');
                                          List<Map>res=await sqlDb.readData('''
                                           Select id from favourites where email = '$userEmail';
                                        ''');
                                           favList = res;
                                           updateIdsInList();
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
      ),

    );
  }
}
