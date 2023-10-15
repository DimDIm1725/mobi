import 'dart:collection';

String parseCDATA(dynamic data) {
  if (data is LinkedHashMap) {
    return data = data["#cdata-section"].replaceAll(r"\'", "'");
  } else {
    if (data != null) {
      data = data.replaceAll(r"\'", "'");
    }
    return data;
  }
}
