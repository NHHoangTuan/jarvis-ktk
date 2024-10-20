import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7, // Giảm kích thước Drawer
        child: Column(
          children: [
            // Phần tên app (ngắn hơn)
            Expanded(
              flex: 1,
              child: Container(
              color: Colors.blue,
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
            ),

            // Phần điều hướng
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('ChatGPT'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Khám phá GPT'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            Divider(),

            // Phần lịch sử chat
            Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: 20, // Số lượng lịch sử chat
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Lịch sử chat $index'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

            Divider(),

            // Phần tên tài khoản
            Expanded(
              flex: 1,
              
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