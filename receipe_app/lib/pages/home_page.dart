import 'package:flutter/material.dart';
import 'package:receipe_app/model/response_filter.dart';
import 'package:receipe_app/network/net_client.dart';
import 'package:receipe_app/pages/favorite_page.dart';
import 'package:receipe_app/widgets/list_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ResponseFilter? responseFilter;
  bool isLoading = true;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var listNav = [listMeals(responseFilter), listMeals(responseFilter)];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipe App"),
        actions: [
          IconButton(
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => const FavoritePage());
                Navigator.push(context, route);
              },
              icon: Icon(Icons.favorite))
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : listNav[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          fetchDataMeals();
        },
      ),
    );
  }

  void fetchDataMeals() async {
    try {
      NetClient netClient = NetClient();
      var data = await netClient.fetchDataMeals(currentIndex);
      setState(() {
        responseFilter = data;
        isLoading = false;
      });
      print("Datanya ${responseFilter?.meals}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataMeals();
  }
}
