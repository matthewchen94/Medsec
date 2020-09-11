class Resource {
  final String name;
  final String website;

  Resource({
    this.name,
    this.website});

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        name: json['name'],
        website: json['website']);
  }
}