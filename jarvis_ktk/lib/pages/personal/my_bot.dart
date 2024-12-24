import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/personal/widgets/type_dropdown.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

class MyBotPage extends StatefulWidget {
  //final VoidCallback onApply;

  const MyBotPage({super.key});

  @override
  _MyBotPageState createState() => _MyBotPageState();
}

class _MyBotPageState extends State<MyBotPage> {
  final FocusNode _searchFocusNode = FocusNode(); // Thêm FocusNode

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildDropdownButton() =>
      const Expanded(flex: 3, child: TypeDropdown());

  Widget _buildSearchField() => Expanded(
        flex: 7,
        child: TextField(
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.all(8),
          ),
        ),
      );

  Widget _buildBody() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildDropdownButton(),
                const SizedBox(width: 8),
                _buildSearchField(),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 200).floor();
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 1,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) => _buildGridItem(),
                );
              },
            ),
          ),
        ],
      );

  Widget _buildGridItem() => Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.grey, width: 0.25)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: ResizedImage(
                  imagePath: 'assets/logo.png',
                  height: 80,
                  width: 80,
                  isRound: true,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Description',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.grey, size: 16),
                        SizedBox(width: 4),
                        Text('25/10/2024 5PM',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: IconButton(
                      icon: const Icon(Icons.star, color: Colors.yellow),
                      onPressed: () {}),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {}),
                  )),
            ],
          ),
        ),
      );
}
