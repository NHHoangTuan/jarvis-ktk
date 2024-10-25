import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/pages/personal/add_knowledge_persona.dart'; // Import AddKnowledgePersonaPage

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  void _showCreateKnowledgeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Knowledge'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const SizedBox(
            width: double.maxFinite,
            child: AddKnowledgePersonaPage(),
          ),
        );
      },
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
                children: [
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
                          _showCreateKnowledgeDialog, // Gọi phương thức hiển thị dialog
                      icon: const Icon(Icons.add_circle_outlined),
                      label: const Text('New Knowledge'),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: DataTable(
                            columnSpacing:
                                20.0, // Adjust spacing between columns
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Knowledge',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Unit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Size',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Edit time',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: _createRows().map((row) {
                              return DataRow(
                                cells: row.cells.map((cell) {
                                  if (cell.child is Text) {
                                    final text = (cell.child as Text).data!;
                                    return DataCell(
                                      Text(
                                        text.length > 10
                                            ? '${text.substring(0, 10)}...'
                                            : text,
                                      ),
                                    );
                                  }
                                  return cell;
                                }).toList(),
                              );
                            }).toList(),
                            headingRowColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return SimpleColors.navyBlue.withOpacity(
                                    0.5); // Set the background color for the header row
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<DataRow> _createRows() {
  return List<DataRow>.generate(30, (index) {
    return DataRow(cells: [
      DataCell(Row(
        children: [
          const Icon(Icons.token),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name $index'),
              Text(
                'Description $index',
                style: const TextStyle(fontSize: 12.0), // Reduce font size
              ),
            ],
          ),
        ],
      )),
      DataCell(Text('${index + 1}')),
      DataCell(Text('${index + 1} KB')),
      const DataCell(Text('25/10/2024 5PM')),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      )),
    ]);
  });
}
