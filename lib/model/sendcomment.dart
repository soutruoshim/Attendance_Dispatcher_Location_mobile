import 'package:hr_dispatcher/model/mention.dart';

class SendComment{
  int commentId = 0;
  int replyId = 0;
  String detail = "";
  List<Mention> mentions = [];

  SendComment();
}