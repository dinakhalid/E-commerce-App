import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key ,required this.text,required this.onTapAction}) : super(key: key);
  final String text;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: InkWell(
        onTap: onTapAction,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,

          ),
          width: double.infinity,
          height: 50,

          child: Center(
            child: Text(
              text,
              style:TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold) ,),
          ),
        ),
      ),
    );
  }
}