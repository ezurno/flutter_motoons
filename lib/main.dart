import 'package:flutter/material.dart';
import 'package:flutter_motoons/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  // StatelessWidget 이라는 super class 에 key 값을 알려줌 >> flutter 가 widget을 찾기 쉽게 id 부여

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
