import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wastepin/photo/photo_screen.dart';

import 'data/wastepin.dart';

class AddWastePinScreen extends StatelessWidget {

  Location _location;
  AddWastePinScreen(this._location);

  TextEditingController _textEditingController=new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // TODO add pin operations and state widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waste pin - add")),
      body: GestureDetector(
        onTap: () =>  FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          children: [
            Text("Add new Waste Pin"),
            AspectRatio(
                aspectRatio: 1.6666,
                child: WastePhoto(
                  downloadAvailable: false,
                  wastePin: null,
                )),
            SizedBox(height: 10.0,),
            Text("Notes",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),),
            SizedBox(height: 10.0,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                maxLines: 5,
                validator: (value){
                  print("Validator called");
                  if(value==null || (value!=null && value.isEmpty)){
                    return "Field should not be empty!";
                  }
                },
                decoration: new InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),

                ),
//                focusedBorder: InputBorder.none,
//                enabledBorder: InputBorder.none,
//                errorBorder: InputBorder.none,
//                disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter your Notes here..."),

              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            elevation: 0.0,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
                side: BorderSide(color: Colors.blue)),

            onPressed: () {
                  if(_formKey.currentState.validate()){

                    WastePin pin=WastePin();
                    pin.location=_location;
                    pin.id=Uuid().v1(options: _location?.toMap());
                    pin.note=_textEditingController.text.trim();
                    pin.remoteUrl="https://www.conserve-energy-future.com/wp-content/uploads/2017/09/litter-trash-garbage-overflow.jpg";
                    WastePinService().addWastePin(pin);
                  }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 12.0),
              child: Text(
                "SUBMIT",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
