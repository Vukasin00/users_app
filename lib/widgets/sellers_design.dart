import 'package:flutter/material.dart';
import 'package:users_app/mainScreens/menus_screen.dart';
import 'package:users_app/models/Sellers.dart';

class SellersDesignWidget extends StatefulWidget {

  Sellers? model;
  BuildContext? context;

  SellersDesignWidget({this.model,this.context});

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MenusScreen(model:widget.model)));
      },
      splashColor: Colors.redAccent,
      child:Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],

              ),
              Image.network(
                  widget.model!.sellerAvatarUrl!,
                      height:210,
                width:  MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 23,
                  fontFamily:"Kiwi",
                ),
              ),
              Text(
                widget.model!.sellerEmail!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily:"Kiwi",
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],

              ),
            ],
          ),
        ),
      )
    );
  }
}
