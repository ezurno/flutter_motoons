import 'dart:convert';

import 'package:flutter_motoons/models/webtoon_detail_model.dart';
import 'package:flutter_motoons/models/webtoons_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  // url 을 받아오기 위해선 http package를 설치해야 함
  // pub.dev 에서 search
  // static 을 거는 이유는 ApiService 마다 값이 공유가 되어야하는데 걸지 않았을 경우,
  // 값을 할당할때 따로 놀기 때문

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstance = [];

    final url = Uri.parse("$baseUrl/$today");
    //Uri.parse 를 통해 url를 변경 해줌
    final response = await http.get(url);
    /*
    get 의 return type 은 Future, Future는 미래에 받을 값을 알려줌
    >> API통신 시 delay가 생길 수 있으므로 Future 사용, 응답이 완료 됐을 때 까지 대기함
    
    >> React 의 await, async 와 비슷함
    >> 함수에 async 와 await를 사용해 걸어줌
    */

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      // response.body로 가져오면 String 형식이 되므로 json형식으로 decoding 해준다
      // 새로운 List 타입의 공간으로 값을 할당

      for (var webtoon in webtoons) {
        final toonInfo = WebtoonModel.fromJson(webtoon);
        // WebtoonModel 에서 구현한 fromJson 생성자를 이용해 object를 분리
        // print(toonInfo.title);

        webtoonInstance.add(toonInfo);
      }

      return webtoonInstance;
    }
    throw Error(); // 그렇지 않을 시 error
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    // 가져올 id 값의 데이터를 받아와야 하므로
    final response = await http.get(url); // 응답 값을 가져옴
    if (response.statusCode == 200) {
      // 응답 값이 200 이면 정상적으로 값을 가져온 것이므로
      final webtoon = jsonDecode(response.body); // 받아온 json 의 값을 decode 해서 풀어줌

      return WebtoonDetailModel.fromJson(
          webtoon); // 그 값을 새로운 WebtoonDetailModel 로 재 생성
    }
    throw Error(); // 그렇지 않을 시 에러
  }
}
