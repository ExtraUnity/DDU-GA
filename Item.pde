class Item {
  float weight;
  float value;
  String name;

  //Item(float _w, float _v) {
  //  this.weight = _w;
  //  this.value = _v;
  //  this.name = "Book";
  //}

  Item(String instruction) {
    // the expected format is Name Weight Value 
    // one item per instruction

    String[] split = instruction.split(" ");

    this.name = "";
    for (int i= 0; i<split.length -2; i++) {
      this.name += split[i] + " ";
    }

    this.weight = Float.parseFloat(split[split.length-2]);
    this.value = Float.parseFloat(split[split.length-1]);
  }
}
