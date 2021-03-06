import 'dart:async';

import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_moel.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsDbProvider(),
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    NewsDbProvider()
  ]
  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for(var cache in caches) {
      cache.addItem(item);
    }
    return item;
  }
}


abstract class Source {
  Future<List<int>> fetchTopIds();

  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}