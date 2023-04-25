import 'package:flutter/material.dart';
import 'package:flutter_motoons/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Episode extends StatelessWidget {
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
    // 원하는 웹툰의 url 로 이동하기 위해 webtoonId 로 detail_screen 의 widget.id 를 받아옴
  });

  final WebtoonEpisodeModel episode;
  final String webtoonId;

  onButtonTap() async {
    final url = Uri.parse(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}");
    await launchUrl(url);
    // luanchUrl 은 Future 를 갖는 함수기 때문에 onButtonTap 에 async 를 걸어야 함
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 사용자의 터치를 인식하기 위해 사용하는 Widget
      onTap: onButtonTap, // 해당하는 widget을 클릭 했을 시 onButtonTap 함수를 실행

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
