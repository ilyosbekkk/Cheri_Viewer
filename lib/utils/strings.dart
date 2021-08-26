//language strings
String english = "en";
String korean = "ko";

//Card view & Listview
Map<String, String> cheriViews = {english: "Views", korean: "조회수"};
Map<String, List<String>> categories = {english: ["Health", "Life", "Education.Learning", "IT.Content", "Personal Development"], korean: ["건강", "생활", "교육.학습", "IT.컨텐츠", "자기개발"]};
Map<String, String> bookmarkTab = {english: "Bookmarks", korean: "북마크"};
Map<String, String> openedTab = {english: "Opened Cheri", korean: "열어본 체리"};
Map<String, String> homeTitle = {english: "Home", korean: "홈"};
Map<String, String> searchTitle = {english: "Search", korean: "검색"};
Map<String, String> storageTitle = {english: "Collections", korean: "보관함"};
Map<String, String> appName = {english: "Cheri Viewer", korean: "체리뷰버"};
Map<String, String> searchHint = {english: "Please enter cheri name...", korean: "체리 이름을 입력하십시오..."};
Map<String, List<String>> menu1 = {english: ["Card view", "List view"], korean: ["카드 형식", "리스트 형식"]};
Map<String, List<String>> menu2 = {english: ["Date(latest)","Date(older)", "Views"], korean: [ "추가된 날짜(최신순)","추가된 날짜(오래된순)",  "조회순"]};
Map<String, String> toastSignIn =  {english:"Please, Sign in first!", korean: "먼저 로그인 하십시오!"};
Map<String, String> bookmarkSave = {english: "Bookmark has been saved", korean: "북마크에 저장되었습니다."};
Map<String, String> bookMarkUnsave = {english: "Bookmark has been removed", korean: "북마크에서 삭제되었습니다"};

Map<String, String> searchCheri = {english:"Please type the Cheri name", korean:"체리 아름을 입력해주세요"};
Map<String, List<String>> timeUnit = {english: [
  "moment ago", "minute(s) ago", "hour(s) ago", "day(s) ago", "week(s) ago", "month(s) ago", "year(s) ago"],
  korean: ["방금 전", "분 전", "사간 전", "일 전", "주 전", "개 월 전",  "년 전"]};
Map<String, String> voiceResult = {english:"Search  result",  korean: "결과"};
Map<String, String> voiceSearch = {english: "Search", korean: "검색"};
Map<String,  String> voiceTryAgain = {english: "Try again", korean: "다시 시도하세요"};
Map<String, String> voiceMessage = {english: "Speak now 🙂", korean: "말씀하세요 🙂"};
Map<String, String> googleLoginSuccess = {english: "You logged in sucessfully", korean:  "구글 로그인이 성공 되었습니다"};
Map<String,  String> googleLoginSuccessFailure = {english: "Google login failed", korean: "구글 로그인이 실패 되었습니다"};
Map<String, String> kakaoLoginSuccess = {english: "You logged in sucessfully", korean:  "카카오 로그인이 성공 되었습니다"};
Map<String,  String> kakaoLoginSuccessFailure = {english: "Kakao login failed", korean: "카카오 로그인이 실패 되었습니다"};
Map<String, String> emailLoginSuccess = {english: "You logged in sucessfully", korean:  "이매일 로그인이 성공 되었습니다"};
Map<String,  String> emailLoginSuccessFailure = {english: "Email login failed", korean: "이매일 로그인이 실패 되었습니다"};
Map<String, String> naverLoginSuccess = {english: "You logged in sucessfully", korean:  "네이버 로그인이 성공 되었습니다"};
Map<String,  String> naverLoginSuccessFailure = {english: "Naver login failed", korean: "네이버 로그인이 실패 되었습니다"};
Map<String, String> logoutMessage = {english: "You logged out", korean: "로그아웃이 되었습니다"};
Map<String, String> logoutFailure = {english: "You not logout", korean: "로그아웃이 안되었습니다"};
Map<String,  String> deleteAcountMessage = {english: "Your account has been deleted", korean: "탈퇴되었습니다"};
Map<String, String> deleteAccountError = {english: "Unexpected error happened, please try again later", korean: "예기치 않은 오류가 발생했습니다. 나중에 다시 시도하십시오" };
Map<String, String> languageChanged = {english: "Language has been changed", korean: "언어가 변경되었습니다"};
Map<String, String> passwordChanged = {english: "Password changed", korean: "암호가 변경되었습니다"};
Map<String, String> bookMarkNumber = {english: "bookmark", korean: "북마크"};
Map<String, String> shareNumber = {english: "share", korean: "공유"};
Map<String, String> noContent = {english: "no content", korean: "내용이 없습니다"};
Map<String, String> dialogViewIntroduction = {english: "View introduction", korean: "상세 설명"};
Map<String, String> dialogCategoryIntroduction = {english: "Cheri category introduction", korean: "체리 항목 설명"};
Map<String, String> dialogRelatedContent = {english: "Related content", korean: "관련 자료"};
Map<String, String> lazyLoadinNoResult = {english: "No more result", korean:"결과가 없습니다!"};
Map<String, String> timeOutError = {english: "Timeout happened!", korean: "Timeout 발생했습니다"};
Map<String,  String> buttonTryAgain = {english: "Try again", korean: "다시 시도해주세요"};
Map<String, String> internetIssue = {english: "Please, check your internet connectivity", korean:"인터넷 연결을 확인하십시오"};
Map<String,String> reloadButton = {english: "Reload",  korean: "다시 로드하세요"};
Map<String, String> unexpectedError = {english: "Unexpected error happened", korean: "예기치 않은 오류가 발생했습니다" };
Map<String, String> recentSearch = {english: "Recent searches", korean: "최근검색" };
Map<String, String> relatedSearch = {english: "Related searches", korean: "관련된 검색어"};
Map<String, String> noSearchResult = {english: "No search result", korean:"검색 결과가 없습니다"};
Map<String, String> noRecentSearchWords = {english: "No recent search results", korean: "최근 검색 결과가 없습니다" };
Map<String, String> noRelatedSearchResult = {english: "No related search reuslts", korean: "관련된 검색 결과가 없습니다"};
Map<String, String> loginButton = {english: "Log in", korean: "로그인"};
Map<String, String> emptySearchWord = {english: "Search can't be empty", korean:  "검색은 비워 둘 수 없습니다"};
Map<String, String> openedCheri = {english:"Opened Cheri", korean: "열어본 체리"};
Map<String, String> languageChangeError = {english: "Language has not been changed", korean: "언어가 변경되었습니다"};
Map<String, String> turnonthenet = {english: "Please,turn on the internet", korean: "인터넷 좀 켜주세요!"};
Map<String, String> bookMarkScreen = {english:"Bookmark", korean:"북마크"};
Map<String, String> count = {english:"", korean:"건"};
Map<String, String> noResult = {english:"No results for the searched word!", korean:"검색됀 체리가 없습니다!"};
Map<String, String> back = {english:"Go back", korean:"돌아가기"};
Map<String, String> noRecentSearches = {english:"No recent searches!", korean:"최근 검색어가 없습니다!"};
Map<String, String> noSavedPosts = {english:"No saved posts found", korean:"저장된 체리가 없습니다!"};


//api urls
const String baseUrl = "cheri.weeknday.com";
const String postsList = "/api/viewerapi/list";
const String searchPost = "/api/Viewerapi/list";
const String categoryList = "/api/Viewerapi/side_category";
const String detailedDataList = "/api/viewerapi/view";
const String checkUpdate = "/api/viewerapi/check_update";
const String savePost = "/api/viewerapi/bookmark_update";
const String recentSearches = "/api/viewerapi/my_search_log_list";
const String relatedSearches = "/api/viewerapi/relation_search_log_list";
const String bookMarkList = "/api/viewerapi/book_mark_list";
const String openCheriList = "/api//viewerapi/open_cheri_list";
const String  fetchDeviceLatestVersion = "/api/viewerapi/version";

//others
const String placeholdeUrl = "https://www.orcajourney.com/wp-content/uploads/2020/08/placeholder.png";
String profileUrl = "https://cheri.weeknday.com/member/profile?m=";
