import 'package:hr_dispatcher/utils/constant.dart';
import 'package:hr_dispatcher/widget/log_out_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:hr_dispatcher/widget/morescreen/createissuesheet.dart';

class Services extends StatelessWidget {
  final String name;
  final IconData icon;
  final Widget route;

  Services(this.name, this.icon, this.route);

  @override
  Widget build(BuildContext context, [bool mounted = true]) {


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          ListTile(
            dense: true,
            minLeadingWidth: 5,
            leading: Icon(
              icon,
              color: Colors.white,
            ),
            title: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onTap: () {
              if (name == 'Privacy Policy') {
                openBrowserTab();
              } else if (name == 'Log Out') {
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) {
                      return LogOutBottomSheet();
                    });
              } else if(name == 'Issue Ticket'){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    builder: (context) {
                      return CreateIssueSheet();
                    });
              }else {
                pushNewScreen(context,
                    screen: route,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade);
              }
            },
            selected: true,
          ),
          const Divider(
            height: 1,
            color: Colors.white24,
            indent: 15,
            endIndent: 15,
          ),
        ],
      ),
    );
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: Constant.PRIVACY_POLICY_URL,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.black,
        preferredControlTintColor: Colors.grey,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
