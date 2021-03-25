# AppStoreCloneProject


### 주요 기능

##### (1) 최근 검색어 기능
- UserDefault를 활용하여 '최근 검색어' 기능을 구현한다.
- 최근 검색어는 30개까지만 저장되며, 최신순으로 정렬된다.

##### (2) 앱 스토어 검색탭 기능
- iTunes Search API를 활용하여 '앱 스토어 검색탭' 처럼 기능한다.

##### (3) 네트워크 및 이미지 캐싱
- 네트워크를 위해, 애플이 제공하는 URLSession API를 사용하였다.
- 이미지 캐싱을 위해, URLCache 클래스를 활용하였다.



### 사용 API
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1)



### 페이지 구성

##### (1) 메인 화면
- UserDefault에 저장된 전체 '최근 검색어'를 보여준다.
- 새로운 키워드 검색시, 업데이트 된다.

##### (2) 검색 화면
- 검색어 입력 중에는 UserDefault에 저장된 데이터를 기반으로 검색한 키워드를 보여준다.
- 검색 후에는 iTunes API를 통해 제공받은 정보를 바탕으로 TableView의 Cell을 구성한다.

##### (3) 상세 화면
- 앱과 관련된 기본 정보, 요약 정보(별점, 다운횟수, 권장 연령, 언어 등), 상세 설명이 제공된다.
- 공유 버튼을 통해 공유할 수 있다.
