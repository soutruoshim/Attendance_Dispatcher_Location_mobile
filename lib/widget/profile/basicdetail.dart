import 'package:hr_dispatcher/provider/profileprovider.dart';
import 'package:hr_dispatcher/widget/buttonborder.dart';
import 'package:hr_dispatcher/widget/cartTitle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final profile  = Provider.of<ProfileProvider>(context).profile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Card(
        shape: ButtonBorder(),
        color: Colors.white10,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle('Phone', profile.phone),
              CardTitle('Post', profile.post),
              CardTitle('Date of birth', profile.dob),
              CardTitle('Gender', profile.gender),
              CardTitle('Address', profile.address),
            ],
          ),
        ),
      ),
    );
  }

}