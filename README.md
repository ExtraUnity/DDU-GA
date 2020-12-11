# DDU-GA
## Resumé  
Løsning af Rygsækproblemet ved brug af en genetisk algoritme.
Specifikt er det 0-1 rygsækproblemet.
Skrevet af Emil Boesgaard Nørbjerg & Christian Vedel Petersen, H. C. Ørsted Gymnatiet.
Opgaven er en del af faget Digitalt design og udvikling.

## Abstract 
Solution of the [Knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem), solved using a [Genetic algorithm](https://en.wikipedia.org/wiki/Genetic_algorithm)
Specifically it is the 0-1 Knapsack problem.
Written by Emil Boesgaard Nørbjerg & Christian Vedel Petersen, H. C. Ørsted Gymnatiet.
This assignment is part of the subject digital design and development

## Config and input file
In the config file, the variables of the program can be configured.
This includes the population size, the mutation rate, and the maximal knapsack weight.

In the input file, the list of available items can be specified.
The first line of the file contains instructions for use.

## Optimization of algorithm
To optimize the algorithm, for the specific items, the algorithm was timed, on how long it took to find the optimal solution.
This was averaged out over 200 tries. The test was run for different configurations, first the mutation rate and then the population size.
The data was analysed in Excel, and using regression the optimal value for each variable was found.
The optimal value for the mutation rate is 0.01 or 1%. The optimal value for the population size depends on the goal of the optimization.
If the program needs to be optimized for the fewest amount of generations to find the solution, then the optimal population size is around 4100.
If the program instead needs to be optimized for the shortest time to find the solution, then the optimal population size is around 700.
However it also needs to be taken into account, that the smaller the population, the bigger chance there is that the optimal solution will never be found.
With a population of 700, the chance of inbreeding is quite high. Therefore the amount of time it takes to find the optimal solution will vary a lot with a population of 700.
