class Entry {

  int id;
  String name;
  double sugar;
  int date;

  Entry(this.id, this.name, this.sugar, this.date);

  factory Entry.fromMap(Map<String, dynamic> row) => Entry(
      row["id"],
      row["name"],
      row["sugar"],
      row["date"]
  );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "sugar": sugar,
        "date": date,
      };
}
