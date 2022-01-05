import 'package:flutter/material.dart';
import 'package:spendzz/category/slider_component/slide.dart';
class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
            ),
            image: DecorationImage(
              image: NetworkImage(slideList[index].imageUrl),
              fit: BoxFit.fill,
            ),
          ),
        ),
        /*SizedBox(
          height: 40,
        ),
      *//*  Text(
          slideList[index].title,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).primaryColor,
          ),
        ),*//*
        SizedBox(
          height: 10,
        ),
        *//*Text(
          slideList[index].description,
          textAlign: TextAlign.center,
        ),*/
      ],
    );
  }
}
