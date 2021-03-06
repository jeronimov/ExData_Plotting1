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

  # Creates a 2x2 matrix for the plots to appear on and sets margins
  par(mfcol=c(2,2),
  mar = c(5,4,4,2),
  cex = (0.6))
  
  with(data, {
    # Plots graph 1
    plot(Date_time, Global_active_power, xlab="", ylab="Global Active Power", type="l")
  
    # Plots graph 2
    plot(Date_time, Sub_metering_1, xlab="", ylab="Energy sub metering", type="l")
    # Add line Sub_metering_2
    lines(Date_time, Sub_metering_2, col="red")
    # Add line Sub_metering_3
    lines(Date_time, Sub_metering_3, col="blue")
    # Add legend
    legend("topright", lwd=2, cex=0.8, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), bty = "n")
    
    # Plots graph 3
    plot(Date_time, Voltage, xlab="datetime", ylab="Voltage", type="l")
    
    # Plots graph 4
    data2 <- subset(data,Global_active_power>=0.01 & Global_active_power<=0.5)
    plot(data2$Date_time, data2$Global_active_power, ylim=c(0.01, 0.5), xlab="datetime", type="l", yaxs="i")
    #plot(Date_time, Global_active_power, ylim=c(0.01, 0.5), xlab="datetime", type="l", yaxs="i")
  })
  
  ## Copy my plot to a PNG file
  dev.copy(png, file = "plot4.png", width = 480, height = 480)
  
  ## Close the PNG device
  dev.off()  
}