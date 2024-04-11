import 'package:flutter/cupertino.dart';

final _dimensionCache = <num, Map<num, double>>{};

extension ScreenDimension on num {
  double vw( BuildContext context ){
    final deviceWidth = MediaQuery.of(context).size.width;

    if(_dimensionCache.containsKey(deviceWidth) && _dimensionCache[deviceWidth]!.containsKey(this)){
      return _dimensionCache[deviceWidth]![this] as double;
    }

    if(!_dimensionCache.containsKey(deviceWidth)){
      _dimensionCache.addAll({deviceWidth : {}});
    }

    final value = deviceWidth * (this / 100);
    _dimensionCache[deviceWidth]!.addAll(({this : value}));

    return  value;
  }

  double vh( BuildContext context) {
    return MediaQuery.of(context).size.height * (this / 100);
  }

  double svh( BuildContext context) {
    return (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom) * (this / 100);
  }
  EdgeInsets getPadding(BuildContext context) => MediaQuery.of(context).padding;
  double pixelScale(BuildContext context) => (this / 4).vw(context);
  double removeSpaceOnKeyboardVisible(BuildContext context) => this + MediaQuery.of(context).viewInsets.bottom;
}