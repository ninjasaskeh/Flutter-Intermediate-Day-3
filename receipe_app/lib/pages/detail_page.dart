import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:receipe_app/database/db_helper.dart';
import 'package:receipe_app/network/net_client.dart';

import '../model/meal.dart';

class DetailPage extends StatefulWidget {
  final String? idMeal;
  const DetailPage({super.key, this.idMeal});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = false;
  late Meal meal;
  var db = DBHelper();
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              setFavorite();
            },
            icon: isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border))
      ]),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  strokeWidth: 5,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Hero(
                            tag: '${meal.idMeal}',
                            child: Material(
                              child: CachedNetworkImage(
                                  imageUrl: meal.strMealThumb),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text('${meal.strMeal}'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text('Instruction'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text('${meal.strInstructions}'),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetail();
  }

  void setFavorite() async {
    if (!isFavorite) {
    await db.insert(meal);
    }else {
      await db.delete(meal);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void fetchDetail() async {
    setState(() {
      isLoading = true;
    });

    isFavorite = await db.isFavorite(widget.idMeal);
    if (isFavorite) {
      final resultMeal = await db.get(widget.idMeal!);
      meal = resultMeal;
    } else {
      final client = NetClient();
      final resultMeal = await client.fetchDetailMealsById(widget.idMeal!);
      final mealMap = resultMeal?.meals[0];
      meal = Meal(
        strMeal: mealMap!['strMeal']!,
        strMealThumb: mealMap['strMealThumb']!,
        idMeal: mealMap['idMeal']!,
        strInstructions: mealMap['strInstructions']!,
        strCategory: mealMap['strCategory']
      );
    }
    print("Data detail ${meal.strMeal}");
    setState(() {
      isLoading = false;
    });
  }
}
