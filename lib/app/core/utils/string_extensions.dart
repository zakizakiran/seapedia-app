import 'package:html_unescape/html_unescape.dart';

extension StringHtmlExtension on String {
  static final HtmlUnescape _unescape = HtmlUnescape();

  String get unescapeHtml {
    if (isEmpty) return this;
    return _unescape.convert(this);
  }
}
