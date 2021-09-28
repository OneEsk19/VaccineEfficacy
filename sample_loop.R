# pfizer & bioNTech vaccine
# Trial parameters
# ~ 43,000 participants
# Split evenly into placebo and vaccine groups
# = 21,500 control, and 21,500 vaccine
# total covid cases = 170
# 8 cases in vaccine, 162 in trial
# basiuc vaccine efficacy formula
# VE = ((ARU - ARV) / ARU) * 100
# ARU = infections in placebo group / number in group
# ARV = infections in Vaccinated / number in group

# create the full population of 43,000,
# in which there are 162 infected with covid19
# infected = 1, not infected = 0
population <- c(replicate(162, 1), replicate(42838, 0))

# Assuming the vaccine is ineffective,
# and that therefor infections are equally likely 
# in either group..
# divide the population in half to simulate the two
# groups by random sampling of 21500 individuals
testsample <- sample(population, 21500)
# calculate total ppositiva cases in placebo" group
placebo <- sum(testsample)
# calculate total positive cases in "vaccinated" group
vaccinated <- 162 - placebo
# calculate efficacy of vaccine
efficacy <- ((placebo - vaccinated)/vaccinated) *100
efficacy
#################################
## Turn this process into a loop so we can sample n times

# how many times the simulation should run
nruns <- 100000
# initialise vector to hold results
eff_res <- rep(0, nruns)
# create the loop
for (i in 1:nruns) {
      testsample <- sample(population, 21500) 
      placebo <- sum(testsample)
      vaccinated <- 162 - placebo
      efficacy <- ((placebo - vaccinated)/vaccinated) *100
      eff_res[i] <- efficacy
}

## A nice histogram to show the distribution of vaccine-efficacy-by-chance
library(ggplot2)

efficacies <- data.frame(eff_res)
     
ggplot(efficacies, aes(x = eff_res))+
      geom_histogram(bins = 30, col = "black",
                     fill = "lightblue")+
      labs(title = "If vaccine efficacy was due to chance",
           x = "Vaccine Efficacy", 
           y = "Occurences in 10000 simulations")

# how many simulations produce an efficacy of over 90%
abv_90 <- efficacies[efficacies$eff_res >90,]
abv_90 

 