import 'package:blog/view/bloglistview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BlogListView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
