class toDoItem
{
  static String table ='todo';
  int id;
  String name;

  toDoItem(
    {
      this.id,
      this.name
    }
  );

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map = {
      'name': name     
    };
    return map;
  }

  static toDoItem fromMap(Map<String,dynamic> map)
  {
    return toDoItem(
      id: map['id'],
      name: map['name']);
  }
  

}