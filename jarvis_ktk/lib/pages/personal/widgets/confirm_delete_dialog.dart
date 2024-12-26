import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/colors.dart';

// class ConfirmDeleteBotDialog extends StatefulWidget {
//   final String title;
//   final String content;
//   final String botId;

//   const ConfirmDeleteBotDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.botId,
//   });

//   static Future<bool?> show(
//       {required BuildContext context,
//       required String title,
//       required String content,
//       required String botId}) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return ConfirmDeleteBotDialog(
//           title: title,
//           content: content,
//           botId: botId,
//         );
//       },
//     );
//   }

//   @override
//   _ConfirmDeleteBotDialogState createState() => _ConfirmDeleteBotDialogState();
// }

// class _ConfirmDeleteBotDialogState extends State<ConfirmDeleteBotDialog> {
//   bool _isDeleteLoading = false;

//   Future<void> _handleDeleteBot(String botId) async {
//     try {
//       setState(() {
//         _isDeleteLoading = true;
//       });

//       await Provider.of<BotProvider>(context, listen: false).deleteBot(botId);

//       showToast('Bot deleted successfully');
//     } catch (e) {
//       showToast('Failed to delete bot');
//     } finally {
//       setState(() {
//         _isDeleteLoading = false;
//       });

//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     }
//   }

//   void showToast(String message) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.blueGrey.shade900,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.title),
//       content: Text(widget.content),
//       actions: [
//         SizedBox(
//           width: 80,
//           height: 35,
//           child: TextButton(
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               backgroundColor: Colors.transparent,
//             ),
//             onPressed: () => Navigator.of(context).pop(false), // Confirm delete
//             child: const Text('Cancel',
//                 style: TextStyle(color: SimpleColors.blue)),
//           ),
//         ),
//         SizedBox(
//           width: 80,
//           height: 35,
//           child: TextButton(
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               backgroundColor: Colors.red,
//             ),
//             onPressed: _isDeleteLoading
//                 ? null
//                 : () => _handleDeleteBot(widget.botId), // Confirm delete
//             child: _isDeleteLoading
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ConfirmDeleteDialog extends StatefulWidget {
  final String title;
  final String content;
  final Future<void> Function() onDelete;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onDelete,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required Future<void> Function() onDelete,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          title: title,
          content: content,
          onDelete: onDelete,
        );
      },
    );
  }

  @override
  State<ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);

    try {
      await widget.onDelete();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
      showToast("Bot deleted successfully");
    } catch (e) {
      showToast("Failed to delete bot");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: [
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.transparent,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: SimpleColors.blue)),
          ),
        ),
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.red,
            ),
            onPressed: _isLoading ? null : _handleDelete,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
