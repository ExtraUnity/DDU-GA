import java.util.Collections;
Item[] ITEMS ;//= {new Item(100, 100), new Item(25, 10), new Item(500, 700), new Item(1000, 700), new Item(225, 45), new Item(31, 48), new Item(83, 101)};
Backpack[] bags;
int size = 4137;
float average = 0;
int times = 0;
float globalMutationRate = 0.01;
ArrayList<Integer> generations = new ArrayList<Integer>();
ArrayList<Integer> bestFitnesses = new ArrayList<Integer>();
void setup() {
  fullScreen();
  ITEMS = itemImport("input.txt");
  bags = initializePopulation(size);
  frameRate(10);
  generations.add(frameCount);
  bestFitnesses.add((int) bestFitness());
}

void draw() {
  long time = System.currentTimeMillis();

  //print(frameCount + " ");
  //println(bestFitness());
  bags = makeNewPopulation();

  //   println((time2-time));
  background(100);
  addToList();
  renderGraph();
  long time2 = System.currentTimeMillis();
  
  //if (bestFitness() == 1130) {
  //  if (times == 0) {
  //    average = frameCount;
  //    times++;
  //  } else {
  //    float averageTotal = average*times;
  //    averageTotal+=frameCount;
  //    average = averageTotal/++times;
  //    if (times == 30) {
  //      print(average + " ");
  //      print(size + " ");
  //      println(globalMutationRate);
  //    }
  //  }

  //  bags = initializePopulation(size);
  //  frameCount = 0;
  //}
  //if (frameCount>100) {
  //  frameCount = 0;
  //  bags = initializePopulation(size);
  //}
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

      b[j] = selectBackpack(totalFitness, b[0]);
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

Backpack selectBackpack(float totalFitness, Backpack b1) {

  double outOf = 0;
  double selection = random(1);

  if (b1 != null) {
    totalFitness -= b1.getFitness();
  }

  for (int i = 0; i<bags.length; i++) {
    if (bags[i] != b1) {
      outOf += bags[i].getFitness()/(totalFitness);

      if (selection-outOf<0.000001) { //floating point error makes this nessecary

        return bags[i];
      }
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

void addToList() {
  if (bestFitnesses.size()>20) {
    if (!bestFitnesses.get(bestFitnesses.size()-1).equals(Collections.max(bestFitnesses)) || !bestFitnesses.get(bestFitnesses.size()-21).equals(Collections.max(bestFitnesses))) {
      generations.add(frameCount);
      bestFitnesses.add((int) bestFitness());
    } else {
      noLoop();
    }
  } else {
    generations.add(frameCount);
    bestFitnesses.add((int) bestFitness());
  }
}

void renderGraph() {
  for (int i = 0; i<generations.size()-1; i++) {
    int x1 = round(map(generations.get(i), 0, frameCount, 0, width*0.8));
    int x2 = round(map(generations.get(i+1), 0, frameCount, 0, width*0.8));
    int y1 = round(map(bestFitnesses.get(i), bestFitnesses.get(0)-100, Collections.max(bestFitnesses)+height*0.1, height, 0));
    int y2 = round(map(bestFitnesses.get(i+1), bestFitnesses.get(0)-100, Collections.max(bestFitnesses)+height*0.1, height, 0));
    line(x1, y1, x2, y2);
  }
  line(width*0.8, height, width*0.8, 0);
  textSize(24);
  text("Generation: " + frameCount, width*0.81, height*0.1);
  text("Best Fitness: " + Collections.max(bestFitnesses), width*0.81, height*0.13);
  text("Current Fitness: " + bestFitnesses.get(bestFitnesses.size()-1), width*0.81, height*0.16);
  text("Weight of Bag: " + bestBackpack().getWeight() + "g", width*0.81, height*0.19);
  text("Population: " + size, width*0.81, height*0.22);
  text("Mutation Rate: " + globalMutationRate, width*0.81, height*0.25);
  text("Best backpack: ", width*0.81, height*0.31);
  textSize(16);
  text(bestBackpack().toString(), width*0.81, height*0.34);
}
