import 'package:flutter/material.dart';
import 'dart:async';

class ShowNotificationIcon {

  void show(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = new OverlayEntry(builder: _build);

    overlayState.insert(overlayEntry);

    await new Future.delayed(const Duration(seconds: 10));

    overlayEntry.remove();
  }

  Widget _build(BuildContext context){
    return new  Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/mcdonalds.jpg'),
        fit: BoxFit.cover,
    )
        )
        );
  }
}