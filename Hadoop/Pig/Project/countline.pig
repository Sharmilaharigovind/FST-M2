-- Load the input data from each specified file
input_data1 = LOAD 'hdfs:///user/root/episodeIV_dialogues.txt' USING PigStorage(',') AS (character:chararray, dialogue:chararray);
input_data2 = LOAD 'hdfs:///user/root/episodeV_dialogues.txt' USING PigStorage(',') AS (character:chararray, dialogue:chararray);
input_data3 = LOAD 'hdfs:///user/root/episodeVI_dialogues.txt' USING PigStorage(',') AS (character:chararray, dialogue:chararray);

-- Combine the datasets using UNION
input_data = UNION input_data1, input_data2, input_data3;

-- Group the data by character
grouped_data = GROUP input_data BY character;

-- Count the number of lines spoken by each character
character_line_counts = FOREACH grouped_data GENERATE
    group AS character,
    COUNT(input_data) AS total_lines;

-- Order the results by total_lines in descending order
ordered_results = ORDER character_line_counts BY total_lines DESC;

-- Store the results in HDFS
STORE ordered_results INTO 'hdfs:///user/root/character_line_counts' USING PigStorage(',');
