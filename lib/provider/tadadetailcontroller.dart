
import 'package:hr_dispatcher/model/attachment.dart';
import 'package:hr_dispatcher/model/tada.dart';
import 'package:hr_dispatcher/repositories/tadarepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class TadaDetailController extends GetxController {
  var tada = Tada(0, "", "", "", "", "", "", "", []).obs;
  var isLoading = false.obs;
  TadaRepository repository = TadaRepository();

  Future<String> getTadaDetail() async {
    try {
      isLoading.value = true;
      EasyLoading.show(
          status: 'Loading, Please Wait...',
          maskType: EasyLoadingMaskType.black);
      final response =
          await repository.getTadaDetail(Get.arguments["tadaId"].toString());
      EasyLoading.dismiss(animation: true);

      final data = response.data;
      final attachmentList = <Attachment>[];
      for (var attachment in data.attachments.image) {
        attachmentList.add(Attachment(attachment.id, attachment.url, "image"));
      }
      for (var attachment in data.attachments.file) {
        attachmentList.add(Attachment(attachment.id, attachment.url, "file"));
      }

      Tada rTada = Tada(
          data.id,
          data.title,
          data.description,
          data.total_expense,
          data.status,
          data.remark,
          data.verified_by,
          data.submitted_date,
          attachmentList);

      tada.value = rTada;

      isLoading.value = false;
      return "Loaded";
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void onInit() {
    getTadaDetail();
    super.onInit();
  }
}
