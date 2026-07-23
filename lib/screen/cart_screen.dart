import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/cart_provider.dart';


class CartScreen extends StatelessWidget {

  final VoidCallback onCartUpdated;


  const CartScreen({
    super.key,
    required this.onCartUpdated,
  });



  @override
  Widget build(BuildContext context) {


    final cart = context.watch<CartProvider>();


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,



      appBar: AppBar(


        title: const Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),


        centerTitle: true,


        backgroundColor: Colors.green,


      ),




      body: cart.cartItems.isEmpty


          ? Center(


        child: Column(


          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [


            Icon(


              Icons.shopping_cart_outlined,


              size:100,


              color: Theme.of(context)
                  .iconTheme
                  .color
                  ?.withOpacity(0.4),


            ),



            const SizedBox(height:20),




            Text(


              "Your cart is empty",



              style: TextStyle(


                fontSize:22,


                fontWeight:
                FontWeight.bold,


                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color,


              ),


            ),



          ],


        ),


      )




          : ListView.builder(


        padding:
        const EdgeInsets.all(15),



        itemCount:
        cart.cartItems.length,



        itemBuilder:
            (context,index){



          final item =
          cart.cartItems[index];



          return Card(



            elevation:4,



            color:
            Theme.of(context).cardColor,



            margin:
            const EdgeInsets.only(
              bottom:15,
            ),



            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(20),

            ),



            child: Padding(



              padding:
              const EdgeInsets.all(12),



              child: Row(



                children: [



                  ClipRRect(



                    borderRadius:
                    BorderRadius.circular(15),



                    child:
                    Image.network(



                      item['thumbnail'],



                      width:80,



                      height:80,



                      fit:
                      BoxFit.cover,



                      errorBuilder:
                          (context,error,stackTrace){

                        return const Icon(
                          Icons.image,
                          size:60,
                        );

                      },

                    ),

                  ),




                  const SizedBox(width:15),





                  Expanded(



                    child: Column(



                      crossAxisAlignment:
                      CrossAxisAlignment.start,



                      children: [



                        Text(



                          item['title'],



                          maxLines:2,



                          overflow:
                          TextOverflow.ellipsis,



                          style: TextStyle(



                            fontSize:17,



                            fontWeight:
                            FontWeight.bold,



                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color,



                          ),



                        ),




                        const SizedBox(height:8),





                        Text(



                          "\$${item['price']} x ${item['quantity']}",



                          style: TextStyle(



                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color,



                          ),



                        ),




                        const SizedBox(height:5),





                        Text(



                          "Total: \$${item['price'] * item['quantity']}",



                          style: const TextStyle(



                            color:
                            Colors.green,



                            fontWeight:
                            FontWeight.bold,



                            fontSize:16,



                          ),



                        ),




                      ],



                    ),



                  ),




                  IconButton(



                    onPressed:(){



                      cart.removeItem(index);



                      onCartUpdated();



                    },



                    icon:
                    const Icon(



                      Icons.delete_outline,



                      color:
                      Colors.red,



                      size:30,



                    ),



                  ),



                ],



              ),



            ),



          );



        },



      ),







      bottomNavigationBar:



      cart.cartItems.isNotEmpty



          ? Container(



        padding:
        const EdgeInsets.all(20),



        decoration:
        BoxDecoration(



          color:
          Theme.of(context).cardColor,



          borderRadius:
          const BorderRadius.vertical(



            top:
            Radius.circular(25),



          ),



          boxShadow: [



            BoxShadow(



              color:
              Colors.black.withOpacity(0.1),



              blurRadius:
              10,



            ),



          ],



        ),



        child: Column(



          mainAxisSize:
          MainAxisSize.min,



          children: [



            Row(



              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,



              children: [



                Text(



                  "Total",



                  style: TextStyle(



                    fontSize:20,



                    fontWeight:
                    FontWeight.bold,



                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color,



                  ),



                ),




                Text(



                  "\$${cart.totalPrice()}",



                  style: const TextStyle(



                    fontSize:22,



                    color:
                    Colors.green,



                    fontWeight:
                    FontWeight.bold,



                  ),



                ),



              ],



            ),




            const SizedBox(height:15),





            SizedBox(



              width:
              double.infinity,



              height:
              50,



              child:
              ElevatedButton(



                onPressed:(){},



                style:
                ElevatedButton.styleFrom(



                  backgroundColor:
                  Colors.green,



                  shape:
                  RoundedRectangleBorder(



                    borderRadius:
                    BorderRadius.circular(15),



                  ),



                ),



                child:
                const Text(



                  "Checkout",



                  style:
                  TextStyle(



                    color:
                    Colors.white,



                    fontSize:18,



                    fontWeight:
                    FontWeight.bold,



                  ),



                ),



              ),



            ),



          ],



        ),



      )



          : null,



    );

  }

}