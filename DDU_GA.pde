final Item[] ITEMS = {new Item(100, 100), new Item(25, 10), new Item(500, 700), new Item(1000, 700), new Item(225, 45), new Item(31, 48), new Item(83, 101)};
Backpack[] bags;

void setup() {
  bags = initializePopulation(1000);
}

void draw() {
}



Backpack[] initializePopulation (int size) {
  Backpack[] temp = new Backpack[size];
  
  for(int i = 0;i<temp.length ;i++){
    temp[i] = new Backpack();
  }
  
  return temp;
}
