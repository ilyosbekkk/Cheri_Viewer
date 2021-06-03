import 'package:flutter/material.dart';
import 'package:viewerapp/ui/screens/auth_screen.dart';

import '../../utils/Strings.dart';

class UserProfile extends StatelessWidget {
  const UserProfile();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color.fromRGBO(173, 216, 230, 1)),
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  app_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 10, top: 10),
                      child: Image.network(
                          "https://www.kindpng.com/picc/m/24-248325_profile-picture-circle-png-transparent-png.png")))
            ],
          ),
        ],
      ),
    );
  }
}
