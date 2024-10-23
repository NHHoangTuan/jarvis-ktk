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

  PublicPrompt({
    required this.category,
    this.description,
    required this.language,
    this.isFavorite = false,
    required super.name,
    required super.prompt,
  });
}