import '../models/pub_model.dart';
import '../../domain/entities/opening_status.dart';
import '../../domain/entities/pub_region.dart';

abstract interface class PubLocalDataSource {
  Future<List<PubModel>> getPubs();
  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);
}

class SamplePubLocalDataSource implements PubLocalDataSource {
  final Set<String> _favoriteIds = {};

  @override
  Future<List<PubModel>> getPubs() async => _samplePubs;

  @override
  Future<Set<String>> getFavoriteIds() async => Set.of(_favoriteIds);

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {
    _favoriteIds
      ..clear()
      ..addAll(ids);
  }
}

const _samplePubs = [
  PubModel(
    id: 'hongdae-001',
    name: 'Club FF',
    region: PubRegion.hongdae,
    latitude: 37.550275,
    longitude: 126.922303,
    address: '서울 마포구 서교동 407-8',
    tags: ['live-music', 'indie-rock', 'club', 'hongdae'],
    rating: 4.5,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'hongdae-002',
    name: 'Rolling Hall',
    region: PubRegion.hongdae,
    latitude: 37.5497,
    longitude: 126.9219,
    address: '서울 마포구 어울마당로 35',
    tags: ['concert-hall', 'live-music', 'indie', 'hongdae'],
    rating: 4.6,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'hongdae-003',
    name: 'KT&G Sangsangmadang Live Hall',
    region: PubRegion.hongdae,
    latitude: 37.5509,
    longitude: 126.921,
    address: '서울 마포구 어울마당로 65',
    tags: ['live-hall', 'culture-space', 'concert', 'hongdae'],
    rating: 4.5,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'hongdae-004',
    name: 'Jebi Dabang',
    region: PubRegion.hongdae,
    latitude: 37.5479,
    longitude: 126.9228,
    address: '서울 마포구 와우산로 24',
    tags: ['live-bar', 'cafe', 'indie-folk', 'sangsu'],
    rating: 4.5,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'hongdae-005',
    name: 'Strange Fruit',
    region: PubRegion.hongdae,
    latitude: 37.556177,
    longitude: 126.926671,
    address: '서울 마포구 서교동 330-15',
    tags: ['live-music', 'indie', 'small-venue', 'hongdae'],
    rating: 4.5,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'hongdae-006',
    name: 'Cafe Unplugged',
    region: PubRegion.hongdae,
    latitude: 37.5562,
    longitude: 126.929,
    address: '서울 마포구 와우산로33길 26',
    tags: ['live-cafe', 'acoustic', 'open-mic', 'hongdae'],
    rating: 4.4,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-001',
    name: 'All That Jazz',
    region: PubRegion.itaewon,
    latitude: 37.5349,
    longitude: 126.9972,
    address: '서울 용산구 이태원로 216, 2층',
    tags: ['jazz', 'live-bar', 'itaewon', 'historic'],
    rating: 4.6,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-002',
    name: 'Boogie Woogie',
    region: PubRegion.itaewon,
    latitude: 37.535,
    longitude: 126.9941,
    address: '서울 용산구 이태원동 281-6',
    tags: ['live-music', 'jazz', 'soul', 'funk'],
    rating: 4.4,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-003',
    name: 'The Studio HBC',
    region: PubRegion.itaewon,
    latitude: 37.5412,
    longitude: 126.9875,
    address: '서울 용산구 용산동2가 39-16 B1',
    tags: ['live-music', 'rock', 'performance', 'haebangchon'],
    rating: 4.4,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-004',
    name: 'Southside Parlor',
    region: PubRegion.itaewon,
    latitude: 37.5328,
    longitude: 126.9947,
    address: '서울 용산구 보광로60길 36-5',
    tags: ['cocktail-bar', 'live-music', 'itaewon', 'rooftop'],
    rating: 4.5,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-005',
    name: 'Planet Hustle',
    region: PubRegion.itaewon,
    latitude: 37.5332,
    longitude: 126.9915,
    address: '서울 용산구 이태원동 34-65, 1층',
    tags: ['bar', 'hip-hop', 'karaoke', 'live-music'],
    rating: 4.4,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
  PubModel(
    id: 'itaewon-006',
    name: 'Pet Sounds',
    region: PubRegion.itaewon,
    latitude: 37.539192,
    longitude: 126.989004,
    address: '서울 용산구 이태원동 278-8, 3층',
    tags: ['rock-bar', 'live-music', 'requests', 'kyunglidan'],
    rating: 4.6,
    reviewCount: 0,
    openingStatus: OpeningStatus.unknown,
  ),
];
