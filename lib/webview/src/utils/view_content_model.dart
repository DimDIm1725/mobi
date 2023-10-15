import 'package:mobiwoom/webview/src/utils/source_type.dart';

/// This is used as a container object, to pass the data inside from the controller
/// to the view.
///
/// On Web, [headers] only work if [sourceType] is [SourceType.URL_BYPASS].
class ViewContentModel {
  final String content;
  final SourceType sourceType;
  final Map<String, String> headers;

  ViewContentModel({
    this.content,
    this.sourceType,
    this.headers = const {},
  });
}
