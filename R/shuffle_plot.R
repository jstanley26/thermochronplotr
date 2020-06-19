#' A function to plot HeFTy and date-eU plots side by side (shuffled)
#'
#' This function will take a tidy dataframe of (U-Th)/He data and make simple plots it
#' @import dplyr
#' @import ggplot2
#' @import cowplot
#' @param hedf tidy dataframe with (U-Th)/He data and columns labeled "eU", "Date", "Unc", "Color", "Sample", "Description", "Elevation_m"
#' @param bestfitdf dataframe containing prediction of best fit path from hefty. must have column names equal to "eU", "Date",and "Sample"
#' @param heftydf tidy dataframe extracted from HeFTy paths extracted with `readpaths()`
#' @param constraints dataframe with HeFTy constraints extracted with `readconstraints()`
#' @param eUbin value or vector for eU value(s) where bins are split for HeFTy modeling
#' @export
#' @examples
#' fn=system.file("extdata","AHe_data.csv",package="thermochronplotr")
#' hedf<-readr::read_csv(fn)
#' fn2=system.file("extdata","ForwardModels.csv",package="thermochronplotr")
#' bestfitdf <- readr::read_csv(fn2)
#' fn3 = system.file("extdata","HeFTyOut-Sample1",package="thermochronplotr")
#' fn4 = system.file("extdata","HeFTyOut-Sample2",package="thermochronplotr")
#' heftydf<-readpaths(c(fn3,fn4),c('Sample1','Sample2'))
#' constraints<-readconstraints(c(fn3,fn4),c('Sample1','Sample2'))
#' shuffle_plots(ahe,forward,hefty,constraints,eUbin = 15)

shuffle_plots<-function(hedf, bestfitdf,heftydf,constraints,eUbin=NULL){
#initiate
plotlist=list()
i=1
allsamples=unique(hedf$Sample)
s=allsamples[4]
for(s in allsamples){

  p1df1 = hedf %>% filter(!!s == Sample)
  p1df2 = bestfitdf %>% filter(!!s == Sample)

  p1=plot_date_eu(p1df1,p1df2, eUbin)

  p2df1 = heftydf %>% filter(!!s == Sample)
  p2df2 = constraints %>% filter(!!s == Sample)

  p2=plot_hefty_output(p2df1,p2df2)

  labeldf = p1df1 %>% distinct(Sample, Description, Elevation_m)
  plotlabel=paste(paste(labeldf[1],labeldf[2],sep=': '),labeldf[3],sep=', ')
  plot=plot_grid(p1+theme(legend.position='none'),p2+theme(legend.position='none'),
                 align='hv',
                 axis='tb'
  )

  title.grob <- grid::textGrob(plotlabel,
                         gp=grid::gpar(fontface="bold", col="black", fontsize=8))

  plotlist[[i]] <- plot_grid(title.grob,plot,
                             rel_heights = c(1,10),
                             nrow=2,
                             labels = LETTERS[i],
                             vjust=1.1)

  i=i+1
}


thefigure <- plot_grid(plotlist = plotlist,ncol=2)
thelegend2 <- plot_grid(get_legend(p2))
thebigfig <- plot_grid(thefigure,
                        thelegend2,
                        # get_legend(p2),
                        # get_legend(p1),
                        rel_heights=c(20,1),
                        nrow=2)
thebigfig

}
