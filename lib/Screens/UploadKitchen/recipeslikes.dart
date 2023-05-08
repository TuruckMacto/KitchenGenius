class Recipe {
  String title;
  String description;
  int likes;

  Recipe({
    required this.title,
    required this.description,
    this.likes = 0,
  });
}