enum PubRegion {
  hongdae,
  itaewon,
}

extension PubRegionLabel on PubRegion {
  String get label => switch (this) {
        PubRegion.hongdae => '홍대',
        PubRegion.itaewon => '이태원',
      };
}
