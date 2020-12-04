final Item[] ITEMS = {new Item(100, 100), new Item(25, 10), new Item(500, 700), new Item(1000, 700), new Item(225, 45), new Item(31, 48), new Item(83, 101)};
Backpack[] bags;

void setup() {
  bags = initializePopulation(8);
  frameRate(1);
}

void draw() {
  println(bestFitness());
  bags = makeNewPopulation();
}



Backpack[] initializePopulation (int size) {
  Backpack[] temp = new Backpack[size];

  for (int i = 0; i<temp.length; i++) {
    temp[i] = new Backpack();
  }

  return temp;
}

Backpack[] makeNewPopulation () {
  float totalFitness = totalFitness();

  Backpack[] temp = new Backpack[bags.length];
  for (int i = 0; i<temp.length; i++) {
    Backpack[] b = new Backpack[2];
    for (int j = 0; j<b.length; j++) {
      b[j] = selectBackpack(totalFitness);
    }
    while (b[0] == b[1]) {
      b[1] = selectBackpack(totalFitness);
    }
    temp[i] = mergeBackpacks(b[0], b[1]);
  }

  return temp;
}

Backpack mergeBackpacks(Backpack b1, Backpack b2) {
  Backpack tempBack = new Backpack();
  for (int i = 0; i<ITEMS.length; i++) {
    if (b1.items[i] != null && b2.items[i] != null) { //If both have the item, the new one will also have it
      if (!tempBack.willMutate()) { //chance to mutate
        tempBack.items[i] = ITEMS[i];
      }
    } else if (b1.items[i] != null || b1.items[i] != null) { //If one of the backpacks has the item
      if (random(1)<0.5) { //then its 50/50
        tempBack.items[i] = ITEMS[i];
      }
    } else if (tempBack.willMutate()) { //No one has it - there is a chance to mutate
      tempBack.items[i] = ITEMS[i];
    } else {
      tempBack.items[i] = null;
    }
  }
  return tempBack;
}

Backpack selectBackpack(float totalFitness) {

  float outOf = 0;
  float selection = random(1);
  for (int i = 0; i<bags.length; i++) {
    outOf += bags[i].getFitness()/totalFitness;
    
    if (selection<outOf) {
      return bags[i];
    }
  }
  return null;
}

float totalFitness() {
  float temp = 0;
  for (Backpack backpack : bags) {
    temp += backpack.getFitness();
  }
  return temp;
}

float bestFitness() {
  float max = 0;
  for(int i = 0; i<bags.length; i++) {
    if(bags[i].getFitness()>max) {
      max = bags[i].getFitness();
    }
  }
  return max;
}
