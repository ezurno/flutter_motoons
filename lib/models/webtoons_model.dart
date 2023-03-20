class WebtoonModel {
  final String title, thumb, id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      // webtoonModel 의 fromJson 이라고 이름 붙인 생성자
      // Map<String, dynamic> 형식으로 이루어져 있으며 json이라고 이름 붙인다는 의미
      : title = json["title"],
        thumb = json["thumb"],
        id = json["id"];

  // 각 값을 넣고 초기화 시켜주는 shotcut 구문
}
