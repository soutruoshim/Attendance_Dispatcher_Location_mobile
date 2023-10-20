import 'package:hr_dispatcher/provider/noticeprovider.dart';
import 'package:hr_dispatcher/widget/notification/notificationcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoticeListState();
}

class NoticeListState extends State<NoticeList> {
  late ScrollController _controller;
  var isLoading = false;

  void _loadMore() async{
    if(!isLoading) {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        isLoading = true;
        await Provider.of<NoticeProvider>(context, listen: false)
            .getNotice();
        isLoading = false;
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<NoticeProvider>(context).notificationList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
          primary: false,
          controller: _controller,
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            return NotificationCard(
                id: items[index].id,
                name: items[index].title,
                month: items[index].month,
                day: items[index].day.toString(),
                desc: items[index].description);
          }),
    );
  }
}
