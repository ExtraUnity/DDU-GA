Item[] ITEMS ;//= {new Item(100, 100), new Item(25, 10), new Item(500, 700), new Item(1000, 700), new Item(225, 45), new Item(31, 48), new Item(83, 101)};
Backpack[] bags;
int size = 4137;
float average = 0;
int times = 0;
float globalMutationRate = 0.01;
void setup() {
  ITEMS = itemImport("input.txt");
  bags = initializePopulation(size);
  frameRate(100);
}

void draw() {
  // print(frameCount + " ");
  // println(bestFitness());

  if (bestFitness() == 1130) {
    if (times == 0) {
      average = frameCount;
      times++;
    } else {
      float averageTotal = average*times;
      averageTotal+=frameCount;
      average = averageTotal/++times;
      if (times == 30) {
        print(average + " ");
        print(size + " ");
        println(globalMutationRate);
      }
    }

    bags = initializePopulation(size);
    frameCount = 0;
  }
  if (frameCount>100) {
    frameCount = 0;
    bags = initializePopulation(size);
  }

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
  int pivot = (int) random(0, ITEMS.length);
  for (int i = 0; i<pivot; i++) {
    tempBack.items[i] = b1.items[i];
    tempBack.mutate(i);
  }
  for (int i = pivot; i<ITEMS.length; i++) {
    tempBack.items[i] = b2.items[i];
  }
  return tempBack;
}

Backpack selectBackpack(float totalFitness) {

  double outOf = 0;
  double selection = random(1);
  for (int i = 0; i<bags.length; i++) {
    outOf += bags[i].getFitness()/totalFitness;

    if (selection-outOf<0.000001) { //floating point error makes this nessecary
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

Item[] itemImport(String path) {
  // Weight Value Name
  // Weight SPACE Value SPACE Name

  String[] input = loadStrings(path);
  Item[] temp = new Item[input.length];

  for (int i = 0; i<temp.length; i++) {
    temp[i] = new Item(input[i]);
  }
  return temp;
}

float bestFitness() {
  float max = 0;
  for (int i = 0; i<bags.length; i++) {
    if (bags[i].getFitness()>max) {
      max = bags[i].getFitness();
    }
  }
  return max;
}

void keyPressed() {
  average = 0;
  times = 0;
  bags = initializePopulation(size);
  if (key=='w' && globalMutationRate != 0.99) {
    changeMutation(0.001);
  } else if (key=='s' && globalMutationRate != 0) {
    changeMutation(-0.01);
  } else if (key == 'i') {
    changePopulation(500);
  } else if (key == 'k') {
    changePopulation(-500);
  }
}

void changeMutation(float amount) {
  globalMutationRate += amount;
}

void changePopulation(int amount) {
  size += amount;
}


Backpack bestBackpack() {
  float max = 0;
  int maxIndex = 0;
  for (int i = 0; i<bags.length; i++) {
    if (bags[i].getFitness()>max) {
      max = bags[i].getFitness();
      maxIndex = i;
    }
  }
  return bags[maxIndex];
}
