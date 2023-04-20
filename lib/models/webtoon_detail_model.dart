class WebtoonDetailModel {
  late final String title, about, genre, age;

  // Api Server 로 부터 받아올 속성들의 타입

  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        about = json["about"],
        genre = json["genre"],
        age = json["age"];
}
