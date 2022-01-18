import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/mainScreens/placed_order_screen.dart';
import 'package:users_app/maps/maps.dart';
import 'package:users_app/models/address.dart';

class AddressDesign extends StatefulWidget {

  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  AddressDesign({
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
});

  @override
  _AddressDesignState createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        //sellect this address
        Provider.of<AddressChanger>(context,listen:false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                //address info
                Radio(
        groupValue: widget.currentIndex!,
          value: widget.value!,
          activeColor: Colors.redAccent.withOpacity(0.3),
          onChanged: (val){
            //provider
            Provider.of<AddressChanger>(context,listen:false).displayResult(val);
            print(val);
          },
        ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
Container(
  padding: EdgeInsets.all(10),
  width: MediaQuery.of(context).size.width*0.8,
  child: Table(
    children: [
      TableRow(
        children: [
          const   Text(
            "Ime:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Text(widget.model!.name.toString()),
        ],
      ),
      TableRow(
        children: [
          const Text(
            "Telefon:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Text(widget.model!.phoneNumber.toString()),
        ],
      ),
      TableRow(
        children: [
          const Text(
            "Broj stana:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Text(widget.model!.flatNumber.toString()),
        ],
      ),
      TableRow(
        children: [
          const Text(
            "Grad:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
         Text(widget.model!.city.toString()),
        ],
      ),
      TableRow(
        children: [
          const Text(
            "Zemlja:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Text(widget.model!.state.toString()),
        ],
      ),
      TableRow(
        children: [
          const Text(
            "Kompletna adresa:",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Text(widget.model!.fullAddress.toString()),
        ],
      ),
    ],
  ),
),
                  ],
                ),
              ],
            ),

            //button
            ElevatedButton(
              child: Text("Provjeri na mapi"),
              style: ElevatedButton.styleFrom(primary: Colors.black54),
              onPressed: (){
                MapsUtils.openMapWithPosition(widget.model!.lat!, widget.model!.long!);
                //  MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
              },
            ),

            //button
widget.value==Provider.of<AddressChanger>(context).count
            ? ElevatedButton(
  child: Text("Procesiraj"),
  style: ElevatedButton.styleFrom(
    primary: Colors.green,
  ),
  onPressed: ()
  {
    Navigator.push(
        context, MaterialPageRoute(
        builder: (c)=>PlacedOrderScreen(
          addressID:widget.addressID,
          totalAmount:widget.totalAmount,
          sellerUID:widget.sellerUID,
        ))
    );
  },
)
            : Container(),
          ],
        ),
      ),
    );
  }
}
