class Knowledge {
  final String title;
  List<Unit> unitList;

  Knowledge({required this.title, this.unitList = const []});
}

class Unit {
  final String name;
  final DataSource source;
  final String size;
  final DateTime creationDate;
  bool isEnabled = false;

  Unit(
      {required this.name,
        required this.source,
        required this.size,
        required this.creationDate,
        required this.isEnabled
      });
}

class DataSource {
  final String title;
  final String subtitle;
  final String imagePath;

  DataSource({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}
