import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs{
  static void showSnackbar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        child: Text(message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0,
          ),

        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
    ));
  }
  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator()));
  }
}