import 'package:flutter/material.dart';
import 'package:flutter_motoons/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 동작 이벤트를 감지하는 widget

      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            // PageRouteBuilder 를 이용해 화면전환 animation 을 구현
            // https://docs.flutter.dev/cookbook/animation/page-route-animation [문서참고]
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                // Slider 애니메이션을 주는 widget.
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, anmation, secondaryAnimation) =>
                DetailScreen(id: id, title: title, thumb: thumb),
          ),
        );
        // Navigator는 navigation 역할을 해주는 widget. 해당 주소로 이동시켜준다.
        // args 는 context 와 route 로 가짐
        // 해당 screen 의 route 로 연결해주는 materialPageRoute 사용
      },

      child: Column(
        children: [
          Hero(
            // Hero-widget 은 react-animation 의 layoutid 를 사용하는 것과 유사함
            tag: id,
            // tag 는 해당 widget 의 id를 부여하는 값
            child: Container(
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
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
