//language strings
String english = "en";
String korean = "kr";
Map<String, String> home_title = {english: "Home", korean: "홈"};
Map<String, String> search_title = {english: "Search", korean: "검색"};
Map<String, String> storage_title = {english: "Storage", korean: "보관함"};
Map<String, String> bookmark_tab = {english: "Bookmarks", korean: "북마크"};
Map<String, String> opened_tab = {english: "Opened", korean: "여러본 체리"};
Map<String, String> app_name = {english: "CheriViewer", korean: "체리뷰버"};
Map<String, String> cheri_views = {english: "Views", korean: "조회수"};
Map<String, String> search_hint = {english: "Please enter cheri name...", korean: "체리 이름을 입력하십시오..."};
Map<String, List<String>> categories = {
  english: ["Health", "Life", "Education.Learning", "IT.Content", "Personal Development"],
  korean: ["건강", "생활", "교육.학습", "IT.컨텐츠", "자기개발"]
};
Map<String, List<String>> menu1 = {
  english: ["Card view", "List view"],
  korean: ["카드 형식", "리스트 형식"]
};
Map<String, List<String>> menu2 = {
  english: ["Date(older)", "Date(latest)", "Views"],
  korean: ["추가된 날짜(최신순)", "추가된 날짜(오래된순)", "조회순"]
};

//api urls
const String baseUrl = "192.168.0.8:7300"; //"cheri.weeknday.com";
const String postsList = "/api/Viewerapi/list";
const String searchPost = "/api/Viewerapi/list";
const String categoryList = "/api/Viewerapi/side_category";
const String detailedDataList = "/api/viewerapi/view";
const String checkUpdate = "/api/viewerapi/check_update";
const String savePost = "/api/viewerapi/bookmark_update";
const String recentSearches = "/api/viewerapi/my_search_log_list";
const String relatedSearches = "/api/viewerapi/relation_search_log_list";
//others
const String placeholdeUrl = "https://www.orcajourney.com/wp-content/uploads/2020/08/placeholder.png";
String profileUrl = "https://cheri.weeknday.com/member/profile?m=";
