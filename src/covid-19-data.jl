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
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# grab the data
download(url, "C:/Users/brookson/Documents/Github/julia-course/data/covid_data.csv")
data = CSV.read("C:/Users/brookson/Documents/Github/julia-course/data/covid_data.csv", DataFrame)

# find unique countries in the dataset
rename!(data, 1 => "province", 2 => "country" ) 

# make lists of country names
countries = ["US", "United Kingdom", "South Korea", "China", "Japan", 
"France", "Germany", "India"]
country_names = countries

function data_extract_plot(country_names, data)
    countries_data = filter(row -> row.country ∈ country_names, data);
    num_days = ncol(data[:,5:end]); # number of days in the dataset

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
    )
    countries_dict = Dict{String,Vector}();
    for country in country_names
        countries_dict[country] = zeros(ncol(data[:,5:end]));
    end
    # loop through the countries and days and add up the cases 
    for country in countries
        temp_df = filter(row -> row.country == country, data);
        countries_dict[country] = [sum(temp_df[!, i]) for i in 5:size(temp_df,2)]
    end

    # plot all data ============================================================

    # get dates
    date_strings = String.(names(data))[5:end] # apply sring to each element via '.' 
    format = Dates.DateFormat("m/d/Y")
    dates = parse.(Date, date_strings, format) .+ Year(2000)

    # initialize empty plot
    p = plot(xticks = dates[1:50:end], xrotation = 45, leg = :topleft, m=:o)
    xlabel!("Date")
    ylabel!("Confirmed cases")
    title!("Selected countries confirmed COVID-19 cases")
    # loop to add objects
    for country in countries
        p = plot!(dates, countries_dict[country], label = country)
    end
    
    return p 
end 

data_extract_plot(countries, data)
   