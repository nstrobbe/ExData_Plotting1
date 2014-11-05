###############################################################################
## Define the plot routine.
## Input is a properly converted data file.
## If that file doesn't exist, the function will try to create it.
## If the source file is not called "household_power_consumption.txt", 
## you can specify the correct name by passing orig.file = <correct name> 
## to the plot function, and it will get passed along to the reader function.
###############################################################################
plot2 <- function(data.input = "skim.Rda", ...){
    # Load file with main code
    source("power_consumption.R")
    
    # Check if the processed input exists
    # If not, create it
    check.input(data.input, ...)

    # Read in properly formatted data
    data <- readRDS(data.input)
    
    # make the plot
    png(filename = "plot2.png"
        , width = 480
        , height = 480
        , bg = "transparent")

    myplot2(data)
    
    dev.off()
}

############################################################
## Now actually execute the plot routine.
## This way the plot gets made when this script is sourced.
## Default values should be ok.
############################################################
plot2()
