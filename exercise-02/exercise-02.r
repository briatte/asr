# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Obesity prevalence in the United States, 2018 (student answers)
#
# ==================== See the README file for data sources and instructions ===

# required packages -------------------------------------------------------

library(dplyr)   # transform data
library(ggplot2) # visualize data
library(haven)   # open Stata datasets

# 1. load the data --------------------------------------------------------



# 2. recode missing values ------------------------------------------------



# 3. compute and summarise a variable -------------------------------------



# 4. aggregate and summarise by groups ------------------------------------



# 5. visualize a distribution ---------------------------------------------

# below is the code to answer Question 5 with the `ggplot2` package
# all you will need to do is to change DATA and VARIABLE

# using `ggplot2`
ggplot(DATA, aes(x = VARIABLE)) +
  geom_histogram(color = "grey90", bins = 15)

# kthxbye
