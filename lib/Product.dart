class Product{
   final String category;
   final String title;
   final int price;
   final int id;
   final dynamic rating;
   final String brand;
   List<dynamic> images=[];
   Product(this.title,this.price,this.id,this.category,this.images,this.rating,this.brand);

   static List<Product> convertToProduct(List products)
   {
     List<Product> productsList =[];
     for(var product in products)
     {
      if(product["title"]==null || product["rating"]==null ||product["brand"]==null || product["price"] == null || product["id"]==null || product["category"]==null || product["images"]==null || product["images"].length <4)
        {
          continue;
        }
      productsList.add(Product(product["title"],product["price"],product["id"],product["category"],product["images"],product["rating"],product["brand"]));
     }
     return productsList;
   }

}