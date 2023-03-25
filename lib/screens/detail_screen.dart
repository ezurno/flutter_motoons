import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // screen 을 위한 기본적인 layout 과 setting을 제공
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
        centerTitle: true, // android tool는 자동 가운데 정렬이 없으므로 따로 지정
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                clipBehavior: Clip.hardEdge,
                // 자식 widget의 영역을 관리해줌 >> 넘치는 화면을 hardEdge로 잘라줌
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(10, 10),
                      blurRadius: 15,
                    ), // BoxShadow widget은 Box의 그림자를 만들어주는 Widget
                  ],
                ),
                child: Image.network(
                  thumb,
                  headers: const {
                    "User-Agent":
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
                  },
                  // Image.network 는 url 의 이미지를 가져옴
                  // 하지만 브라우저에서 브라우저값이 아니면 차단하기 때문에 User-Agent 값을 넣어주면 해결 됨
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
