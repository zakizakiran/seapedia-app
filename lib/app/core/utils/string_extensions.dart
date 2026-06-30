extension StringHtmlExtension on String {
  String get unescapeHtml {
    return replaceAll('&#x27;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}
