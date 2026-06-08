import 'package:flutter/material.dart';

class PubDetailPage extends StatelessWidget {
  const PubDetailPage({required this.pubId, super.key});

  final String pubId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('펍 상세')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            pubId,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text('상세 API 연결 후 영업시간, 메뉴, 리뷰, 사진 영역을 채우면 됩니다.'),
        ],
      ),
    );
  }
}
