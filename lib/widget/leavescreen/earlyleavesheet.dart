import 'package:hr_dispatcher/model/leave.dart';
import 'package:hr_dispatcher/provider/leaveprovider.dart';
import 'package:hr_dispatcher/utils/navigationservice.dart';
import 'package:hr_dispatcher/widget/buttonborder.dart';
import 'package:hr_dispatcher/widget/customalertdialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EarlyLeaveSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EarlyLeaveSheetState();
}

class EarlyLeaveSheetState extends State<EarlyLeaveSheet> {
  Leave? selectedValue;

  TextEditingController reason = TextEditingController();
  TextEditingController time = TextEditingController();

  bool isLoading = false;

  void issueLeave() async {
    if (time.text.isNotEmpty &&
        reason.text.isNotEmpty &&
        selectedValue != null) {
      showLoader();
      try {
        isLoading = true;
        final response =
            await Provider.of<LeaveProvider>(context, listen: false).issueLeave(
                time.text, time.text, reason.text, selectedValue!.id);

        if (!mounted) {
          return;
        }
        isLoading = false;
        dismissLoader();
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(response.message),
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
        isLoading = false;
        dismissLoader();
      }
    } else {
      NavigationService()
          .showSnackBar("Leave Status", "Field must not be empty");
    }
  }

  void dismissLoader() {
    setState(() {
      EasyLoading.dismiss(animation: true);
    });
  }

  void showLoader() {
    setState(() {
      EasyLoading.show(
          status: "Requesting...", maskType: EasyLoadingMaskType.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Early Leave',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      )),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Leave Type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: provider.leaveList
                          .where((element) => element.status)
                          .where((element) => element.isEarlyLeave)
                          .map((item) => DropdownMenuItem<Leave>(
                                value: item,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        selectedValue = value as Leave?;
                        if (selectedValue != null) {
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 160,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: HexColor("#FFFFFF"),
                      ),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: HexColor("#FFFFFF"),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, 0),
                    ),
                  )),
              gaps(10),
              TextField(
                controller: time,
                style: TextStyle(color: Colors.white),
                //editing controller of this TextField
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Select Time',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white24,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  var current = DateTime.now();
                  current = DateTime.utc(current.year, current.month,
                      current.day, timeOfDay!.hour, timeOfDay.minute);
                  time.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(current);
                },
              ),
              gaps(10),
              TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: reason,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                //editing controller of this TextField
                cursorColor: Colors.white,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Reason',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.edit_note, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white24,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
              ),
              gaps(20),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: HexColor("#036eb7"),
                      padding: EdgeInsets.zero,
                      shape: ButtonBorder(),
                    ),
                    onPressed: () {
                      issueLeave();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Request Leave',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gaps(double value) {
    return SizedBox(
      height: value,
    );
  }
}
