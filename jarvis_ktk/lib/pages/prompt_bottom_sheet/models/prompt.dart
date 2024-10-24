class Prompt {
  String name;
  String prompt;

  Prompt({required this.name, required this.prompt});
}

class MyPrompt extends Prompt {
  MyPrompt({required super.name, required super.prompt});
}

class PublicPrompt extends Prompt {
  final String category;
  final String? description;
  final String language;
  bool isFavorite;
  final String author;

  PublicPrompt({
    required this.category,
    required this.author,
    this.description,
    required this.language,
    this.isFavorite = true,
    required super.name,
    required super.prompt,
  });
}