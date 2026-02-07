class Book {
  final int? id;
  final String title;
  final String author;

  Book({this.id, required this.title, required this.author});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
    };
  }
}