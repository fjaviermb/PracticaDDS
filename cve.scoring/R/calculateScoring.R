calculateScoring <-
function(computers.entries.cves, computers.entries.criticity, cache=FALSE,use_simulation=FALSE) {

  
  if( cache ) {
    
    computers.entries.scoring <- loadCacheScoring()
  
  } else if(use_simulation) {
    
    computers.entries.scoring <- loadScoringTesting()
    
  } else {
    
    computers.entries.scoring <- computers.entries.cves
    
    # Get the most cvss score
    computers.entries.scoring <- computers.entries.cves %>% group_by(computer) %>% arrange(desc(cvss)) %>% slice(1) %>% ungroup
    
    # Join criticity
    computers.entries.scoring <- left_join(computers.entries.scoring,computers.entries.criticity,by="computer")
    
    #names(computers.entries.cves) <- c("name","version","vendor","comuper","cve","cvss","criticidad")
    
    # Add default cvsse as cvss  
    computers.entries.scoring$cvsse <- sapply(computers.entries.scoring$cvss, function(cvss) return(cvss) )
    computers.entries.scoring$cvsse <- as.numeric(computers.entries.scoring$cvsse)
    
    #for( j in 1:nrow(computers.entries.scoring) ) {
    #  if( computers.entries.scoring['criticidad'][j] > 0) {
    #    computers.entries.scoring['cvsse'][j] <-  computers.entries.scoring['cvsse'][j] + 2
    #  }
    #  j <- j+1
    #}
    
    # Set critical cvss
    for( j in 1:nrow(computers.entries.scoring) ) {
      if( computers.entries.scoring['criticidad'][[1]][j] > 0) {
        computers.entries.scoring['cvsse'][[1]][j] <-  computers.entries.scoring['cvsse'][[1]][j] + 2
      }
      j <- j+1
    }
    computers.entries.scoring$nivel <- sapply(computers.entries.scoring$cvss, function(cvss) setNivel(cvss) )
    
    # Set criticity level
    computers.entries.scoring$nivele <- sapply(computers.entries.scoring$cvsse, function(cvss) setNivel(cvss) )  
    
  }
  
 
  return(computers.entries.scoring)
}
