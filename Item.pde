class Item {
  float weight;
  float value;
  String name;

  Item(float _w, float _v) {
    this.weight = _w;
    this.value = _v;
    this.name = "Book";
  }

  Item(String instruction) {
    // the expected format is Weight Value name
    // one item per instruction

    int firstSpace = instruction.indexOf(' ');
    int secondSpace = instruction.indexOf(' ',firstSpace+1 );
    
    String wei = instruction.substring(0,firstSpace);
    String val = instruction.substring(firstSpace+1,secondSpace);
    
    this.weight = Float.parseFloat(wei);
    this.value = Float.parseFloat(val);
    this.name =instruction.substring(secondSpace+1);
  }
}
