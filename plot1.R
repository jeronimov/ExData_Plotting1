# First calculate a rough estimate of how much memory the dataset will require in memory before reading into R.
# According to http://simplystatistics.org/2011/10/07/r-workshop-reading-in-large-data-frames
# a useful tricks is doing a calculation along the lines of #rows * #columns * 8 bytes / 2^20
# This gives you the number of megabytes of the data frame

# Check if data sources are present
if (!file.exists("household_power_consumption.txt")) {
  url  = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  dest = "powerconsumption.zip"
  meth = "internal"
  quit = TRUE
  mode = "wb"
  download.file(url, dest, meth, quit, mode)
  unzip("powerconsumption.zip")
  file.remove("powerconsumption.zip")
}

# First need set these variables
totalRam = 8155
totalRows = 2075259
totalCols = 9

# Calcula dataset size
size = totalRows * totalCols * 8 / 2^20

# Check if dataset size is less than half of total memory
if(size < totalRam/2){

  # We will only be using data from the dates 2007-02-01 and 2007-02-02.
  data <- subset(read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE), Date=='1/2/2007' | Date=='2/2/2007')

  # Add new column Date_time
  data <- cbind(data,Date_time=as.POSIXct(strptime(paste(data$Date,data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")))

  # Plot the histogram
  hist(data$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col=554)
  
  ## Copy my plot to a PNG file
  dev.copy(png, file = "plot1.png", width = 480, height = 480)
  
  ## Close the PNG device
  dev.off()  
}