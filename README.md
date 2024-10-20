# MySQL-Project-
This is a MyQL data cleaning and data analysis project for Companly layoffs

Project Overview
The dataset l used in this project contains information about layoffs across various companies, including details such as the number of employees laid off, the industry, and the location. The project focuses on analyzing the layoff trends and cleaning the data to ensure quality and consistency.

Key Features:

Exploratory Data Analysis (EDA):
Summarizing the key statistics such as the maximum and minimum number of layoffs and the percentage laid off.
Analyzing trends over time, grouping layoffs by month, year, industry, and country.
Used aggregate functions to group and sort the data by various attributes.
Implementing window functions to create cumulative totals of layoffs over time.

Data Cleaning:
Removing duplicate records based on key attributes like company, industry, location, and date.
Standardized data by trimming whitespace and formatting inconsistencies in fields like company names and country names.
Handled null and blank values, ensuring that data is cleaned and ready for analysis.
Ensured consistency in date formats and industry classifications (e.g., standardizing "Crypto%" to "Crypto").
Removed records with missing critical data, such as the number of employees laid off.

