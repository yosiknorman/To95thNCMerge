# CHP = nc_open("~/Data_riset/CHP20140101_20190930.nc")

library(ncdf4)
# tunits <- ncatt_get(CHP,"time","units")
tunits = "days since 1981-01-01 00:00:00.0 -0:00"

time3 = as.integer(as.Date(gsub(LF, pattern = ".nc", replacement = "")))
nt3 <- length(time3)
# (Matxx)

# ncpath <- "output/"
# ncname <- "JOzz"  
# ncfname <- paste(ncpath, ncname, ".nc", sep="")
# dname <- "PCP"  
NC = nc_open("data/1980/1980-01-01.nc")
fillvalue = NC$var$Precipitation$missval
lon3 = ncvar_get(NC, "longitude")
lat3 = ncvar_get(NC, "latitude")

londim <- ncdim_def("lon","degrees_east",as.double(lon3))
latdim <- ncdim_def("lat","degrees_north",as.double(lat3))
timedim <- ncdim_def("time",tunits,as.double(time3))


lon4 <- lon3
lat4 <- lat3
time4 <- time3
tunits4 <- tunits
nlon3 <- length(lon4); nlat3 <- length(lat4); nt3 <- nt3

# fillvalue <- -1e32
dlname <- "Precipitation"
# tmp_def <- ncvar_def("pcp","MM/Hour",list(lon3,lat3,time3),fillvalue,dname,prec="single")

ncpath <- "output/"
ncname <- "Jozz"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "PCP"  # note: tmp means temperature (not temporary)
# fillvalue <- -3.4e+38
dlname <- "Precipitation"
pcp_def <- ncvar_def("pcp","MM/Hour",list(londim,latdim,timedim),fillvalue,dlname,prec="single")

ncout <- nc_create(ncfname,list(pcp_def),force_v4=TRUE)
ncvar_put(ncout,pcp_def,Matxx)
ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
ncatt_put(ncout,"lat","axis","Y")
ncatt_put(ncout,"time","axis","T")

ncatt_put(ncout,0,"title","JOzz")
ncatt_put(ncout,0,"institution","JOzz")
ncatt_put(ncout,0,"source","JOzz")
ncatt_put(ncout,0,"references","JOzz")
history <- paste("Yosik Norman", date(), sep=", ")
ncatt_put(ncout,0,"history","JOzz")
ncatt_put(ncout,0,"Conventions",":JOzz")

nc_close(ncout)