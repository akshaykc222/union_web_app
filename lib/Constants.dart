import 'package:flutter/material.dart';


// ignore: non_constant_identifier_names
 NavigationBarContant(BuildContext context){
  return    Container(
    height: 50,
    decoration: BoxDecoration(
        color: Colors.red
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushReplacementNamed(context, "/home");
          },
          child:Icon(Icons.home_filled,color: Colors.white,),
        ),
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            child: Text(
              'Union Gates',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),

            ),
          ),
        )
      ],
    ),
  );
}

const spacer8 = SizedBox(
  height: 8,
  width: 8,
);
const spacer20 = SizedBox(
  height: 20,

);


