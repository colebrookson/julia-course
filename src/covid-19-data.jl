########## 
##########
# This code is for the 1st pset for course 6.S083 Computational Thinking held
# at MIT and offered online freely 
##########
##########
# AUTHOR: Cole B. Brookson
# DATE OF CREATION: 2021-04-25
##########
##########

# set up =======================================================================

# set packages
using CSV, DataFrames, Plots, Dates
# set url for the covid data location
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_cov
id_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# grab the data
download(url, "covid_data.csv")
readdir()
data = CSV.read("covid_data.csv", DataFrame)

# find unique countries in the dataset
rename!(data, 1 => "province", 2 => "country" ) 

countries = ["US", "United Kingdom", "South Korea", "China", "Japan", 
            "France", "Germany", "India"]
countries_data = filter(row -> row.country ∈ countries, data)
num_days = ncol(data[:,5:end]) # number of days in the dataset

# accumulate data for places split into territories ============================

# initialize countries dictionary
countries_dict = Dict{String,Vector}(
    "US" => zeros(ncol(data[:,5:end])),
    "United Kingdom" => zeros(ncol(data[:,5:end])),
    "South Korea" => zeros(ncol(data[:,5:end])),
    "China" => zeros(ncol(data[:,5:end])),
    "Japan" => zeros(ncol(data[:,5:end])),
    "France" => zeros(ncol(data[:,5:end])),
    "Germany" => zeros(ncol(data[:,5:end])),
    "India" => zeros(ncol(data[:,5:end]))
);

# loop through the countries and days and add up the cases 
for country in countries

    temp_df = filter(row -> row.country == "United Kingdom", data);
    countries_dict[country] = [sum(temp_df[!, i]) for i in 5:size(temp_df,2)]

end

# plot all data ================================================================

# initialize empty plot
p = plot()



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
    