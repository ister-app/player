class LanguageData {
  final String id;
  final String part2b;
  final String part2t;
  final String part1;
  final String scope;
  final String languageType;
  final String refName;
  final String comment;

  LanguageData({
    required this.id,
    required this.part2b,
    required this.part2t,
    required this.part1,
    required this.scope,
    required this.languageType,
    required this.refName,
    required this.comment,
  });

  factory LanguageData.fromCsv(List<String> fields) {
    return LanguageData(
      id: fields[0],
      part2b: fields[1],
      part2t: fields[2],
      part1: fields[3],
      scope: fields[4],
      languageType: fields[5],
      refName: fields[6],
      comment: fields.length > 7 ? fields[7] : '',
    );
  }

  List<String> toCodeList() {
    return [id, part2b, part2t, part1];
  }

  @override
  String toString() {
    return 'LanguageData{id: $id, part2b: $part2b, part2t: $part2t, part1: $part1, scope: $scope, languageType: $languageType, refName: $refName, comment: $comment}';
  }
}
