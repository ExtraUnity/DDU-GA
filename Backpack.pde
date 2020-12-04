class Backpack {
  ArrayList<Item> items;
  float fitness = -1;
  float mutationRate;
  final float MAXIMUM_WEIGHT = 5000;

  Backpack() {
    // use Christians variant
  }

  void mutate() {
  }

  float fitness() {
    int val = 0;
    int wei = 0;

    for (Item q : this.items) {
      val += q.value;
      wei += q.weight;
    }
    if (wei > MAXIMUM_WEIGHT) {
      return 0; // an invalid bagpack
    } else {
      return val;
    }
  }

  // if the number is unknown calculate it, if it is known return it
  float getFitness() {
    if (this.fitness == -1) {
      this.fitness = fitness();
    } 
    return this.fitness;
  }
}
