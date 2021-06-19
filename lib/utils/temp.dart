import 'package:viewerapp/models/postslist_model.dart';

List<Post> posts = [
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://ii1.pepperfry.com/media/catalog/product/l/i/568x625/little-love--baby--and-power-miniature-garden-toys-little-love--baby--and-power-miniature-garden-toy-3ade1n.jpg", "Dummy",  true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://media3.s-nbcnews.com/j/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p_67dfb6820f7d3898b5486975903c2e51.fit-1240w.jpg", "Dummy",  false),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://media3.s-nbcnews.com/j/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p_67dfb6820f7d3898b5486975903c2e51.fit-1240w.jpg", "Dummy",  false),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://ii1.pepperfry.com/media/catalog/product/l/i/568x625/little-love--baby--and-power-miniature-garden-toys-little-love--baby--and-power-miniature-garden-toy-3ade1n.jpg", "Dummy",  true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://media3.s-nbcnews.com/j/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p_67dfb6820f7d3898b5486975903c2e51.fit-1240w.jpg", "Dummy", false),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://www.incimages.com/uploaded_files/image/1920x1080/getty_655998316_2000149920009280219_363765.jpg", "Dummy", true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://www.incimages.com/uploaded_files/image/1920x1080/getty_655998316_2000149920009280219_363765.jpg", "Dummy", true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://www.incimages.com/uploaded_files/image/1920x1080/getty_655998316_2000149920009280219_363765.jpg", "Dummy", true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc5NjIyODM0ODM2ODc0Mzc3/dwayne-the-rock-johnson-gettyimages-1061959920.jpg", "Dummy", true),
  Post.create("Dummy", "Ilyosbek", 5, 200, "https://equusmagazine.com/.image/t_share/MTc4NjI5NjMwMDkyMTI1OTg0/horse-galloping-on-sand.jpg", "Dummy", true),
];


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