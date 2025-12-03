# Data-824-Final-Project

## Background
Often times, the process surrounding searching through online reviews for products is extremely difficult. A quick Google search for what phone to buy in 2025, for example, provides link after link of advertised reviews, lists that don't offer a clear methodology to their ranking system, or worse yet, reviews that were sponsored by manufacturers. My solution to this is a dashboard titled Find My Phone: a simple dashboard using third party, non-affiliated data to help users select a mobile phone based on parameters of their choosing. Just select an x and y variable from the list and voila - you have a graph showing you where each phone model ranks by brand. Brand agnostic, or only interested in certain brands? That's ok! Dynamically filter to only look at specific brands, or even remove brands as a grouping variable at all!

## About the Data
The data I used was from a Kaggle dataset compiled specifically for machine learning and data visualization. The dataset curator has no connections to mobile phone manufacturing, and the data itself was rated a 10.0 on the Kaggle usability scale, meaning it has a high degree of clarity and trust among users. Moreover, the dataset curator is one of the top Kaggle dataset contributors.

## About the Dashboard
The dashboard is completely reactive and dynamic, designed to work with the variables the user has provided. I have grouped barplots for categorical-categorical selections, violin/jitter plots for categorical/numeric, and scatterplots for numeric/numeric. I did dynamic data visualizations like this becaus each combination of data types require different types of visualizations, allowing users to conveniently see their graphs as they make them. Additionally, using plotly, I have added in a hover feature for users to find a specific model they are interested in that falls within an acceptable range of their selected variabls.

## Don't want to download the code and data?
Don't worry, I thought of that! I have a Shiny account I use for random jobs I get freelancing/consulting and have the dashboard hosted there if you'd like.
Link to the dashboard is here: [https://corsairanalytics.shinyapps.io/FinalProject-824/](https://corsairanalytics.shinyapps.io/FinalProject-824/)
