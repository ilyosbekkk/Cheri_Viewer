

String initial_data = """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
      <button   style="margin-left: 25%;margin-top: 80%; width:200px" onclick="googleSignIn()">GOOGLE</button></br>
      <button   style="margin-left: 25%; margin-top:5%; width:200px" onclick="kakaoSignIn()">KAKAO</button></br>
      <button   style="margin-left: 25%; margin-top:5%; width:200px" onclick="naverSignIn()">NAVER</button></br>
        <script>
        function googleSignIn() {
           window.flutter_inappwebview.callHandler("google").then(function(result) {
                 console.log(JSON.stringify(result));
                 window.flutter_inappwebview.callHandler("google_user_info", result);
                 });
         }        
        function kakaoSignIn(){
         window.flutter_inappwebview.callHandler("kakao").then(function(result) {
                 console.log(JSON.stringify(result));
                 window.flutter_inappwebview.callHandler("kakao_user_info", result);
                 });
        }
        
      function naverSignIn(){
         window.flutter_inappwebview.callHandler("naver").then(function(result) {
                 console.log(JSON.stringify(result));
                 window.flutter_inappwebview.callHandler("naver_user_info", result);
                 });
        }
        
      </script>
    </body>
</html>
                  """;