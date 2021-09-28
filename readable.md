---
title: "Vaccine Bootstrapping"
author: "G.Robertson"
date: "03/12/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Could the Covid 19 vaccine efficacy be due to chance alone?  

I made this at near the start of the pandemic when vaccines were being trialed. There were a number of posts on social media claiming the trial provided insufficient evidence of the efficacy of the vaccine, as in the results were due to chance.  

So here I'm going to use the trial data to see if it is possible to get the stated level of efficacy if the vaccine actually didn't work.

This is using the initial trial data for the Pfizer & bioNTech vaccine

> Null Hypothesis = The vaccine does not work  
> Hypothesis = The vaccine DOES work  

#### Initial Trial parameters and results  
* 43,000 participants  
* Split evenly into placebo and vaccine groups  
      = 21,500 control, and 21,500 vaccine  
* Total covid cases across all participants  
      = 170  
      8 cases in vaccine trial  
      162 in placebo trial  
* Vaccine efficacy achieved  = 95%  

#### Basic vaccine efficacy formula    
* VE = ((ARU - ARV) / ARU) * 100, where:  
      ARU = infections in placebo group / number in group  
      ARV = infections in Vaccinated / number in group  

      
### Simulating the null hypothesis (Bootstrapping)

Assumptions:  
* The vaccine is ineffective  
* Therefore infections are equally likely in either group  

So if the vaccine was ineffective, we would expect the vaccine group to behave in the same way as the placebo group.

Model Method:
```{r}
# Create the full trial population of 43,000 individuals in which there are 170 infected with covid19 and assigning binary identifiers: infected = 1,  not infected = 0 
population <- c(replicate(170, 1), replicate(42830, 0))

# Create a group from half of the original population
testsample <- sample(population, 21500)

# calculate total positive cases in this simulated group and call this the placebo group
placebo <- sum(testsample)

# The rest of the cases will be in the vaccine group
vaccinated <- 170 - placebo

# Now we can calculate the efficacy of vaccine in this experiment
efficacy <- ((placebo - vaccinated)/vaccinated) *100
print(efficacy)
```
Say we ran the same experiment 10000 times to see what efficacy we can achieve by chance.

```{r}
# how many times the simulation should run
nruns <- 10000
# initialise vector to hold all the results
eff_res <- rep(0, nruns)
# create the loop
for (i in 1:nruns) {
      testsample <- sample(population, 21500) 
      placebo <- sum(testsample)
      vaccinated <- 162 - placebo
      efficacy <- ((placebo - vaccinated)/vaccinated) *100
      eff_res[i] <- efficacy
}
```

Lets have a look at the distribution of the simulations
```{r}
# required library
library(ggplot2)
```

```{r}
efficacies <- data.frame(eff_res)
     
ggplot(efficacies, aes(x = eff_res))+
      geom_histogram(bins = 30, col = "black",
                     fill = "lightblue")+
      labs(title = "If vaccine efficacy was due to chance",
           x = "Vaccine Efficacy", 
           y = "Occurences in 10000 simulations")
```
The central tendency is an efficacy of around zero.  
In 10,000 simulations, how often do we actually get the stated efficacy of 95%?

```{r}
# How many simulations result in eff > 90?
abv_94 <- efficacies[efficacies$eff_res >94,]
howmany <- length(abv_94) 
```
```{r}
print(paste("in 10000 (simulated) clinical trials", howmany, "produced a vaccine efficacy of over 94% purely by chance"))
```
