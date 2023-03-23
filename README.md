# 🛠️플러터로 웹툰 앱 만들기

## 시작하기 전에...

- **Flutter**는 **Dart**를 사용하므로 [다트 문법 다시보기](https://github.com/ezurno/dart-learn)
- ⚙️INSTALLATION 참고
- flutter doctor 로 파일 생성시 문제가 없는지 issue check
- powershell 에서 flutter create projectName
- projectName 은 [Naming 규칙](https://dart.dev/tools/pub/pubspec#name)을 따라야 함
- Vscode를 바로 실행하면 간혹 AVD가 켜지지 않으므로 powershell 에서 `code .` 를 사용해야 함

<br/>
<hr/>

###### 20230320

> ## App-bar 생성

<br/>
<img src ="md_resources\resource_1.png" width="200"/>
<br/>
<br/>

- 메인화면에 오늘의 웹툰을 리스트로 뽑아주는 **App-bar** 를 만들어 줌
- **Andorid** 에서는 기본설정으로 가운데지정이 안되어 있기 때문에 따로 지정해주어야 함
- `appbar.AppBar(centerTitle: true)`

<br/>

```Dart
appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
        centerTitle: true,

        // 중략

```

<br/>

> ## API 연결하기

<br/>
<img src ="md_resources\resource_2.png" height="200"/>
<img src ="md_resources\resource_3.png" height="200"/>
<br/>
<br/>

- **API** 연결하기에 앞서 **flutter**에서는 `url` 값을 가져오기 위해선 패키지를 하나 설치해야 함
- **pub.dev** 에서 **http** 검색 및 설치

<br/>

- 설치 방법은 여러가지가 있으며, 그중에서도 `pubspec.yaml` 의 의존성을 따로 설정해 설치해 줄 것임
- `pubspec.yaml` 내 `dependency` > `http: ^0.13.5` 입력

<br/>

```yaml
dependencies:
  flutter:
    sdk: flutter

  http: ^0.13.5
```

<br/>
<img src ="md_resources\resource_4.png" height="400"/>
<br/>
<br/>

- 이외에도 `pubspec.yaml` 에서는 **font**, **img** 등 여러 파일을 설치 할 수 있음

<br/>
<br/>
<img src ="md_resources\resource_5.png" width="400"/>
<br/>
<br/>

- 오른쪽 상단의 `get package` 버튼을 눌러 설치
- 설치가 완료되었으면 **API**를 관리하는 `dart` 파일 생성

<br/>
<br/>

- **API** 를 관리하는 파일 내에서 **API** `get` 방식으로 값을 가져오기 위해 함수 를 사용

<br/>
<img src ="md_resources\resource_6.png" width="400"/>
<br/>
<br/>

- `Uri` 타입으로 값을 주어야한다고 경고표시가 남
- `get` 의 return type 은 **Future**, **Future**는 미래에 받을 값을 알려줌
- **API**통신 시 **delay**가 생길 수 있으므로 **Future** 사용, 응답이 완료 됐을 때 까지 대기함
- **React** 의 `async`, `await`와 비슷함
- 통신시 `statusCode`를 항상 확인하는 습관이 중요함

<br/>

```Dart
 void getTodaysToons() async {
    final url = Uri.parse("$baseUrl/$today");
    //Uri.parse 를 통해 url를 변경 해줌
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body); // 만약 사애가 200으로 정상일 경우 console 에 내용 출력
      return;
    }
    throw Error(); // 그렇지 않을 시 error
  }
```

<br/>
<img src ="md_resources\resource_7.png" width="400"/>
<br/>
<br/>

- 정상적으로 data 값이 출력된다

<br/>

> ## 생성자를 활용하여 API 값을 새 인스턴스로

<br/>

- 이대로 가져온 `response.body` 값은 사실상 형태가 `json` 형식이 아닌 `string` 형태로 저장이 된다
- 따라서 `json` 형식으로 바꾸어 주어야 한다

<br/>

```Dart
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      // response.body로 가져오면 String 형식이 되므로 json형식으로 decoding 해준다
      // 새로운 List 타입의 공간으로 값을 할당
    }
```

<br/>

- 각 `Object` 값을 `WebtoonModel`로 **reform** 함

<br/>

```Dart
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
```

```Dart
for (var webtoon in webtoons) {
        final toonInfo = WebtoonModel.fromJson(webtoon);
        // print(toonInfo)
}
```

<br/>
<img src ="md_resources\resource_8.png" height="300"/>
<img src ="md_resources\resource_9.png" width="400"/>
<br/>
<br/>

- 값이 제대로 변환되었다.
- 이제 변환된 값을 사용할 수 있도록 최종적으로 `webtoonsInstance` 에 넣어서 관리해준다.

<br/>

```Dart

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstance = [];

    final url = Uri.parse("$baseUrl/$today");
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);


      for (var webtoon in webtoons) {
        final toonInfo = WebtoonModel.fromJson(webtoon);
        webtoonInstance.add(toonInfo); // 값을 넣어줌
      }

      return webtoonInstance;
    }
    throw Error(); // 그렇지 않을 시 error
  }
```

<br/>

###### 20230323

> ## 외부 Widget에서 API 값 사용하기

<br/>

- **API** 값을 가져오는 **widget**의 변수와 비동기함수를 `static`으로 우선 변환 시켜준다
- tatic 을 거는 이유는 ApiService 마다 값이 공유가 되어야하는데 걸지 않았을 경우, 값을 할당할 때 따로 놀기 때문
- 사용할 **Widget**의 `Stateless` 를 `Stateful`로 수정해주고 **API-instance**값을 저장할 새 `state`를 만들어준다.

<br/>

```Dart
class _HomeScreenState extends State<HomeScreen> {
  List<WebtoonModel> webtoons = [];
  bool isLoading = true;
  void waitForWebToons() async {
    webtoons = await ApiService.getTodaysToons();
    // API server 에서 받아온 webtoonInstance 를 가져옴
    isLoading = false;
    setState(() {});
  }
}
```

<br/>
<img src ="md_resources\resource_10.png" width="400"/>
<br/>
<br/>

- `print()`를 사용해 디버그콘솔로 확인해봄
- `restart` 시 빈 배열에 loading 값도 **true**로 나오다가 비동기처리 된 API 값이 완전히 받아왔을 시 정상적으로 값을 가져오는 모습

<br/>
<br/>

> ## FutureBuilder 를 사용해 API 간단하게 연결하기

<br/>

- 간혹 `state`를 사용할 수 없는 **widget**이 있기도 하며 더 간단하게 `api` 연결을 할 수 있음
- `FutureBuilder` 를 사용하면 `statelessWidget` 에서도 `api` 연결 가능
- `Scaffold.body` 에 넣어서 사용

<br/>

```Dart
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  //  webtoons 가 곧 가져올 API 값을 할당할 것이기 때문에 Future 로 지정
}
 // 중략

return Scaffold(
  body: FutureBuilder(
    future: webtoons,
    // FutureBuilder 가 webtoons 를 기다리게 해줌
    builder: (context, snapshot) {
      // shotcut으로 받을 수 있음
      // 요구하는 함수는 context와 snapshot을 받는데, snapshot은 future 의 상태를 나타냄
      if(snapshot.hasData) {
        // future 의 값이 존재 할 시,
        return const Text("It has data!");
      } else return const Text("Loading . . .");
    }
  )

)
```

<br/>
<img src ="md_resources\resource_11.png" width="400"/>
<br/>
<br/>

- 데이터 값을 받아오기 전엔 **Loading...**, 정상적으로 데이터를 로드 한 후엔 **It has data!** 를 출력하는 모습
