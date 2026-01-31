# Instructions

The instructions below are to be read _in full_ and followed _very_ closely. You will need to have completed each step below to install some of the packages that we will be using later on. On top of that, you will need to repeat most of the steps below for future practice sessions and homework exercises.

Note that the instructions below contain __questions__ that we will correct in class.

## 1. Double-check that you have installed R and RStudio

You have been instructed to install R and RStudio, but experience shows that some students believe that they have done so, whereas in fact they have not --- so double-check your installation:

- On a Mac, go to your __Applications__ folder, and double-check that it contains both R and RStudio.

  __Important__ -- A common mistake among Mac newbies is to open RStudio directly from the virtual drive that opens if one double-clicks the RStudio DMG file. If you did that, RStudio is not yet installed: you have to drag-and-drop it to your Applications folder to copy it there. Eject the virtual drive and remove its DMG file after doing so.

- On Windows, go to your __Program Files__ folder, or whatever it is called on your system, and double-check that you can find both applications there.

__None of the next steps will work if R or RStudio are not actually installed on your machine. Find additional help online on how to do so if needed.__

## 2. Open a project folder in RStudio

This folder contains a file called __`ukraine.Rproj`__. The file has a blue-ish icon. Double-click that file to open RStudio with the `exercise-01` folder set as the __working directory__, which is a concept that we covered in class.

__Important__ -- The next steps require that you have properly unzipped the `exercise-01.zip` folder, which can be tricky on Windows:

- To unzip on a Mac, you simply double-clicked the `exercise-01.zip` file, which is perfectly fine.
- To unzip on Windows, do _not_ simply double-click the file, which will only show you the contents of the ZIP archive; instead, right-click on `exercise-01` and select __"Extract here"__ or any equivalent option in the language used by your Windows operating system.

__Windows users --- the next steps will fail if you did not properly unzip the `exercise-01` folder as instructed above.__

## 3. Check the working directory

Once RStudio has been opened as explained above, __check your working directory.__ The path to that directory is shown at the top of the __Console__ pane.

The path should look something like that:

    ~/Desktop/exercise-01

The first part is unimportant and might vary on your system -- for instance, you might have unzipped the `exercise-01` folder into your `Downloads` folder instead of on your `Desktop`, which is fine. What matters is the very last part of the path: it should read __`exercise-01`__.

To check that things are as they should, click the __Files__ pane in RStudio. You should see the following files in it:

    - ukraine.r
    - ukraine.Rproj
    - README.md
    - README.pdf

The file ending in `.r` is an R script that contains R code. The file ending in `.Rproj` is a project file, which is useful to correctly set the working directory.

If you do not see these files in your Files pane, you will have to __set the working directory manually:__ use the __"Session > Set Working Directory > Choose Directory…"__ menu, make sure that you select the `exercise-01` folder when asked to select a folder, and then perform the above check again.

Now, click the `ukraine.r` file to open it.

## 4. Install the required packages

Once the `ukraine.r` script is opened, RStudio will detect whether you have installed the `sf` and `tidyverse` packages or not.

If not, you will see a yellow banner at the top of the script window, with an "Install" option. Click that, and wait until the installation is over.

(Since we installed the `tidyverse` package bundle in class, you should not need to install that one, but will need to install the `sf` package.)

You can also manually install the packages by executing the following lines of code from the Console pane:

    install.packages("sf")
    install.packages("tidyverse")

__None of the next steps will work if you do not install the required packages first. Find additional help online on how to do so if needed.__

## 5. Execute some R code

Let's now execute the `ukraine.r` R script in a few steps.

First, select lines 16 to 55, and then press `Ctrl-Enter` to execute the code. You should get a results table that will look like this:

```
# A tibble: 27 × 2
   cty   ukr_in_eu
   <chr>     <dbl>
 1 AT         53.7
 2 BE         59.5
 3 BG         51.9
 4 CY         55.5
```

Have a look at the code that you just executed, and also look at the documentation that comes with this exercise. In particular, look for information on Question 3\_8 of the [Flash Eurobarometer 506](https://europa.eu/eurobarometer/surveys/detail/2772) survey.

__Do you now understand what the results stand for?__

> __NOTE__ -- if the code does not execute properly, you probably did not set your working directory properly: go back to Step 3, fix your working directory, and re-execute the code.

Well done, you are now set to work with R, RStudio and the tidyverse!

## 6. Execute more R code

Execute lines 62 to 66 of the code. You should get a plot as a result. The plot will automatically appear in the 'Plots' pane.

__Can you guess what the white lines delimit within each country?__ If not, look for a [hint](https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/territorial-units-statistics) in the code at line 59.

## 7. Produce the final plot

Last, execute lines 72 to 86 of the code. This will show a map, which will also get saved in the `exercise-01` folder as `ukraine_in_eu.png`. Take a look at the map, either in the 'Plots' pane or by opening that file.

> __TIP__ -- in RStudio, you can 'zoom' on plots by clicking the little '(+) Zoom' symbol on top of the 'Plots' pane.

Take a minute to look at the legend of the map. __Which country populations most strongly support Ukraine joining the EU ‘when it will be ready’ (as per the survey question wording)?__

## 8. Take a look at the bonus question

The final part of the code contains a bonus question. Answering this question will require reading the code closely to try understanding what it does.

The answer is not particularly complex, and is related to how surveys like the Eurobarometer are designed. If you need a hint, [here's one](https://www.gesis.org/en/eurobarometer-data-service/data-and-documentation/flash-eb/weighting-overview).

----

## Final words

__Do not skip this exercise.__ If you find it challenging, then you definitely need to practice your computing skills. We will build up those skills throughout the course, but that will work only if you assign enough time to work on the various tasks that we will go through together in class.

You might have failed at first on some of the steps outlined above, and I know from experience that some students find it discouraging not to succeed on first pass. Be aware that (statistical) computing works through trial-and-error. Accepting this is part of the learning goals of this course.

__All steps above can be complemented by looking for help online.__ Learning to do so efficiently is a skill in itself, so start practicing it as soon as possible, whenever required.

Last, __prepare some feedback for class__. I am particularly interested in understanding which parts of the exercise you found most challenging, and what kind of help you reached for in order to complete it.

You will need the skills that this exercise trains for future exams. From next week onwards, we will be learning some code together, which will enable you to understand the code that you executed for this exercise, as well as to write your own code.
