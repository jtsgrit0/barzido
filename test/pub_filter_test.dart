import 'package:clzido/core/constants/regions.dart';
import 'package:clzido/features/pub_map/data/datasources/pub_local_data_source.dart';
import 'package:clzido/features/pub_map/data/repositories/pub_repository_impl.dart';
import 'package:clzido/features/pub_map/domain/entities/pub_filter.dart';
import 'package:clzido/features/pub_map/domain/entities/pub_region.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('홍대 bounds 안의 펍만 조회한다', () async {
    final repository = PubRepositoryImpl(
      localDataSource: SamplePubLocalDataSource(),
    );

    final pubs = await repository.getPubsInBounds(
      bounds: hongdaePreset.bounds,
      filter: const PubFilter(region: PubRegion.hongdae),
    );

    expect(pubs, hasLength(3));
    expect(pubs.every((pub) => pub.region == PubRegion.hongdae), isTrue);
  });
}
