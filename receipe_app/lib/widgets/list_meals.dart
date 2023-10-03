import 'package:flutter/material.dart';
import 'package:receipe_app/model/response_filter.dart';
import 'package:receipe_app/pages/detail_page.dart';

import 'item_meals.dart';


Widget listMeals(ResponseFilter? responseFilter, [Function()? fetchDataMeals]) {
 if (responseFilter == null) {
   return Container();
 }
 return ListView.builder(
   itemCount: responseFilter.meals.length,
   itemBuilder: (context, index) {
     var itemMeal = responseFilter.meals[index];


     return InkWell(
       splashColor: Colors.lightBlue,
       child:
           itemMeals(itemMeal),
       onTap: () async {
        final route =  MaterialPageRoute(builder: (context) => DetailPage(idMeal: itemMeal.idMeal),);
        Navigator.push(context, route);
       },
     );
   },
 );
}





