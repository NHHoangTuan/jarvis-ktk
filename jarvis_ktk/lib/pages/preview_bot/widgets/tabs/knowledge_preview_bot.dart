import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/mock_data.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/dialog/add_knowledge_preview_bot.dart';


class KnowledgePreviewBotPage extends StatefulWidget {
  const KnowledgePreviewBotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgePreviewBotPageState createState() =>
      _KnowledgePreviewBotPageState();
}

class _KnowledgePreviewBotPageState extends State<KnowledgePreviewBotPage>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = false;
  bool _showDeleteButtons = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: Icon(_isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                    title: const Text(
                      'Knowledge',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String result) {
                        if (result == 'Add') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  child: AddKnowledgePreviewBot(knowledgeList: knowledgeList),
                                ),
                              );
                            },
                          );
                        } else if (result == 'Remove' || result == 'Done') {
                          setState(() {
                            _showDeleteButtons = !_showDeleteButtons;
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'Add',
                          child: Text('Add'),
                        ),
                        PopupMenuItem<String>(
                          value: _showDeleteButtons ? 'Done' : 'Remove',
                          child: Text(_showDeleteButtons ? 'Done' : 'Remove'),
                        ),
                      ],
                    ),
                  ),
                  if (_isExpanded) const Divider(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded ? knowledgeList.length * 56.0 : 0.0,
                    child: _isExpanded
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Card(
                              margin: EdgeInsets
                                  .zero, // Align the card with the container
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: knowledgeList
                                    .map(
                                      (knowledge) => ListTile(
                                        title: Text(knowledge.title),
                                        leading: const Icon(Icons.visibility),
                                        trailing: _showDeleteButtons
                                            ? IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    knowledgeList.remove(knowledge);
                                                  });
                                                },
                                              )
                                            : null,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
