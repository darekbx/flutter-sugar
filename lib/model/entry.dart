class Entry {
  
  int id;
  String name;
  double sugar;
  int timestamp;

  Entry(this.id, this.name, this.sugar, this.timestamp);

  String dateTime() {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${date.month}-${date.day}";
  }

  factory Entry.fromMap(Map<String, dynamic> row) =>
      Entry(row["id"], row["name"], row["sugar"], row["timestamp"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "sugar": sugar,
        "timestamp": timestamp,
      };
}
