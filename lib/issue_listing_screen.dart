import 'package:flutter/material.dart';

import 'data/wastepin.dart';
import 'issue_listing_detail_screen.dart';
import 'issue_screen.dart';

class IssueListingScreen extends StatelessWidget {
  final TabController _controller;
  final List<WastePin> _wastePin;

  IssueListingScreen(this._controller, this._wastePin);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _wastePin.length,
        itemBuilder: (BuildContext context, int index) {

          return Column(
            children: [
              ListTile(title: Text("Lat:${_wastePin.elementAt(index).location.latitude}, Long:${_wastePin.elementAt(index).location.latitude}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: colorPrimary,
              ),),
              subtitle: Text("${_wastePin.elementAt(index).photoTime}",
                  style: TextStyle(
                  fontSize: 10.0,
                  color: colorGrey,
              ),),
              trailing: Icon(Icons.arrow_forward_ios,color: colorGrey,size: 18.0,),
              onTap: (){
                print("item is clicked");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => IssueListingDetailScreen(_wastePin[index]),
                  ),
                );
              },),
              Container(color: colorLightGrey, height:1.0, margin: EdgeInsets.symmetric(horizontal: 10.0),)
            ],
          );

          });

  }
}
