import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/assistantMethods/total_amount.dart';
import 'package:users_app/mainScreens/address_screen.dart';
import 'package:users_app/models/Items.dart';
import 'package:users_app/splash_screen/splashScreen.dart';
import 'package:users_app/widgets/app_bar.dart';
import 'package:users_app/widgets/cart_item_design.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
final String? sellerUID;

CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<int>? seperateItemQuantityList;
  num totalAmount=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount=0;
    Provider.of<TotalAmount>(context,listen: false).displayTotalAmaunt(0);

    seperateItemQuantityList=seperateItemQuantities();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.redAccent,
              ],
              begin: FractionalOffset(0.0,0.0),
              end:FractionalOffset(1.0, 0.0),
              stops:[0.0,1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon:const  Icon(Icons.clear_all),
          onPressed:(){
            clearCartNow(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
            Fluttertoast.showToast(msg: "Korpa je ispražnjena");
          },
        ),
        title:const Text(
          "Gurman",
          style: TextStyle(
            fontSize: 45,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon:Icon(Icons.shopping_cart,),
                onPressed: (){
//send user to cart screen
                print("Kliknuto");
                },
              ),
              Positioned(child: Stack(
                children:[
                  const Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.green,
                  ),
                  Positioned(
                      top: 3,
                      right:4,
                      child:Center(
                          child:Consumer<CartItemCounter>(
                              builder:(context,counter,c){
                                return Text(
                                  counter.count.toString(),
                                  style: const TextStyle(color: Colors.white,fontSize:12 ),
                                );
                              }
                          )
                      )
                  ),
                ],
              ))
            ],
          ),
        ],

      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         const SizedBox(
            width: 10,
          ),
          Align(
          alignment: Alignment.bottomLeft,
        child: FloatingActionButton.extended(
          heroTag:"btn1",
          label:const Text(
            "Isprazni Korpu",
            style: TextStyle(fontSize: 16),
          ),
            backgroundColor:Colors.cyan,
            icon:const Icon(Icons.clear_all),
          onPressed: (){
clearCartNow(context);
Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
          },

          ),
        ),
      Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton.extended(
          heroTag: "btn2",
          label:const Text(
              "Plaćanje",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor:Colors.cyan,
          icon:const Icon(Icons.navigate_next),
          onPressed: (){
Navigator.push(
    context
    , MaterialPageRoute(
    builder: (c)=>AddressScreen(
      totalAmount:totalAmount.toDouble(),
      sellerUID: widget.sellerUID,
    )));
          },
      ),
      ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //overall total amount
          SliverPersistentHeader(pinned:true,
              delegate: TextWidgetHeader(title:"Moja korpa")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount,CartItemCounter>(builder: (context,amountProvider,cartProvider,c){
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count==0 ? Container()
                      :Text(
                    "Ukupna cijena: "+amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),


          // display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore
                .instance.collection("items")
                .where("itemID",whereIn: seperateItemIDs())
                .orderBy("publishedDate",descending: true)
                .snapshots(),
            builder: (context,snapshot){
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  :  snapshot.data!.docs.length==0
                  ? //startBuildingCart()
               Container()
                  : SliverList(
                delegate:SliverChildBuilderDelegate((context,index){
                  Items model=Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );

                  if(index==0){
                    totalAmount=0;
                    totalAmount=totalAmount+(model.price! * seperateItemQuantityList![index]);
                  }
                  else{
                    totalAmount=totalAmount+(model.price! * seperateItemQuantityList![index]);
                  }
                  
                   if(snapshot.data!.docs.length-1==index){
                     WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) { 
                       Provider.of<TotalAmount>(context,listen: false).displayTotalAmaunt(totalAmount.toDouble());
                     });
                   }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber:seperateItemQuantityList![index] ,
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                )
              );

            },
          ),
        ],
      ),
    );
  }
}
