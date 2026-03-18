# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Basic R syntax, in 150 lines
#
# ==================== See the README file for data sources and instructions ===


# hello world -------------------------------------------------------------

print("hello world!")

# same thing, but we first save the piece of text "hello world!" into an object
# called 'txt', which we then show (or 'print') on screen
txt <- "hello world!"
txt

# guess what this function does!
rep(txt, 99)

# basic math --------------------------------------------------------------

# round x to k decimals
round(pi, 2)

# elevate x at power k
10^2
10^3
10^4

# square root
sqrt(9)
4^(1/2)

# big and small numbers ---------------------------------------------------

exp(42) # = 1.7*10^18 (a reaaaally large number!)

# 1e-3 = 10^(-3) (like millimeters, for example)
1e-3
# 2.7e-4 = 2.7*10^(-4) (small number, close to 0)
2.7e-4

# vectors -----------------------------------------------------------------

# create a vector containing sequence 1, 2, ..., 5, 6
x <- 1:6
x

# compute summary statistics on the vector
mean(x)
sum(x)

# logical tests -----------------------------------------------------------

# which elements in vector x satisfy the following tests?
x <= 5
x == 5
x != 5

# get a table of results instead of the individual details
table(x > 5)

# this asks whether each element is in the sequence 3-4-5
x %in% 3:5

# packages ----------------------------------------------------------------

# executing the following line of code will install all packages required for
# our class examples and exercises; you only need to execute it once, and will
# never need to execute it again
install.packages(c("broom", "ggrepel", "sf", "survey", "texreg", "tidyverse"))

# the following line loads one of the installed packages (it 'activates' it, in
# a way); you will need to do this every time you launch R and want to use it,
# and you will need to successfully load that package for the rest of thee code
# below to work properly
library(tidyverse)

# data --------------------------------------------------------------------

# this opens a dataset that's included in what you just installed; it won't
# work if you did not install the 'tidyverse' package first (see above)
gss <- forcats::gss_cat
gss

# execute that line to open a help page about the dataset, which is a survey
?forcats::gss_cat

# describe the dataset and its number of observations (rows)
glimpse(gss)
nrow(gss)

# average of the 'age' variable (the first result is 'NA', which means missing,
# because there are some missing values in the variable; the second line of code
# shows the option that is required to remove them)
mean(gss$age)
mean(gss$age, na.rm = TRUE)

# two ways to count missing values in a variable
table(is.na(gss$age))
sum(is.na(gss$age))

# two ways of describing the values of a variable
table(gss$rincome)
count(gss, rincome)

# do not worry if the jargon (dataset, observations, variables, values) does
# not yet make entire sense to you: we will work on it in class

# code that spans multiple lines ------------------------------------------

# the following produces a plot, but you will have to select all three lines to
# actually get a result, because of the '+' symbol at the end of each line
ggplot(gss, aes(age, fill = marital)) +
  geom_density(alpha = 1/3) +
  facet_wrap(~ marital)

# if you get stuck, press [Esc] in the Console
# also, the plot produces a warning, but that's fine (a warning is not an error)

# the following lines produce a table, but you will again have to select all
# three lines to actually get a result, because of the '%>%' symbol at the end
# of each line (the symbol is called a 'pipe')
filter(gss, age < 35) %>%
  count(marital) %>%
  mutate(pct = 100 * n / sum(n))

# if you get stuck, press [Esc] in the Console
# exercise: guess what the plot and table each show

# more complex code -------------------------------------------------------

# this more complex example tells you how many of the survey respondents are
# under 35 years-old AND (&) are separated
table(gss$age < 35 & gss$marital == "Separated")
nrow(filter(gss, age < 35, marital == "Separated"))

# this more complex example tells you how many of the survey respondents are
# under 35 years-old AND (&) are separated OR (|) divorced
table(gss$age < 35 & (gss$marital == "Separated" | gss$marital == "Divorced"))

# other ways to get the same result
nrow(filter(gss, age < 35, marital == "Separated" | marital == "Divorced"))
nrow(filter(gss, age < 35, marital %in% c("Separated", "Divorced")))

# kthxbye
