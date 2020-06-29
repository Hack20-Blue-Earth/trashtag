import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wastepin/add_waste_pin.dart';
import 'package:wastepin/issue_listing_screen.dart';
import 'package:wastepin/map_view/map_view.dart';

import 'data/wastepin.dart';
import 'debug-main.dart';


const Color colorPrimary = Color(0xFF1A2151);
const Color colorAccent = Color(0x118352FD);
const Color colorAccentDark = Color(0xFF8352FD);
const Color colorGrey = Color(0xFF828282);
const Color colorLightGrey = Color(0x22828282);
const Color colorLightTextGrey = Color(0xFFCACACA);
const Color colorDarkGrey = Color(0xFF474747);

class IssueScreen extends StatefulWidget {
  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> with SingleTickerProviderStateMixin {
  TabController _controller;
  final num LISTING_TAB_INDEX = 0;
  final num MAP_TAB_INDEX = 1;
  num currentTabIndex = 0;
  List<WastePin> _wastePinList;
  Position position;

  

  @override
  Future<void> initState() {
    super.initState();

    _controller = new TabController(length: 2, vsync: this);

    loadData();

  }

  loadData() async{
    //get all the nearby data on the basis of location
    wastePinService.fetch().then((value) {

      setState(() {
        _wastePinList = value;
      });
    });
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

              //property name
              title: Text(
                "Issues",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: colorPrimary,
                  ),
              ),
              centerTitle: false,
            ),
            floatingActionButton:currentTabIndex==0? FloatingActionButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => AddWastePinScreen(Location(
                      position.longitude, position.latitude)),
                ),
              );

            },backgroundColor: colorAccentDark,
            child: Icon(Icons.add, color: Colors.white,),
            ):null,
            body: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: new Container(
                      //black border decoration
                      // decoration: BoxDecoration(border: Border.all(width: BORDER_SIZE_01,color: StayyTheme.colorGrey)),
                      child:

                      //tabBar is the tab container
                      Container(
                        decoration:BoxDecoration(color: colorAccent, boxShadow: [
                          BoxShadow(color:  colorAccent, spreadRadius: 1.0, blurRadius: 1.0)
                        ] ,borderRadius: BorderRadius.circular(10.0)),
                        child: TabBar(
                          indicatorWeight: 0.0,
                          controller: _controller,
                          indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 0.0,color:colorAccent), insets: EdgeInsets.all(5.0)),
                          //indicator: Decoration(),
                          onTap: (index) {
                            setState(() {
                              currentTabIndex = index;
                            });
                          },
                          labelPadding: EdgeInsets.only(left: 2.0),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: colorPrimary,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: colorPrimary,
                          ),

                          //tabs
                          tabs: [
                            //linking info tab
                            new Tab(
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints.expand(),
                                  decoration: (currentTabIndex == LISTING_TAB_INDEX)
                                      ? BoxDecoration(color: Colors.white, boxShadow: [
                                    BoxShadow(color:  colorAccent, spreadRadius: 1.0, blurRadius: 1.0)
                                  ] ,borderRadius: BorderRadius.circular(10.0))
                                      : BoxDecoration(
                                      color: Colors.transparent,
                                      ),
                                  child: Text(
                                    "Listing",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: colorPrimary,
                                    ),
                                  ),
                                )),

                            //stay tab
                            Tab(
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints.expand(),
                                  decoration: (currentTabIndex == MAP_TAB_INDEX)
                                      ? BoxDecoration(color: Colors.white, boxShadow: [
                                    BoxShadow(color:  colorAccent, spreadRadius: 1.0, blurRadius: 1.0)
                                  ] ,borderRadius: BorderRadius.circular(10.0))
                                      : BoxDecoration(
                                    color: Colors.transparent,
                                  ),

                                  child: Text(
                                    "Map",
                                    style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: colorPrimary,
                                  ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),

                  //expanded view will contain selected tab view
                  Expanded(
                    child: Container(
                      child: new TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: <Widget>[
                          // pass the property id
                          _wastePinList!=null?IssueListingScreen(_controller, _wastePinList):Center(child:CircularProgressIndicator()),
                          MapScreen(_wastePinList),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}

