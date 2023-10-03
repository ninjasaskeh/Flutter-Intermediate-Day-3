import 'package:flutter/material.dart';
import 'package:receipe_app/widgets/list_meals.dart';

import '../database/db_helper.dart';
import '../model/response_filter.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ResponseFilter? responseFilter;
  bool isLoading = true;
  int currentIndex = 0;
  var db = DBHelper();
  String category = 'Seafood';
  @override
  Widget build(BuildContext context) {
    var listNav = [
      listMeals(responseFilter),
      listMeals(responseFilter),
    ];
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : listNav[currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          currentIndex: currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), label: "Seafood"),
            BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert")
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
              index == 0 ? category = "Seafood" : category = "Dessert";
            });
            fetchFavMeal();
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFavMeal();
  }

  void fetchFavMeal() async {
    var data = await db.gets(category);
    setState(() {
      responseFilter = ResponseFilter(meals: data);
      isLoading = false;
    });
  }
}
