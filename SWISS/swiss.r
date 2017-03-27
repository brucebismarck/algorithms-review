################
# This algorithm is used to tell clustering performance


swiss = function(dat, class){
  # @ dat: data matrix, rows are samples and columns are features
  # @ class: class label of samples 
  group = unique(class)
  gpairs = combn(group,2)
  n = dim(gpairs)[2]
  sw = NULL
  if(is.null(n)){
    g1 = gpairs[1]
    g2 = gpairs[2]
    c1 = as.matrix(dat[which(class == g1),])
    c2 = as.matrix(dat[which(class == g2),])
    c = rbind(c1, c2)
    
    sc1 = scale(c1, center = T, scale = F)
    sc2 = scale(c2, center = T, scale = F)
    sc  = scale(c, center = T, scale = F)
    sw = (norm(sc1,"F")^2 + norm(sc2,"F")^2)/norm(sc,"F")^2
  }else{
    for(i in 1:n){
      g1 = gpairs[1,i]
      g2 = gpairs[2,i]
      c1 = as.matrix(dat[which(class == g1),])
      c2 = as.matrix(dat[which(class == g2),])
      c = rbind(c1, c2)
      
      sc1 = scale(c1, center = T, scale = F)
      sc2 = scale(c2, center = T, scale = F)
      sc  = scale(c, center = T, scale = F)
      sw[i] = (norm(sc1,"F")^2 + norm(sc2,"F")^2)/norm(sc,"F")^2
    }
  }
  
  return(mean(sw))
}
