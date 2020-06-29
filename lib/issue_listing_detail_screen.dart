

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/map_view/map_view.dart';

import 'data/wastepin.dart';
import 'issue_screen.dart';

class IssueListingDetailScreen extends StatelessWidget {
  final WastePin _wastePin;

  IssueListingDetailScreen( this._wastePin);

  @override
  Widget build(BuildContext context) {
    return
// used to help the ui when we are having the notch
      SafeArea(
// used to show app bar
        child: Scaffold(
        appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
//calender vie
        leading: IconButton(icon:Icon(Icons.arrow_back_ios), color: colorAccentDark,
        onPressed: () =>  Navigator.of(context).pop(),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:16.0,horizontal: 10.0),
            child: InkWell(
//              child: Text(
//                "Map",
//                style: TextStyle(
//                  fontSize: 18.0,
//                  color: colorAccentDark,
//                ),
//              ),
            child:Icon(
              Icons.map, color: colorAccentDark,
            ),
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MapView(showSinglePin: true, wastePin: _wastePin,),
                  ),
                );

              },
            ),
          ),
        ],
        //property name
        title: Text(
          "Details",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
            color: colorPrimary,
          ),
        ),
        centerTitle: true,
      ),
//    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//    floatingActionButton: FloatingActionButton(onPressed: (){
//
//    }, backgroundColor: colorAccentDark, child: Icon(Icons.map,color:Colors.white),
//    elevation: 0.0,),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            color:Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/2.7,
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                          ),
                        ),
                    imageUrl:
                    'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
                  ),
                ),

                SizedBox(height: 20.0,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: colorDarkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.3,
                        child: TextFormField(
                          initialValue: "${_wastePin.location.latitude}",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: colorPrimary,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(borderSide: BorderSide(color:colorLightTextGrey)),
                            suffix: Text(
                              "Lat",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: colorLightTextGrey,
                              ),
                            ),
                            enabled: false,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.3,
                        child: TextFormField(
                          initialValue: "${_wastePin.location.longitude}",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: colorPrimary,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(borderSide: BorderSide(color:colorLightTextGrey)),
                            suffix: Text(
                              "Long",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: colorLightTextGrey,
                              ),
                            ),
                          ),
                          enabled: false,
                        ),
                      ),

                    ],
                  )
                ),

                SizedBox(height: 20.0,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: colorDarkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextFormField(
                        initialValue: "${_wastePin.photoTime}",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: colorPrimary,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(borderSide: BorderSide(color:colorLightTextGrey)),
                          enabled: false,
                        ),
                      ),
                    )
                )

              ],
          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:19.0,right: 10.0, left:10.0),
          child: RaisedButton(
            elevation: 0.0,
            color: colorAccentDark,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
                side: BorderSide(color: colorAccentDark)),

            onPressed: () {

            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 12.0),
              child: Text(
                "Took the waste!",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

      ],
    )));

  }
}
