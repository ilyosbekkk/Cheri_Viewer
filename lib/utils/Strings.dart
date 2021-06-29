//languages
 String english = "en";
 String korean = "kr";
 Map<String, String> home_title = {"en": "Home", "kr": "홈"};
 Map<String, String> search_title = {"en": "Search", "kr": "검색"};
 Map<String, String> storage_title = {"en": "Storage", "kr": "보관함"};
 Map<String, String> bookmark_tab = {english: "Bookmarks", korean: "북마크"};
 Map<String, String> opened_tab = {english: "Opened", korean: "여러본 체리"};
 Map<String, String> app_name = {english: "CheriViewer", korean: "체리뷰버"};
 Map<String, String> cheri_views = {english: "Views", korean: "조회수"};
 Map<String, String> search_hint = {english: "Please enter cheri name...", korean: "체리 이름을 입력하십시오..."};
 Map<String, List<String>> categories = {
  english: ["Health", "Life", "Education.Learning", "IT.Content", "Personal Development"],
  korean: ["건강", "생활", "교육.학습", "IT.컨텐츠", "자기개발"]
};

//Api url
const String baseUrl = "cheri.weeknday.com";
const String postsList = "/api/Viewerapi/list";
const String searchPost = "/api/native/search";
const String categoryList = "/api/Viewerapi/side_category";
