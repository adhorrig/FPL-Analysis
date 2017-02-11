#FPL Analysis

An analysis of data which has been extracted from Fantasy Premier League, using R and Python.

The results of the project can be viewed [here.](https://www.dropbox.com/s/4ecypd733esi4tg/FPL-Exploration.pdf?dl=0)

## Installation

The first step is to setup a database:

1. Create an empty database named 'fpl'.
2. Run sql/fpl_s016_12_20.sql inside the 'fpl' database. This will generate the schema for you such that the data can later be saved.

To extract the Fantasy Premier League data:

1. ```git clone https://github.com/adhorrig/fpl.git``` to download the tools for extraction.
2. ```cd fpl``` to move into the directory.
3. ```npm install``` to download the project dependencies from the node package manager.
4. Go into the files ‘live.js’, ‘players.js’, ‘profiles.js’, ‘teams.js’ and ‘gameweeks.js’. You will need to change the database connection details to match your own.
5. Run each Node file using ```node filename.js```. Note: Profiles.js will try to extract data for 4 million profiles. Reduce this number in the for loop or the run time will be 20+ days.
6. The data from the Fantasy Football application will now have been extracted and saved to your database.

The second dataset comes from Met Eireann.

1. It can be downloaded from: http://www.met.ie/climate-request/
2. The weather data is in a CSV file and will need to be inserted to the database created in the beginning (specifically, the weather table).
3. Many MySQL clients take care of this for you, just right click on the table name and click import from CSV.
4. If no client is being used – refer to: http://stackoverflow.com/questions/6605765/importing-a-csv-into-mysql-via-command-line

Once both datasets have been imported to the database, the analysis can be carried out.

## Running

R.

1. Open analysis.r
2. Install the libraries as noted at the top of the file.
3. On line eight, database connection details will need to be changed to match your own connection.
4. After this, the code can be ran line by line to generate graphs which will visualize the data from inside our database.

Python.

1. Export the profiles table to CSV from the database.
2. Execute ```python map.py profiles.csv | python reduce.py > results.txt```
3. The results of the MapReduce job will show the total number of points gathered for each regional user profile. It takes a few minutes to complete and the results file will be 2.84 GB.
