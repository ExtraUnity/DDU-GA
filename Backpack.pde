class Backpack {
  ArrayList<Item> items;
  float fitness;
  float mutationRate;
  
  Backpack() {
    for(int i = 0; i<(int) random(1,100); i++) {
      items.add(ITEMS[(int) random(0,ITEMS.length)]);
    }
  }
  
  void mutate() {
    
  }
  
  float fitness() {
    
    
    return 0;
  }
  
}
