class ArticleResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ArticleResponse(this.status, this.totalResults, this.articles);
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

  Article(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);
}

class Source {
  final String id;
  final String name;

  Source(this.id, this.name);
}
