# R equal rights code for SCOTUS ruling on June 26th, 2015

library("ggplot2", lib.loc = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

ggplot(data.frame(x = 1:7), aes(x = 1, y = x, fill = x))
	+ geom_raster()
	+ scale_fill_gradientn(colours=rainbow(7))