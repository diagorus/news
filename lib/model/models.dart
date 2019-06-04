import 'package:news/model/presentation_models.dart';

class ArticlesResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ArticlesResponse(this.status, this.totalResults, this.articles);

  ArticlesResponse.fromMap(Map<String, dynamic> map)
      : status = map['status'],
        totalResults = map['totalResults'],
        articles = (map['articles'] as List)
            .map((rawArticle) => Article.fromMap(rawArticle))
            .toList();

  LoadedData<Article> mapToLoadedData() {
    return LoadedData<Article>(articles, totalResults);
  }
}

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  const Article(this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content,);

  Article.fromMap(Map<String, dynamic> map)
      : source = Source.fromMap(map['source']),
        author = map['author'],
        title = map['title'],
        description = map['description'],
        url = map['url'],
        urlToImage = map['urlToImage'],
        publishedAt = map['publishedAt'],
        content = map['content'];
}

class Source {
  final String id;
  final String name;

  const Source(this.id,
      this.name,);

  Source.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}

class SearchHistory {
  final int timestamp;
  final String query;

  const SearchHistory(this.timestamp,
      this.query,);

  SearchHistory.fromMap(Map<String, dynamic> map)
      : timestamp = map['timestamp'],
        query = map['query'];
}
