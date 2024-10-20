
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            // Phần tên app (ngắn hơn)
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(5.0),
              child: ListTile(
                title: Text(
                  'ChatGPT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            // Phần điều hướng
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Chat'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Personal'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.explore),
                  title: Text('AI Action'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

            Divider(),

            // Phần lịch sử chat chiếm không gian còn lại
            Expanded(
              child: ListView.builder(
                itemCount: 20, // Số lượng lịch sử chat
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.message),
                    title: Text('History $index'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

            Divider(),

            // Phần tên tài khoản
            Container(
              padding: EdgeInsets.all(5.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('Hoang Tuan'), // Tên tài khoản
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
