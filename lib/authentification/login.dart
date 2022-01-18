import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/home_screen.dart';
import 'package:users_app/widgets/costum_textField.dart';
import 'package:users_app/widgets/error_dialog.dart';
import 'package:users_app/widgets/loading_dialog.dart';


import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key:key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  formValidation(){
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
      {
        //login
        loginNow();
      }
    else{
      showDialog(
        context: context,
        builder: (c){
          return ErrorDialog(message:"Molimo vas unesite email/lozinku",
          );
        }
      );
    }
  }

  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Provjera unesenih podataka",
          );
        }
    );

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });
    if (currentUser != null)
  {
    readDataAndSetDataLocally(currentUser!);


  }
  }

  Future readDataAndSetDataLocally(User currentUser) async{
    await FirebaseFirestore.instance.collection("users")
        .doc(currentUser.uid).get().then((snapshot) async{
          if(snapshot.exists)
            {
              await sharedPreferences!.setString("uid", currentUser.uid);
              await sharedPreferences!.setString("email",snapshot.data()!["email"]);
              await sharedPreferences!.setString("name", snapshot.data()!["name"]);
              await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);

              List<String> userCartList=snapshot.data()!["userCart"].cast<String>();
              await sharedPreferences!.setStringList("userCart", userCartList);


              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
            }
          else
            {
              firebaseAuth.signOut();
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));

              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorDialog(message: "Nepostojeći korisnik",
                    );
                  }
              );
            }
           });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child:Padding(
              padding:EdgeInsets.all(15),
              child:Image.asset(
                  "images/login.png",
                   height: 270,
              ),

            )
          ),
          Form(
            key:_formKey,
            child:Column(
              children: [
                CustomTextField(
                  data:Icons.email,
                  controller:emailController,
                  hintText:"Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data:Icons.lock,
                  controller:passwordController,
                  hintText:"Lozinka",
                  isObsecre: true,
                ),
              ],
            )
          ),

          ElevatedButton(
            child:const Text(
              "Uloguj se",
              style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
            ),
            style:ElevatedButton.styleFrom(
              padding:const EdgeInsets.symmetric(horizontal: 50,vertical:10),
              primary:Colors.cyan,
            ),
            onPressed: (){
              formValidation();
            },
          ),
          const SizedBox(height: 30,),
        ],
      )
    );
  }
}
