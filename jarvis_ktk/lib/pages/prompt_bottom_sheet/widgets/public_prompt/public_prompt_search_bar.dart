import 'package:flutter/material.dart';

class PublicPromptSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const PublicPromptSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 0.0),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15.0, height: 1),
        decoration: InputDecoration(
          hintText: 'Search',
          fillColor: Colors.grey[100],
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
