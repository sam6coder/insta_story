import "package:flutter/material.dart";

class AppBarWidgetScreen extends StatelessWidget implements PreferredSizeWidget{
  final Color backgroundColor;
  final String title;
  final double height;

  AppBarWidgetScreen({
    required this.backgroundColor,
    required this.title,
    required this.height
});

  @override
  Size get preferredSize=>Size.fromHeight(height);

  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:8.0,left:8,right:8),
      child: AppBar(
        backgroundColor: backgroundColor,
        title: Align(alignment:Alignment.topLeft,child: Text(title,style: TextStyle(color: Colors.white,fontFamily: 'MonteCarlo',fontWeight: FontWeight.bold,fontSize: 35),)),

        actions: [
          Padding(
            padding: const EdgeInsets.only(top:7.0),
            child: Align(alignment:Alignment.topRight,child: IconButton(onPressed: (){}, icon: Icon(Icons.message,color: Colors.white,size: 27,))),
          )
        ],
      ),

    );
  }
}