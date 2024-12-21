import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/main.dart';
import 'package:jarvis_ktk/pages/personal/add_knowledge_persona.dart'; // Import AddKnowledgePersonaPage
import 'package:jarvis_ktk/routes/app_routes.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late Future<List<Knowledge>> _knowledgeFuture;

  void onAdd() {
    setState(() {
      _knowledgeFuture = getIt<KnowledgeApi>().getKnowledgeList();
    });
  }

  @override
  void initState() {
    super.initState();
    _knowledgeFuture = getIt<KnowledgeApi>().getKnowledgeList();
  }

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
          content: SizedBox(
            width: double.maxFinite,
            child: AddKnowledgePersonaPage(onAdd: onAdd,),
          ),
        );
      },
    );
  }

  void _onKnowledgeTap(Knowledge knowledge) {
    navigatorKey.currentState!.pushNamed(
      AppRoutes.knowledgeInfo,
      arguments: knowledge,
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
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                  const SizedBox(width: 8.0),
                  SizedBox(
                    height: 40.0,
                    child: TextButton.icon(
                      onPressed: _showCreateKnowledgeDialog,
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
      body: FutureBuilder<List<Knowledge>>(
        future: _knowledgeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No knowledge available'));
          } else {
            return LayoutBuilder(
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
                              constraints: BoxConstraints(minWidth: constraints.maxWidth),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: KnowledgeDataTable(knowledgeList: snapshot.data!, onKnowledgeTap: _onKnowledgeTap),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KnowledgeDataTable extends StatelessWidget {
  final List<Knowledge> knowledgeList;
  final Function(Knowledge) onKnowledgeTap;

  const KnowledgeDataTable({super.key, required this.knowledgeList, required this.onKnowledgeTap});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowMaxHeight: double.infinity,
      columnSpacing: 20.0,
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
      rows: knowledgeList.map((knowledge) {
        return KnowledgeRow(
          knowledge: knowledge,
          onTap: () => onKnowledgeTap(knowledge),
        ).build();
      }).toList(),
      headingRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          return SimpleColors.navyBlue.withOpacity(0.5);
        },
      ),
    );
  }
}

class KnowledgeRow {
  final Knowledge knowledge;
  final VoidCallback onTap;

  KnowledgeRow({required this.knowledge, required this.onTap});

  DataRow build() {
    return DataRow(
      cells: [
        DataCell(
          Wrap(
            children: [
              Row(
                children: [
                  const Icon(Icons.token),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          knowledge.knowledgeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          knowledge.description,
                          style: const TextStyle(fontSize: 12.0),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text('${knowledge.numUnits}'),
        ),
        DataCell(
          Text('${knowledge.totalSize} KB'),
        ),
        DataCell(
          Text(knowledge.updatedAt.toString()),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
      ],
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          onTap();
        }
      },
    );
  }
}