

#' Find Line With String
#' @param fn a filename of HeFTy text file output
#' @param lnstr string to search for
#' @return line number

findline <- function(fn,lnstr){
  fnlines=readLines(fn)
  for(i in 1:length(fnlines)){
    if(grepl(lnstr,fnlines[i])){
      break
    }
  }
  return(list(i,fnlines))
}



#' Read Single Hefty Constraint
#'
#' This reads the hefty constraints and assigns the column names that will be used for plotting
#' @param fn a filename of HeFTy text file output
#' @param smpl sample name for hefty file
#' @return dataframe with constraints

readconstraint <- function(fn,smpl){

  constraint_cols = c('Const_num', 'MaxTime', 'MinTime', 'MaxTemp', 'MinTemp', 'MaxGTime', 'MinGTime','MeanGTime', 'SDGTime', 'MaxGTemp',
                      'MinGTemp', 'MeanGTemp', 'SDGTemp', 'MaxAcTime', 'MinAcTime','MeanAcTime','SDAcTime', 'MaxAcTemp', 'MinAcTemp',
                      'MeanAcTemp', 'SDAcTemp')
  datalines = findline(fn,"Inversion completed")
  i=datalines[[1]]
  fnlines=datalines[[2]]
  constraints = readr::read_tsv(fnlines[2:(i-1)])
  colnames(constraints) <- constraint_cols
  constraints$Sample <- smpl
  return(constraints)
}

#' Read Hefty Constraints
#' @param fn a filename or vector of filenames of HeFTy text file output
#' @param smpl sample name or vector of sample names for a for hefty file
#' @return dataframe with constraints
#' @export
#' @examples
#' fn=system.file("extdata","HeFTyOut-Sample1.txt",package="thermochronplotr")
#' readconstraints(fn)
#' # NOTE: fn should point to your own file on your system

readconstraints <- function(fn, smpl){
  if(length(fn)>1){
    stopifnot(length(fn)==length(smpl))
    purrr::map2_dfr(fn,smpl,.f = function(.x,.y){readconstraint(.x,.y)})
  } else {
    readconstraint(fn,smpl)
  }
}


#' Extract Single Model Time Temp paths
#' @import stringr
#' @import tidyr
#' @import dplyr
#' @import purrr
#' @param fn filename of hefty output
#' @param smpl sample name for hefty file
#' @return dataframe of paths


readpath <- function(fn,smpl){

  datalines = findline(fn,"Weighted mean path")
  i=datalines[[1]]
  fnlines=datalines[[2]]
  timeline = str_split(fnlines[i+1],pattern='\t') %>% unlist()
  templine = str_split(fnlines[i+2],pattern='\t') %>% unlist()
  wmean = tibble("Fit" = "Weighted Mean",
                 "TimeMa"  = timeline[2:length(timeline)],
                 "TempC" = templine[2:length(templine)]) %>%
    mutate(TimeMa = as.numeric(TimeMa),
           TempC = as.numeric(TempC))

  # str_split(fnlines[(i+6)
  allpaths = suppressWarnings(readr::read_tsv(fnlines[(i+6):length(fnlines)]) %>%
                                select(-contains('GOF')))

  ytemp = allpaths %>%
    filter(str_detect(Data,'Temp')) %>%
    select(-Data) %>%
    gather(constraint, TempC, -Fit)
  xtime = allpaths %>%
    filter(str_detect(Data,'Time')) %>%
    select(-Data) %>%
    gather(constraint, TimeMa, -Fit)

  wmean$constraint = unique(xtime$constraint)

  dfplot = full_join(ytemp, xtime, by = c("Fit", "constraint")) %>%
    full_join(wmean, by = c("Fit", "constraint", "TempC", "TimeMa")) %>%
    mutate(Fit_cat = case_when(str_detect(Fit,'Best')~'Best',
                               str_detect(Fit,'Good')~'Good',
                               str_detect(Fit,'Acc')~'Acceptable',
                               str_detect(Fit,'Weighted Mean')~'Weighted Mean'),
           Fit_cat = factor(Fit_cat, levels = c('Acceptable', 'Good','Best', 'Weighted Mean'),ordered = TRUE),
           Fit = case_when(Fit=='Best'~'TheBest',
                           TRUE~Fit))

  dfplot$Sample <- smpl

  return(dfplot)
}



#' Extract Time Temp paths
#' @import stringr
#' @import tidyr
#' @import dplyr
#' @import purrr
#' @param fn filename or vector of filenames of hefty output
#' @param smpl sample name or vector of sample names for hefty file
#' @export
#' @return dataframe of paths

readpaths <- function(fn,smpl){
  if(length(fn)>1){
    stopifnot(length(fn)==length(smpl))
    purrr::map2_dfr(fn,smpl,.f = function(.x,.y){readpath(.x,.y)})

  } else {
    readpath(fn,smpl)
  }

}



