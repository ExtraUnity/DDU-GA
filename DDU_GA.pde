import java.util.Collections;
Item[] ITEMS ;
Backpack[] bags;
int size;
float average = 0;
int times = 0;
float globalMutationRate;
ArrayList<Integer> generations = new ArrayList<Integer>();
ArrayList<Integer> bestFitnesses = new ArrayList<Integer>();
ArrayList<Integer> worstFitnesses = new ArrayList<Integer>();
int maxWeight;
long time = System.nanoTime();

void setup() {
  loadConfig();
  fullScreen();
  ITEMS = itemImport("input.txt");
  bags = initializePopulation(size);
  frameRate(5);
  generations.add(frameCount);
  bestFitnesses.add((int) bestFitness());
  worstFitnesses.add((int) worstFitness());
}

void draw() {


  //print(frameCount + " ");
  //println(bestFitness());
  bags = makeNewPopulation();


  background(100);
  addToList();
  renderGraph();
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

  String[] input = loadStrings(path);
  Item[] temp = new Item[input.length];

  for (int i = 1; i<temp.length; i++) {
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

float worstFitness() {
  float min = bestFitness();
  for (int i = 1; i<bags.length; i++) {
    if (bags[i].getFitness()<min && bags[i].getFitness()>0) {
      min = bags[i].getFitness();
    }
  }
  return min;
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
  if (bestFitnesses.size()>6) {
    if (!maxFound()) {
      generations.add(frameCount);
      bestFitnesses.add((int) bestFitness());
      worstFitnesses.add((int) worstFitness());
    } else {
      long time2 = System.nanoTime();
      println((time2-time)/1000000000);
      noLoop();
    }
  } else {
    generations.add(frameCount);
    bestFitnesses.add((int) bestFitness());
    worstFitnesses.add((int) worstFitness());
  }
}

// bestFitnesses.get(bestFitnesses.size()-i).equals(Collections.max(bestFitnesses))
boolean maxFound() {
  int count = 0;
  
  for(int i = 1; i<6 ; i++){
   if( bestFitnesses.get(bestFitnesses.size()-i) - bestFitnesses.get(bestFitnesses.size()-i-1) == 0) {
     count ++;
   }
  }
  return count >=5;
}

void renderGraph() {
  for (int i = 0; i<generations.size()-1; i++) {
    int x1 = round(map(generations.get(i), 0, frameCount, 0, width*0.8));
    int x2 = round(map(generations.get(i+1), 0, frameCount, 0, width*0.8));

    int y1 = round(map(bestFitnesses.get(i), Collections.min(worstFitnesses)-50, Collections.max(bestFitnesses)+height*0.1, height, 0));
    int y2 = round(map(bestFitnesses.get(i+1), Collections.min(worstFitnesses)-50, Collections.max(bestFitnesses)+height*0.1, height, 0));
    int y3 = round(map(worstFitnesses.get(i), Collections.min(worstFitnesses)-50, Collections.max(bestFitnesses)+height*0.1, height, 0));
    int y4 = round(map(worstFitnesses.get(i+1), Collections.min(worstFitnesses)-50, Collections.max(bestFitnesses)+height*0.1, height, 0));
    stroke(0, 0, 255);
    strokeWeight(3);
    line(x1, y1, x2, y2);
    stroke(255, 0, 0);
    line(x1, y3, x2, y4);
    stroke(0);
  }
  line(width*0.8, height, width*0.8, 0);
  textSize(24);
  text("Time: " + millis()/1000.0 +"s", width*0.81, height*0.07);
  text("Generation: " + frameCount, width*0.81, height*0.1);
  text("Best Fitness: " + Collections.max(bestFitnesses), width*0.81, height*0.13);
  text("Current Fitness: " + bestFitnesses.get(bestFitnesses.size()-1), width*0.81, height*0.16);
  text("Weight of Bag: " + bestBackpack().getWeight() + "g", width*0.81, height*0.19);
  text("Population: " + size, width*0.81, height*0.22);
  text("Mutation Rate: " + globalMutationRate, width*0.81, height*0.25);
  line(width*0.81, height*0.27, width-width*0.01, height*0.27);
  text("Best backpack: ", width*0.81, height*0.31);
  textSize(16);
  text(bestBackpack().toString(), width*0.81, height*0.34);

  strokeWeight(1);
  fill(100);

  rect(width*0.805, height*0.89, 40+width*0.1, height*0.1);
  fill(0, 0, 255);
  rect(width*0.81, height*0.9, 20, 20);
  fill(255, 0, 0);
  rect(width*0.81, height*0.95, 20, 20);
  fill(255);

  text("Best Fitness", width*0.83, height*0.9+15);
  text("Worst Fitness", width*0.83, height*0.95+15);

  text("Axies: # generations / fitness", width*0.35, height*0.95);
}

void loadConfig() {
  String[] config = loadStrings("config.txt");
  for (String s : config) {
    String[] split = s.split(" ");
    if (split[0].equals("population")) {
      size = Integer.parseInt(split[1]);
    } else if (split[0].equals("mutationRate")) {
      globalMutationRate = Float.parseFloat(split[1]);
    } else if (split[0].equals("maxWeight")) {
      maxWeight = Integer.parseInt(split[1]);
    }
  }
}
