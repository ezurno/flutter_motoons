import 'package:flutter/material.dart';
import 'package:flutter_motoons/models/webtoon_episode_model.dart';
import 'package:flutter_motoons/services/api_service.dart';
import 'package:flutter_motoons/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/webtoon_detail_model.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  // widget.id 의 widget 은 해당하는 별도의 widget 이며 각 해당하는 웹툰을 의미함
  late Future<List<WebtoonEpisodeModel>> episodes;

  late SharedPreferences prefs;
  // shared preferences 를 사용한 변수 설정
  bool isLiked = false; // 좋아요를 눌렀는지 여부, 초깃값은 false

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList("likedToons");
    // 좋아요를 누른 웹툰의 목록을 불러옴

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        //likedToons 리스트에 해당 widget의 id 가 존재하는지
        setState(() {
          isLiked = true;
        });
      }
    } else {
      // likedToons 가 없으면 (첫 실행이면) 좋아요 리스트를 생성
      await prefs.setStringList("likedToons", []); // 초깃값은 빈 배열
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    // 바로 참조가 안되므로 initState 값으로 넣어주어야 함
    episodes = ApiService.getLatestEpisodesById(widget.id);

    initPrefs(); // 저장소 생성함수 실행
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList("likedToons");
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }

      await prefs.setStringList("likedToons", likedToons);

      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // screen 을 위한 기본적인 layout 과 setting을 제공
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,

        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: Icon(
                isLiked
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline_outlined,
              ))
        ],
        // favorite 은 appBar 에 넣을 것이므로 action 을 추가

        elevation: 2,
        centerTitle: true, // android tool는 자동 가운데 정렬이 없으므로 따로 지정
        title: Text(
          widget.title,
          // 해당 부분이 title -> widget.title 로 바뀐 이유는 detailScreen 이 stateless 에서 stateful 로 바뀌었기 때문
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // 화면이 overflow 될 때 감싸주면 넘치는 화면을 제대로 구사 할 수 있음
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
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
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
                        },
                        // Image.network 는 url 의 이미지를 가져옴
                        // 하지만 브라우저에서 브라우저값이 아니면 차단하기 때문에 User-Agent 값을 넣어주면 해결 됨
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                // webtoon 과 episodes 를 가져오기 위해 사용

                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text("...");
                  }
                },
                // widget 을 return gksms builder.
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                // episodes 를 받아오기 위해
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!.length > 8
                            ? snapshot.data!.sublist(0, 8)
                            : snapshot.data!)
                          // 최근 8편의 웹툰만 노출 되게 끔 조건문 작성

                          Episode(episode: episode, webtoonId: widget.id)
                      ],
                    );
                  }

                  // 만약 리스트의 길이를 모르면 ListView() 로 생성하는 편이 좋음

                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
