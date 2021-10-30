import 'package:page_transition/page_transition.dart';
import 'package:enum_to_string/enum_to_string.dart';
import '../base_model.dart';

class PageArguments implements BaseModel {
  PageTransitionType? transitionType;
  dynamic data;

  PageArguments({
    this.transitionType,
    this.data,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'Transition': _getTransitionType(),
      'Data': _getData(),
    };
  }

  String? _getTransitionType() {
    if (transitionType == null) {
      return null;
    }
    return EnumToString.convertToString(transitionType);
  }

  dynamic _getData() {
    if (data != null && data is BaseModel) {
      return (data as BaseModel).toJson().toString();
    }
    return data;
  }
}
