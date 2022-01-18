import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/models/Menus.dart';
import 'package:users_app/models/Sellers.dart';
import 'package:users_app/splash_screen/splashScreen.dart';
import 'package:users_app/widgets/menus_design.dart';
import 'package:users_app/widgets/sellers_design.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/text_widget_header.dart';


class MenusScreen extends StatefulWidget {

  final Sellers? model;
  MenusScreen({this.model});
  @override
  _MenusScreenState createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
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
          icon:const  Icon(Icons.arrow_back),
          onPressed:(){
            clearCartNow(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
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

      ),
      body:CustomScrollView(
        slivers:[
          SliverPersistentHeader(pinned:true,delegate: TextWidgetHeader(title:widget.model!.sellerName.toString()+ " Meniji")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .orderBy("publishedDate",descending: true).snapshots(),
            builder: (context,snapshot){
              return !snapshot.hasData ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                itemBuilder: (context,index){
                  Menus model=Menus.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String,dynamic>,
                  );
                  return MenusDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );

            },
          )
        ],
      ),
    );
  }
}
