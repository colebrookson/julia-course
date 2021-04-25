# set packages
using CSV, DataFrames
# set url for the covid data location
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# grab the data
download(url, "covid_data.csv")
readdir()

# read in data
 data = CSV.read("covid_data.csv", DataFrame)

# find unique countries in the dataset
