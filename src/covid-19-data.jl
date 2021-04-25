


# set packages
using CSV, DataFrames, Plots, Dates
# set url for the covid data location
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# grab the data
download(url, "covid_data.csv")
readdir()

# read in data
 data = CSV.read("covid_data.csv", DataFrame)

# find unique countries in the dataset
rename!(data, 1 => "province", 2 => "country" ) # ! is a convention: function *modifies* it's argument it doesn't create a new thing

# how many cases in the united states
all_countries = collect(data[:, 2])
unique_countries = unique(countries)
list_of_countries = ["US", "United Kingdom", "South Korea", "China", "Japan", "France", "Germany", "India"]
countries_data = filter(row -> row.country ∈ list_of_countries, data)
num_days = ncol(data[:,5:end])

#accumulate data for places split into territories
zeros_US = 


U_countries = [startswith(country, "U") for country in countries]; # use array comprehension
print(data[U_countries, 2])

US_row = findfirst(countries .== "US") # the dot is broadcasting: apply operation to each element of the vector
US_data_row = data[US_row, :]
US_data = Array(US_data_row[5:end])

plot(US_data)
date_strings = String.(names(data))[5:end] # apply sring to each element via '.' 
# parse into julia object
format = Dates.DateFormat("m/d/Y")

dates = parse.(Date, date_strings, format) .+ Year(2000)
plot(dates, US_data, xticks = dates[1:50:end], xrotation = 45, leg = :topleft, label = "US data", m=:o, yscale =:log10)
xlabel!("date")
ylabel!("confirmed cases")
title!("US confirmed COVID-19 cases")
annotate!(dates[end], US_data[end], text("US", :blue, :left))

function data_extract_plot(country)
    