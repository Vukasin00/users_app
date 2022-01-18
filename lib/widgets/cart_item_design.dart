import 'package:flutter/material.dart';
import 'package:users_app/models/Items.dart';

class CartItemDesign extends StatefulWidget {

  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    this.model,
    this.context,
    this.quanNumber,
});

  @override
  _CartItemDesignState createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child:Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              //image
              Image.network(widget.model!.thumbnailUrl!,width: 140,height: 120,fit: BoxFit.cover),

              const SizedBox(width: 6,),

              //title
              //quantity number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style:const TextStyle(
                      color:Colors.black,
                      fontSize: 16,
                      fontFamily: "Kiwi"
                    ),
                  ),
                  SizedBox(height: 1.0,),
                  Row(
                    children: [
                      const Text(
                        "x ",
                        style:TextStyle(
                            color:Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme"
                        ),
                      ),
                      Text(
                        widget.quanNumber.toString(),
                        style:const TextStyle(
                            color:Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme"
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Cijena: ",
                        style:TextStyle(
                            color:Colors.grey,
                            fontSize: 16,
                            fontFamily: "Acme"
                        ),
                      ),
                     const Text(
                       "RSD ",
                        style:TextStyle(
                            color:Colors.green,
                            fontSize: 16,
                            fontFamily: "Acme"
                        ),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style:const TextStyle(
                            color:Colors.green,
                            fontSize: 16,
                            fontFamily: "Acme"
                        ),
                      ),
                    ],
                  ),
                ],
              ),


            ],
          ),
        ),
      )
    );
  }
}
