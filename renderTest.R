library('RUnit');

dirName <- "C:\\Users\\jhs\\Desktop\\backup\\FY15\\weather_forecast\\";
masterName <- "weather_forecast.R"
master <- paste0(dirName, masterName)
source(master);

test.suite <- defineTestSuite("testing 1-2-3", 
                              "C:\\Users\\jhs\\Desktop\\backup\\FY15\\weather_forecast\\test", 
                              testFileRegexp = '^\\d+\\.R');
test.result <- runTestSuite(test.suite);
printTextProtocol(test.result);