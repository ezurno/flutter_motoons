import 'package:flutter/material.dart';
import 'package:flutter_motoons/models/webtoons_model.dart';
import 'package:flutter_motoons/services/api_service.dart';
import 'package:flutter_motoons/widgets/webtoons_widget.dart';

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
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
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
