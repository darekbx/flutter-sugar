class Entry {
  
  int id;
  String name;
  double sugar;
  int timestamp;

  Entry(this.id, this.name, this.sugar, this.timestamp);

  String dateTime() {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var month = date.month.toString().padLeft(2, '0');
    var day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
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
