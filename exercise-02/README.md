# Instructions

This exercise asks you to compute the [Body Mass Index][bmi] (BMI) for a representative sample of U.S. adults. The formula for BMI is as follows:

$$\mathsf{BMI} = \frac{\mbox{mass} \ \mathsf{(kg)}}{\left( \mbox{height} \ (\mathsf{m})\right)^2} = \frac{\mbox{mass} \ \mathsf{(lb)} \times 703}{\left(\mbox{height} \ (\mathsf{in})\right)^2}$$

[bmi]: https://en.wikipedia.org/wiki/Body_mass_index

The first formula uses metric units. The second one, which is relevant in the U.S. context, uses [imperial units][imperial].

[imperial]: https://en.wikipedia.org/wiki/Imperial_units

The clinical classification of BMI for adults is as follows:

- For __normal weight__ adults, $18.5 < \mathsf{BMI} < 25$
- For __overweight__ adults, $25 \leq \mathsf{BMI} < 30$
- For __obese__ adults, $\mathsf{BMI} \geq 30$

The data that you will be using is the [U.S. National Health Interview Survey][nhis], which I have included in the `data` folder. I have also included some of its technical documentation in the `docs` folder.

All answers should go into the `exercise-02.r` answers script, which is structured in several sections. At the top of the script, I have included the code to load a few packages that should be useful to complete the exercise.

[nhis]: https://www.cdc.gov/nchs/nhis/index.html

## 1. Load a dataset

In Section 1 of the script, write code to load the NHIS dataset into the `nhis` object. This will require sorting out what file path to use, and which function to use given the format of the data.

_Hint_ --- some R functions can read zipped datasets directly.

In that same section, write the code and answer to the following question:

> __How many respondents were interviewed by the NHIS in 2018?__

## 2. Recode missing values

Inspect the `height` and `weight` variables. Both of them have special values that should be recoded to missing values:

- In the __`height`__ variable, which measures respondents' height in inches (in), values __greater or equal to 96__ should be recoded to `NA`.
- In the __`weight`__ variable, which measures respondents' weight in pounds (lb), values __greater or equal to 996__ should be recoded to `NA`.

Write the code to do this in Section 2 of the script.

_Note_ --- using the [`haven::print_labels`][print_labels] on the variables mentioned above will help you understand why these recodes have to be performed before using both variables to compute BMI in the next section.

[print_labels]: https://haven.tidyverse.org/reference/print_labels.html

## 3. Compute and summarise

In Section 3 of the script, create a new variable called `bmi` in the `nhis` data frame. The formula that you should be using is copied again for reference:

$$\mathrm{BMI} = \frac{703 \times \mathrm{weight}}{\mathrm{height}^2}$$

_Hint_ --- the way to raise a variable `x` at the power of `k` is to use `x^k`.

Once you have created the `bmi` variable, summarise it in order to answer the following questions:

> __1. For how many respondents did we manage to compute BMI?__  
> __2. What was the average BMI of U.S. adults in 2018?__

Write your code in Section 4 of the answer script, and include your answers as comments next to the relevant line of code.

_Hint_ --- be careful with missing values! Reviewing the code in `class-02.r` should be helpful at that stage, especially `sum(!is.na(x))` and the `na.rm = TRUE` option that applies to many functions.

## 4. Aggregate and summarise

Using the `sex` and `race` variables, find a way to compute:

- average BMI by __sex__
- average BMI by __racial-ethnic profile__

_Hint_ --- both variables have value labels, which you will need to understand the results. The [`group_by`][group_by] and [`summarise`][summarise] functions that we covered in class should be useful here. An alternative is to learn how to use the [`aggregate`][aggregate] function.

You should now be able to answer the following question:

> __Which socio-demographic group has the highest average BMI?__

Write your code and answer in Section 4 of the script.

[group_by]: https://dplyr.tidyverse.org/reference/group_by.html
[summarise]: https://dplyr.tidyverse.org/reference/summarise.html
[aggregate]: https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aggregate

## 5. Visualise a distribution

As a bonus, find a way to plot the distribution of BMI as a [histogram][histogram] with 15 bins.

[histogram]: https://r-graph-gallery.com/histogram.html

Write your code and answer in Section 5 of the script.

_Hint_ --- you can search for help on the Web on how to do this with base R, or on how to do this with the [`ggplot2`][ggplot2] package.

[ggplot2]: https://ggplot2.tidyverse.org/

## Final notes

__When you are done completing the exercise, select all of the code in the answers script, and execute it to check that it runs without any errors.__ After doing so, save your final answers and quit RStudio.

You will need to complete this exercise in order to complete the next one, and the graded work that you will have to complete later will be very much like this exercise and the next ones to come.

Remember that the code and slides that I have distributed in class contain links to handbook chapters, videos and tutorials that can help you learn the kind of R code that you will need in this context.

Thanks for your work!
