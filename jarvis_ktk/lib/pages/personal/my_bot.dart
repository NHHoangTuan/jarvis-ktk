import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/dialog/edit_preview_bot.dart';
import 'package:jarvis_ktk/utils/resized_image.dart'; // Import EditPreviewBotPage

class MyBotPage extends StatefulWidget {
  final VoidCallback onApply;

  const MyBotPage({super.key, required this.onApply});

  @override
  // ignore: library_private_types_in_public_api
  _MyBotPageState createState() => _MyBotPageState();
}

class _MyBotPageState extends State<MyBotPage> {
  final GlobalKey _dropdownKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  double _containerWidth = 0.0;
  String _selectedType = 'All';

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _updateContainerWidth(); // Update the container width before creating the overlay
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _updateContainerWidth() {
    RenderBox containerRenderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _containerWidth = containerRenderBox.size.width;
    });
  }

  void _showCreateBotDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bo tròn các góc
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Create Bot'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: EditPreviewBotPage(
              onApply: widget.onApply, // Truyền callback onApply
            ), // Hiển thị EditPreviewBotPage với callback
          ),
        );
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: _containerWidth,
        child: Material(
          elevation: 4.0,
          child: Container(
            width: _containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Bo góc container
              color: Colors.white, // Background color for the container
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Bo góc card
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text(
                      'All',
                      overflow: TextOverflow.ellipsis, // Add ellipsis
                    ),
                    onTap: () {
                      setState(() {
                        _selectedType = 'All';
                      });
                      _toggleDropdown();
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Published',
                      overflow: TextOverflow.ellipsis, // Add ellipsis
                    ),
                    onTap: () {
                      setState(() {
                        _selectedType = 'Published';
                      });
                      _toggleDropdown();
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'My Favourite',
                      overflow: TextOverflow.ellipsis, // Add ellipsis
                    ),
                    onTap: () {
                      setState(() {
                        _selectedType = 'My Favourite';
                      });
                      _toggleDropdown();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0), // Add left padding
              child: Row(
                key: _dropdownKey,
                children: [
                  Container(
                    key: _containerKey,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Type:',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Text(
                          _selectedType,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis, // Add ellipsis
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          onPressed: _toggleDropdown,
                          padding: EdgeInsets.zero, // Remove padding
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0), // Add spacing between elements
                  Expanded(
                    child: Container(
                      height: 40.0, // Set a fixed height for the search box
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.only(bottom: 10.0),
                          border: InputBorder.none,
                          icon: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Add spacing between elements
                  SizedBox(
                    height: 40.0, // Match the height of the search box
                    child: TextButton.icon(
                      onPressed:
                          _showCreateBotDialog, // Gọi phương thức hiển thị dialog
                      icon: const Icon(Icons.add_circle_outlined),
                      label: const Text('Create Bot'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: SimpleColors.navyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 2 / 1, // Aspect ratio of each grid item
          ),
          itemCount: 20, // Number of items in the grid
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const ResizedImage(imagePath: 'assets/logo.png', height: 40, width: 40, isRound: true),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.star,
                                    color: Colors.yellow, size: 16),
                                onPressed: () {
                                  // Add your onPressed code here!
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 16),
                                onPressed: () {
                                  // Add your onPressed code here!
                                },
                              ),
                            ],
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          const SizedBox(height: 4.0),
                          const Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '25/10/2024 5PM',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
