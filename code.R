# setwd("~/Desktop/HIBAH_AI/FM")
library(raster)
library(ncdf4)

rm(list = ls())

LF=  list.files("data/1980/")
Yea = unique(substr(LF, 1, 4))
BukaPerTahun = function(Yea){
  # Yea = 1980
  LFY = list.files("data/1980/", pattern = as.character(Yea))
  Isi = list()
  for(i in 1:length(LFY)){
    Isi[[i]] = raster(paste0("data/1980/", LFY[i]) )
  }
  R1 = do.call(stack,Isi )
  return(R1)
}

Yeass = list()
for(i in 1:length(Yea)){
  Yeass[[i]] = BukaPerTahun(Yea = Yea[i])
}
YeassR = do.call(stack, Yeass)
Vxpcp = as.numeric(as.matrix(YeassR))
q95 = quantile(Vxpcp, 0.95)

dibalikcuy = function(X){
  t(apply(as.matrix(X), 2, FUN = rev))
}

Filter95 = function(X) {
  DataJadi = YeassR[[X]]
  dibalik = t(apply(as.matrix(YeassR[[X]]), 2, FUN = rev))
  dibalik[dibalik <= q95] = NA
  Hasil = raster(apply(dibalik, 1, FUN = rev))
  extent(Hasil) = extent(DataJadi)
  crs(Hasil) = crs(DataJadi)
  return(Hasil)
}


Data_Hasil95 = list()
for(i in 1:dim(YeassR)[3]){
  Data_Hasil95[[i]] = Filter95(i)
}
Data_Hasil95Stack = do.call(stack, Data_Hasil95)

Matxx = array(0, dim = c(dim(Data_Hasil95Stack)[2], 
                         dim(Data_Hasil95Stack)[1],
                         dim(Data_Hasil95Stack)[3]))
for(i in 1:dim(Data_Hasil95Stack)[3]){
  Matxx[,,i] = apply(dibalikcuy(dibalikcuy(dibalikcuy(Data_Hasil95Stack[[i]]))), 2, FUN = rev)
  # Matxx[,,i] = dibalikcuy(Matxx[,,i])
}

source("ToNc.R")
# Contekan https://pjbartlein.github.io/REarthSysSci/netCDF.html
