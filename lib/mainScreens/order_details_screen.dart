import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/shipment_address_design.dart';
import 'package:users_app/widgets/status_banner.dart';

class OrderDetailScreen extends StatefulWidget {

  final String? orderID;

  OrderDetailScreen({this.orderID});
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}



class _OrderDetailScreenState extends State<OrderDetailScreen> {

  String orderStatus="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID!)
              .get(),

          builder: (c,snapshot){
            Map? dataMap;
            if(snapshot.hasData)
              {
                dataMap=snapshot.data!.data()! as Map<String, dynamic>;
                orderStatus=dataMap["status"].toString();
              }
            return snapshot.hasData
                ? Container(
              child: Column(
                children: [
                 StatusBanner(
                   status: dataMap!["isSuccess"],
                   orderStatus: orderStatus,
                 ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Din "+ dataMap["totalAmount"].toString(),
                        style:const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ID porudžbine = "+widget.orderID!,
                      style:const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Poručeno :" +
                          DateFormat("dd MMMM, yyyy - hh:mm aa")
                              .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),

                    ),
                  ),
                  const Divider(thickness:4),
                  orderStatus == "ended"
                      ? Image.asset("images/delivered.jpg")
                      : Image.asset("images/state.jpg"),
                  const Divider(thickness:4),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore
                        .instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(dataMap["addressID"]).get(),

                    builder: (c,snapshot){
                      return snapshot.hasData
                          ? ShipmentAddressDesign(
                        model:Address.fromJson(
                          snapshot.data!.data()! as Map<String, dynamic>
                        ),
                      )
                          : Center(child: circularProgress(),);
                    },
                  ),
                ],
              ),

            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
