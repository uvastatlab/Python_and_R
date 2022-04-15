# Consultation Summary: detrending data


# Demonstrate detrending --------------------------------------------------

# BJsales: example data that comes with R.
# I have no idea what BJsales is other than sales data over time.

# Load into memory
data(BJsales)

# First 6 observations; sales volume? idk...
head(BJsales)

# Notice the class is "ts"; this stands for time series.
class(BJsales)

# plot() will automatically plot a time series
plot(BJsales)

# Let's fit a smooth spline to the data; basically a non-linear model;
# the df argument specifies "wiggliness" of the line. 
# Bigger values --> more wiggle; I thought 10 was good.
s <- smooth.spline(BJsales, df = 10)

# add the smooth line to the plot;
# The smooth line captures the basic shape of the sales data over time.
lines(s, col = "blue")

# The y values of the blue line are in the `y` component of the fitted model
# object. We'll use this below in the consultation.
head(s$y)

# The residuals are the detrended data.
# Residuals = observed data - predicted data
# Residuals = black line - blue line
# plot "detrended" data
plot(residuals(s), type = "l")

# without the trend we see the sales fluctuations range from about -4 to 4; 
# that information is hard to see in the original plot due to the trend.


# The consultation request ------------------------------------------------

# Here is the data from the consultation as an Rds file. To read the file in, be
# sure to set your working directory to wherever you saved the file.
# Session...Set Working Directory...Choose Directory...
d <- readRDS("dat.Rds")

# They want to detrend the following variables by "bearing", which is basically an identifier: "tmean", "tmin", "snow_cover", "ppt", "spread_1"

# Here's tmain by bearing
library(ggplot2)
ggplot(d) +
  aes(x = year_t, y = tmean) +
  geom_line() +
  facet_wrap(~bearing)

# They want to detrend each of the 48 time series. It's not clear to me this data needs to be detrended, but that's not my call.

# Here's how I carried out the request using a for loop.
# Loop over the var names.
for(i in c("tmean", "tmin", "snow_cover", "ppt", "spread_1")){
  
  # split i_th var by bearing into a list 
  li <- split(d[,i], f = d$bearing)  
  
  # apply spline to each element of list li using df = 4
  s <- lapply(li, smooth.spline, df = 4)
  
  # apply `$y` to each element of s to extract fitted values.
  # Then unlist() into a single vector
  y <- unlist(lapply(s, function(x)x$y))
  
  # apply residuals to each element of s to get residuals (detrended data).
  # Then unlist() into a single vector
  r <- unlist(lapply(s, residuals))
  
  # add i_th fitted values to data frame using name "spline_i", 
  # where i = var name (eg, "spline_tmean")
  d[[paste0("spline_",i)]] <- y
  
  # add residuals to data frame using name "dt_i",
  # where i = var name (eg, "dt_tmean")
  d[[paste0("dt_",i)]] <- r
}

# plot both observed and fitted lines for "tmean":
ggplot(d) +
  geom_line(aes(x = year_t, y = tmean, color = "raw")) +
  geom_line(aes(x = year_t, y = spline_tmean, color = "spline")) +
  facet_wrap(~bearing)

# Plot detrended data for "tmean"
ggplot(d) +
  geom_line(aes(x = year_t, y = dt_tmean)) +
  facet_wrap(~bearing)

# The detrended data looks a lot like the raw data, at least for "tmean", which
# makes me question why this was necessary. However I'm happy I could help her
# and I thought it demonstrated some interesting concepts in R.

# And no I don't know what this data is for! :) 
# I think it's for trees.