import 'package:hr_dispatcher/provider/prefprovider.dart';
import 'package:hr_dispatcher/screen/profile/NotificationScreen.dart';
import 'package:hr_dispatcher/screen/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HeaderProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaderState();
}

class HeaderState extends State<HeaderProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrefProvider>(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            screen: ProfileScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                provider.avatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/dummy_avatar.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Welcome',
                  //   style: TextStyle(color: Colors.white, fontSize: 12),
                  // ),
                  Text(
                    "Welcome ${provider.fullname}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // Text(
                  //   provider.userName,
                  //   style: TextStyle(color: Colors.white, fontSize: 12),
                  // ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: NotificationScreen(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.fade);
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                )
            ),
          ],
        ),
      ),
    );
  }
}
