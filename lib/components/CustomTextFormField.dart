import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({Key? key,required this.textController,required this.hintText,required this.errorText,required this.icons}) : super(key: key);
  TextEditingController textController;
  String hintText;
  String errorText;
  IconData icons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical:10),
      child: TextFormField(
        obscureText: hintText=="password",
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey[600],
          ),
          labelText:hintText,

        ),
        validator: (value){
          if(value==null || value.isEmpty) {
            return errorText;
          }
          return null ;
        },

      ),
    );
  }
}