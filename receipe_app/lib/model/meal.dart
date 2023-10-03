class Meal {
    final String strMeal;
    final String strMealThumb;
    String idMeal;
    final String? strInstructions;
    final String? strCategory;

    Meal({
        required this.strMeal,
        required this.strMealThumb,
        required this.idMeal,
        this.strInstructions,
        this.strCategory,
    });

    factory Meal.fromJson(Map<dynamic, dynamic> json) => Meal(
        strMeal: json["strMeal"],
        strMealThumb: json["strMealThumb"],
        idMeal: json["idMeal"],
        strInstructions: json["strInstructions"],
        strCategory: json["strCategory"],
    );

    Map<String, dynamic> toJson() => {
      "strMeal" : strMeal,
      "strMealThumb" : strMealThumb,
      "idMeal" : idMeal,
      "strInstructions" : strInstructions,
      "strCategory" : strCategory,
    };

    void setFavoriteId(String id) {
      idMeal = id;
    }
}