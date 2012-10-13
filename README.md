##Converting Ugly Matrix-like CET Temperature data set to Tabular format

The Centre Central England Temperature (CET) dataset is the longest instrumental record of temperature in the world. The mean, minimum and maximum datasets are updated monthly, with data for a month usually available by the 3rd of the next month.

A provisional CET value for the current month is calculated on a daily basis. The mean daily data series begins in 1772 and the mean monthly data in 1659. Mean maximum and minimum daily and monthly data are also available, beginning in 1878.

The only downside in my opinion is the format chosen by the Met Office to present this data (matrix) is so unfriendly that people spend a lot of time creating complex macros in Excel (I've seen it) to convert this data to a tabular format to merge to other variables.

The data layout is as follow:

* Column 1: year
* Column 2: day
*Columns 3-14: daily CET values expressed in tenths of a degree. There are 12 columns; one for each of the 12 months.

My intention is to convert the above to a data frame with 2 columns: Date & Temperature.