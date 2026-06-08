enum OpeningStatus {
  open,
  closed,
  unknown,
}

extension OpeningStatusLabel on OpeningStatus {
  String get label => switch (this) {
        OpeningStatus.open => '영업 중',
        OpeningStatus.closed => '영업 종료',
        OpeningStatus.unknown => '확인 필요',
      };
}
