import 'package:flutter/material.dart';
import 'package:flutter_motoons/models/webtoons_model.dart';
import 'package:flutter_motoons/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

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
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        // FutureBuilder 가 webtoons 를 기다리게 해줌
        builder: (context, snapshot) {
          // builder 는 함수를 shotcut으로 받을 수 있음
          // 요구하는 함수는 context와 snapshot을 받는데, snapshot은 future 의 상태를 나타냄
          if (snapshot.hasData) {
            // future 의 값이 존재 할 시,
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                  //ListView 가 높이가 무한정으로 커질 수 있기 떄문에 error 가 나는데, Expanded로 잡아주어 해결
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      //ListView.builder 는 ListView 의 상위 버전
      // user 가 해당 항목을 보고있지 않는다면 항목을 메모리에서 삭제해버림
      //ListView.separated 는 builder 가 만든 item 사이에 무언가를 넣을 시 사용
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,

      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ), // ListView 에 padding 을 줌

      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Column(
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
                webtoon.thumb,
                headers: const {
                  "User-Agent":
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
                },
                // Image.network 는 url 의 이미지를 가져옴
                // 하지만 브라우저에서 브라우저값이 아니면 차단하기 때문에 User-Agent 값을 넣어주면 해결 됨
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              webtoon.title,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        );
      },

      separatorBuilder: (context, index) {
        // 사이 간격에 넣을 시 사용
        return const SizedBox(
          width: 40,
        );
      },
    );
  }
}
