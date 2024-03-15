# Creating a dashboard for bike sale data

## 1.Make a copy of data
## 2.Cleaning
*    Remove duplicates
*    Replace M-Married, S-Single in Marital status column and F-Female M-Male in Gender status column.
Use Ctrl+F option for Find and Replace
*    Income field-make sure it is in currency 
*    Apply filter on Education and Occupation and check is there any spelling mistake in entries.
*    Apply filter in each column and check the entries
*    Age column -need to make bins. Use IF formulae.
*    =IF(L2>=55,"Old",IF(L2>=31,"Miidle Age",IF(L2<31,"Adolscent","INVALID")))

## 3.Data Visualization
  Create  pivot tables
*    The table displays the average income of families who do not own a bike.
*    The table illustrates the relationship between commute distance and whether or not a bike was purchased.
*    What does the table show about the age groups and their bike purchase decisions?
  Create Visualizations/Charts.

## 4.Create Dashboard
Format the dashboard and add slicers

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/5a6c5928-736e-44f9-aa61-b50e055445c8" alt="Alt text for the image">
  <br>
  <em>An Interactive Dashboard</em>
</p>
