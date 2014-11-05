# functions for course project 1

# Skim original big file to only those dates we want
# Save new file in handy format
skim.file <- function(orig.file = "household_power_consumption.txt"
                      , out.name = "skim.Rda"
                      , desired.dates = c("1/2/2007","2/2/2007")){
    # check whether orig.file exists
    if (!file.exists(orig.file)){
        stop("Could not find input file to skim")
    }
    
    # read full file
    full.file <- read.table(orig.file, 
                            header=TRUE, 
                            sep=";", 
                            quote="", 
                            colClasses="character", 
                            na.strings="?")
    
    # subset file to desired dates
    skimmed.file <- full.file[full.file$Date %in% desired.dates, ]
    
    # convert columns to appropriate type
    skimmed.file[,2] <- as.POSIXct(paste(skimmed.file[,1],skimmed.file[,2]), format="%d/%m/%Y %H:%M:%S")
    skimmed.file[,1] <- as.Date(skimmed.file[,1],"%d/%m/%Y")
    
    for (col.name in 3:9){
        skimmed.file[,col.name] <- as.numeric(skimmed.file[,col.name])        
    }
    
    # Save data.frame in easy format
    saveRDS(skimmed.file, file=out.name)
}

# Plot2
myplot2 <- function(data, ylabel = "Global Active Power (kilowatts)"){
    plot(data[,"Time"], data[,"Global_active_power"]
         , type = "l"
         , xlab = ""
         , ylab = ylabel
         , main = "")
    
}

# Plot3, will also be used for Plot4, bottom left
myplot3 <- function(data, legend.border = "o"){
    plot(data[,"Time"], data[,"Sub_metering_1"]
         , type = "n"
         , xlab = ""
         , ylab = "Energy sub metering"
         , main = ""
    )
    
    lines(data[,"Time"], data[,"Sub_metering_1"]
          , type = "l"
          , col = "black")
    lines(data[,"Time"], data[,"Sub_metering_2"]
          , type = "l"
          , col = "red")
    lines(data[,"Time"], data[,"Sub_metering_3"]
          , type = "l"
          , col = "blue")
    
    legend(x = "topright"
           , legend = c("Sub_metering_1"
                        , "Sub_metering_2"
                        , "Sub_metering_3")
           , lty = 1
           , col = c("black", "red", "blue")
           , bty = legend.border)
}

# Plot4, top right
myplot4.1 <- function(data){
    plot(data[,"Time"], data[,"Voltage"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Voltage"
         , main = ""
    )
}

# Plot4, bottom right
myplot4.2 <- function(data){
    plot(data[,"Time"], data[,"Global_reactive_power"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Global_reactive_power"
         , main = ""
    )
}

check.input <- function(data.input, ...){
    # Check if the processed input exists
    # If not, create it
    if (!file.exists(data.input)){
        print("Input not found, will try to create it")
        tryCatch(skim.file(out.name=data.input, ...)
                 , error = function(e){
                     stop(e, "Did you download the full dataset?")
                 }
        )
    }
}
