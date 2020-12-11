class Backpack {
  Item[] items;
  float fitness = 0;
  float mutationRate;
  final float MAXIMUM_WEIGHT = maxWeight;

  Backpack() {
    this.mutationRate = globalMutationRate;
    items = new Item[ITEMS.length];
    
    for (int i = 0; i<ITEMS.length; i++) {
      if (random(1)>0.5) {
        items[i] = ITEMS[i];
      }
    }
  }

  void mutate(int index) {
    if(random(1)<mutationRate) {
      if(this.items[index] != null) {
        this.items[index] = null;
      } else {
        this.items[index] = ITEMS[index];
      }
    }
  }

  float fitness() {
    int val = 0;
    int wei = 0;

    for (Item q : this.items) {
      if (q != null) {
        val += q.value;
        wei += q.weight;
      }
    }
    if (wei > MAXIMUM_WEIGHT) {
      return 0; // an invalid backpack
    } else {
      return val;
    }
  }

  // if the number is unknown calculate it, if it is known return it
  float getFitness() {
    if (this.fitness == 0) {
      this.fitness = fitness();
    } 
    return this.fitness;
  }
  
  String toString(){
    StringBuilder sb = new StringBuilder(50);
    for(Item q : items){
      if(q != null) {
       sb.append(q.name + "\n");
      }
    }
  
    return sb.toString();
  }
  
  int getWeight() {
    int wei = 0;
    for (Item q : this.items) {
      if (q != null) {
        wei += q.weight;
      }
    }
    return wei;
  }
  
}
