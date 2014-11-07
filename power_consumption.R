###############################################################################
## This file contains all the helperfunctions for the course project. 
## 
## Separating things out allows for easy code reuse, which is a standard
## programming practice. By not repeating code pieces, it makes it easier 
## to make changes coherently as there is only one place to make the change. 
## 
## The four plotting scripts will source this file and call the appropriate
## functions. The scripts can be run by themselves by typing e.g.
##     source("plot1.R")
## and the desired plot will be made. The datafile will also be reprocessed  
## if necessary. 
##
## Functions defined in this script: 
##    skim.file(orig.file, out.name, desired.dates) 
##    check.input(data.input, ...)
##    myplot2(data, ylabel)
##    myplot3(data, legend.border)
##    myplot4.1(data)
##    myplot4.2(data)
###############################################################################

## ---------------------------------------------------------------------------
## Function to skim the original big file to keep only those dates we want. 
## This will speed up the subsequent plotting steps. 
## The functions saves the new, smaller, file in a handy format to load back into R. 
## Inputs:    orig.file        # name of the file holding the full dataset
##            out.name         # name for skimmed file
##            desired.dates    # vector of dates to skim on, format=%d/%m/%Y
## ---------------------------------------------------------------------------
skim.file <- function(orig.file = "household_power_consumption.txt"
                      , out.name = "skim.Rda"
                      , desired.dates = c("1/2/2007","2/2/2007")){
    # First check whether orig.file exists.
    if (!file.exists(orig.file)){
        stop("Could not find input file to skim")
    }
    
    # Read the full file.
    # Specify the class of the columns to be "character" to make converting
    # to the desired class easier.
    # Specify that missing values are denoted by "?".
    full.file <- read.table(orig.file, 
                            header=TRUE, 
                            sep=";", 
                            quote="", 
                            colClasses="character", 
                            na.strings="?")
    
    # Subset the file to the desired dates.
    skimmed.file <- full.file[full.file$Date %in% desired.dates, ]
    
    # Convert the columns to the appropriate type.
    # "Time" column should contain the full date and time.
    skimmed.file[,2] <- as.POSIXct(paste(skimmed.file[,1],skimmed.file[,2])
                                   , format="%d/%m/%Y %H:%M:%S")
    # "Date" column should be class Date. 
    skimmed.file[,1] <- as.Date(skimmed.file[,1],"%d/%m/%Y")
    # Other columns should be numeric. 
    for (col.name in 3:9){
        skimmed.file[,col.name] <- as.numeric(skimmed.file[,col.name])        
    }
    
    # Save the data.frame in an easy format.
    saveRDS(skimmed.file, file=out.name)
}

## ---------------------------------------------------------------------------
## Function to check whether the processed input already exists.
## If it does not, this function will create it by calling 
## the skim.file() function defined above.
## Input:    data.input   # name of the input that needs to be read
##           ...          # other options to will passed to skim.file
## Tried out the tryCatch functionality for fun :-) 
## (It is not really necessary)
## ---------------------------------------------------------------------------
check.input <- function(data.input, ...){
    # check if file exists
    if (!file.exists(data.input)){
        print("Input not found, will try to create it")
        
        # Will try to create the input by calling skim.file
        # Will throw an error if the construction fails
        # This could happen if the original dataset was not downloaded
        tryCatch(skim.file(out.name=data.input, ...)
                 , error = function(e){
                     # If skim.file results in error, stop the program,
                     # print out the error, and add a helpful message. 
                     stop(e, "Did you download the full dataset?")
                 }
        )
    }
}

## ---------------------------------------------------------------------------
## Basic plotting code to make plot2.
## This code will be reused for plot4, top left. The only change is the
## ylabel. This will thus be an input to the function. 
## ---------------------------------------------------------------------------
myplot2 <- function(data, ylabel = "Global Active Power (kilowatts)"){
    plot(data[,"Time"], data[,"Global_active_power"]
         , type = "l"
         , xlab = ""
         , ylab = ylabel
         , main = "")    
}

## ---------------------------------------------------------------------------
## Basic plotting code to make plot3.
## Will be reused for Plot4, bottom left. The only change is the border 
## around the legend, which will thus be an input to the function. 
## ---------------------------------------------------------------------------
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
    
    # add the legend
    legend(x = "topright"
           , legend = c("Sub_metering_1"
                        , "Sub_metering_2"
                        , "Sub_metering_3")
           , lty = 1
           , col = c("black", "red", "blue")
           , bty = legend.border)
}

## ---------------------------------------------------------------------------
## Basic plotting code for plot4, top right.
## Added here to keep plot4.R organized. 
## ---------------------------------------------------------------------------
myplot4.1 <- function(data){
    plot(data[,"Time"], data[,"Voltage"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Voltage"
         , main = ""
    )
}

## ---------------------------------------------------------------------------
## Basic plotting code for plot4, bottom right.
## Added here to keep plot4.R organized. 
## ---------------------------------------------------------------------------
myplot4.2 <- function(data){
    plot(data[,"Time"], data[,"Global_reactive_power"]
         , type = "l"
         , xlab = "datetime"
         , ylab = "Global_reactive_power"
         , main = ""
    )
}

