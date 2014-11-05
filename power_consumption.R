##############################################
## All helperfunctions for course project 1
##############################################

## Skim original big file to only those dates we want. 
## This will speed up the subsequent plotting steps. 
## Save new file in handy format to load back into R. 
## Inputs:    orig.file        # name of the file holding the full dataset
##            out.name         # name for skimmed file
##            desired.dates    # vector of dates to skim on, format=%d/%m/%Y
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
    skimmed.file[,2] <- as.POSIXct(paste(skimmed.file[,1],skimmed.file[,2])
                                   , format="%d/%m/%Y %H:%M:%S")
    skimmed.file[,1] <- as.Date(skimmed.file[,1],"%d/%m/%Y")
    
    for (col.name in 3:9){
        skimmed.file[,col.name] <- as.numeric(skimmed.file[,col.name])        
    }
    
    # Save data.frame in easy format
    saveRDS(skimmed.file, file=out.name)
}

## Code to make plot2
## Will be reused for plot4, top left
myplot2 <- function(data, ylabel = "Global Active Power (kilowatts)"){
    plot(data[,"Time"], data[,"Global_active_power"]
         , type = "l"
         , xlab = ""
         , ylab = ylabel
         , main = "")
    
}

## Code to make plot3
## Will be reused for Plot4, bottom left
myplot3 <- function(data, legend.border = "o"){
    # create the plot without drawing the data
    plot(data[,"Time"], data[,"Sub_metering_1"]
         , type = "n"
         , xlab = ""
         , ylab = "Energy sub metering"
         , main = ""
    )
    
    # add the data as lines
    lines(data[,"Time"], data[,"Sub_metering_1"]
          , col = "black")
    lines(data[,"Time"], data[,"Sub_metering_2"]
          , col = "red")
    lines(data[,"Time"], data[,"Sub_metering_3"]
          , col = "blue")
    
    # add a legend
    legend(x = "topright"
           , legend = c("Sub_metering_1"
                        , "Sub_metering_2"
                        , "Sub_metering_3")
           , lty = 1
           , col = c("black", "red", "blue")
           , bty = legend.border)
}

## Code for plot4, top right
myplot4.1 <- function(data){
    plot(data[,"Time"], data[,"Voltage"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Voltage"
         , main = ""
    )
}

## Code for plot4, bottom right
myplot4.2 <- function(data){
    plot(data[,"Time"], data[,"Global_reactive_power"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Global_reactive_power"
         , main = ""
    )
}

## Function to check whether the processed input exists.
## If not, create it.
## Input:    data.input   # name of the input that needs to be read
##           ...          # other options to be passed to skim.file
## Tried out the tryCatch functionality for fun :-)
check.input <- function(data.input, ...){
    # check if file exists
    if (!file.exists(data.input)){
        print("Input not found, will try to create it")

        # Will try to create the input by calling skim.file
        # Will throw an error if the construction fails
        tryCatch(skim.file(out.name=data.input, ...)
                 , error = function(e){
                     stop(e, "Did you download the full dataset?")
                 }
        )
    }
}
