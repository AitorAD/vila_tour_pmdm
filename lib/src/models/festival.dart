class Festival {
  String imageUrl;
  String title;
  String location;
  String date;
  double rating;
  bool favourite;
  String description;

  Festival({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
    required this.favourite,
    required this.description,
  });

  factory Festival.fromMap(Map<String, dynamic> map) {
    return Festival(
      imageUrl: map['imageUrl'],
      title: map['title'],
      location: map['location'],
      date: map['date'],
      rating: map['rating'],
      favourite: map['favourite'],
      description: map['description'],
    );
  }
}
