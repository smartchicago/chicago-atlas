# Chicago Atlas Schema

![chicago_atlas_schema](https://cloud.githubusercontent.com/assets/1406537/5253501/524dee9a-796d-11e4-99fa-6463fda15829.png)

## Notes on the data schema

#### Categories
- These are categories of datasets. They represent the collapsible panes on the map page (with the exception of Affordable Resources, which is separate).

#### Datasets
- These are datasets belonging to categories, and correspond to the buttons within each expandable category on the map page. They represent a a specific slice of data within a category, e.g. ‘uninsured 0 to 17’ (a dataset) within ‘uninsured by age’ (a category).

#### Statistics
- The statistics table holds the values in a given dataset, across many geographies. The values may or may not come with a upper & lower confidence intervals.

#### Geographies
- There are 3 difference geography types - ‘Community Area’ (i.e. neighborhood), ‘Zip’, and ‘City’
- Each dataset has statistics broken down by zip OR by neighborhood (which ones are by zip?)
- Each dataset will have a statistic for the entire city (all neighborhoods or all zips)
- The id for the city of Chicago is 100
- Some of the zip codes (in downtown Chicago) have been consolidated into one geography id. All other individual zip codes have ids that are integer forms of their name  
    * ‘60601, 60602, 60603, 60605, 60605 & 60611’ -> id = 12311  
    * ‘60606, 60607 & 60661’ -> id = 6761  
    * ‘60642 & 60622’ -> id = 60622  
    * ‘60827 & 60633’ -> id = 60827  
    * '60610 & 60654’ -> id = 60610  
     
#### Providers
- Currently, the providers table only contains hospitals (i.e. primary_type = ’hospital’). However, it is set up so that it can hold different provder types in the future.
- src_id is the id used in the source data (the original excel file with all hospital data)

#### Provider Stats
- These are statistics for providers - currently, these hold all the statistics for the charts on the hospital page.
- Each chart on the hospital page has its own stat type (with the exception of the revenue charts, which are stacked bar charts combining multiple stat types)
- Each bar within a chart has its own stat (the text for the bar) & value (the number for the bar)
- For hospitals, provider_stats.provider_id corresponds to providers.src_id rather than providers.id
     
#### Intervention Locations
- These are the resources on the resource page, which can be accessed by clicking on any of the ’N resources’ links next to the community areas on the places page
- All of the resources come from purple binder


## How to add a dataset

1. Determine which category the dataset belongs in. If the category doesn’t exist yet, modify the category rake task (categories.rake) where the categories are defined, and add a name and description
2. Identify the appropriate rake file for adding datasets & statistics. Rake files are organized by source (e.g. chicago.rake is for data from the Chicago data portal, chitrec.rake is for data from CHITREC). If the data comes from a new source, create a new rake file
3. Create a new rake task in the appropriate rake file, & make sure the new rake task is included under the :all task in import.rake
4. Within the rake task, define (a) how data will be flattened into dataset groupings, and (b) how statistics will be added for each dataset grouping. (See chitrec.rake for an example of adding rows to the datasets table, & adding rows to the statistics table for each dataset)  
    a) For adding datasets, make sure to set category_id by looking up the category name in the category table, rather than manually. In addition to defining the required column values for each dataset, define any necessary information to access the statistics for a given dataset (e.g. column name in a csv, table id/url in data portal, etc)  
    b) If adding statistics to the statistics table (statistics linked to geographies), make sure to set geography_id by looking up the geography in the geography table (there is a helper function for this, get_area_id) rather than manually. Also, make sure to define a statistic for the city of Chicago. If adding statistics to the provider_stats table (statistics linked to providers), be careful in defining provider_id. For hospitals, provider_stats.provider_id corresponds to providers.src_id, and not providers.id (because the hospital data came with hospital ids defined)
