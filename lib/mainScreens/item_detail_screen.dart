import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/models/Items.dart';
import 'package:users_app/widgets/app_bar.dart';

class ItemDetailScreen extends StatefulWidget {

  final Items? model;
  ItemDetailScreen({this.model});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {

  TextEditingController counterTextEditingController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID:widget.model!.sellerUID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
            height: MediaQuery.of(context).size.height*.3,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover
          ),
         Padding(
           padding: const EdgeInsets.all(18.0),
           child: NumberInputPrefabbed.roundedButtons(
             controller:counterTextEditingController ,
             incDecBgColor: Colors.redAccent,
             min: 1,
             max: 9,
             initialValue: 1,
             buttonArrangement: ButtonArrangement.incRightDecLeft,
           ),
         ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.price.toString()+" RSD",
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: InkWell(
              onTap: (){
                int itemCounter=int.parse(counterTextEditingController.text);
                //1.check if item exist already in cart
List<String>seperateItemIDsList=seperateItemIDs();
seperateItemIDsList.contains(widget.model!.itemID)
    ? Fluttertoast.showToast(msg: "Stavka je već dodata u korpu")
                :
                //2.add to cart
                addItemToCart(widget.model!.itemID,context,itemCounter);
              },
              child: Container(
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
                width: MediaQuery.of(context).size.width-12,
                height: 50,
                child: Center(
                  child: Text(
                    "Dodaj u korpu",
                    style: TextStyle(color: Colors.white,fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
