import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';

import '../../models/knowledge.dart';
import '../knowledge_info_page.dart';

class AddKnowledgePreviewBot extends StatefulWidget {
  final List<Knowledge> knowledgeList;
  const AddKnowledgePreviewBot({super.key, required this.knowledgeList});

  @override
  // ignore: library_private_types_in_public_api
  _AddKnowledgePreviewBotState createState() => _AddKnowledgePreviewBotState();
}

class _AddKnowledgePreviewBotState extends State<AddKnowledgePreviewBot> {
  List<bool> isAdded =
      List<bool>.generate(10, (index) => false); // Example item count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  height: 50, // Match the height of the TextField
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.white),
                    label: const Text(
                      'Create',
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: SimpleColors
                          .navyBlue, // Sử dụng màu navyBlue từ file colors.dart
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.knowledgeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // Navigate to the knowledge detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return KnowledgeInfoPage(knowledge: widget.knowledgeList[index]);
                        },
                      ),
                    );
                  },
                  leading:
                      const Icon(Icons.folder, size: 48.0), // Double the size
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.knowledgeList[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          Card(
                            color: SimpleColors.indigoBlue.withOpacity(
                                0.2), // Set background color with opacity
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: const BorderSide(
                                color: SimpleColors.indigoBlue,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(4.0), // Reduce padding
                              child: Text(
                                '$index Unit',
                                style: const TextStyle(
                                  fontSize: 12.0, // Reduce font size
                                  color: SimpleColors
                                      .indigoBlue, // Set text color to match border color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0), // Reduce spacing
                          Card(
                            color: SimpleColors.mediumBlue.withOpacity(
                                0.2), // Set background color with opacity
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: const BorderSide(
                                color: SimpleColors.mediumBlue,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(4.0), // Reduce padding
                              child: Text(
                                '$index KB',
                                style: const TextStyle(
                                  fontSize: 12.0, // Reduce font size
                                  color: SimpleColors
                                      .mediumBlue, // Set text color to match border color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 12.0), // Reduce icon size
                          const SizedBox(width: 4.0),
                          Text(
                            'Today ${TimeOfDay.now().format(context)}',
                            style: const TextStyle(
                                fontSize: 12.0), // Reduce text size
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color:
                          isAdded[index] ? Colors.red : SimpleColors.navyBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isAdded[index] ? Icons.remove_circle : Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isAdded[index] = !isAdded[index];
                        });
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}