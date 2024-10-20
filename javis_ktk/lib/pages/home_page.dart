import 'package:flutter/material.dart';
import 'package:javis_ktk/navigation/custom_drawer.dart'; // Import CustomDrawer nếu cần

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('App Navigation'),
      ),
      drawer: CustomDrawer(), // Sử dụng CustomDrawer
      body: Stack(
        children: [
          Center(child: Text('Trang chính')),
          // Vùng vuốt từ 1/3 màn hình
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                // Nếu vuốt từ trái sang phải
                if (details.delta.dx > 10) {
                  _scaffoldKey.currentState?.openDrawer(); // Mở Drawer qua GlobalKey
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4, // 40% màn hình
                color: Colors.transparent, // Để vùng chạm có thể nhìn thấy
              ),
            ),
          ),
        ],
      ),
    );
  }
}