#' A plotting function for  (U-Th)/He data
#'
#' This function will take a tidy dataframe of (U-Th)/He data and make simple plots it
#' @import dplyr
#' @import ggplot2
#' @param hedf tidy dataframe with columns labeled "eU", "Date", "Unc","Color", and "Sample"
#' @param bestfitdf dataframe containing prediction of best fit path from hefty. must have column names equal to "eU" and "Date"
#' @param eUbin value or vector for eU value(s) where bins are split for HeFTy modeling
#' @param facet_vars which variable to facet on, defaults to `Sample`. Currently the only option
#' @param helim limits for the y (He date) axis, must be a vector of 2-defaults to NA which lets ggplot set axis limits
#' @param eUlim limits for the x (eU) axis, must be a vector of 2-defaults to NA which lets ggplot set axis limits
#' @export


plot_date_eu <- function(hedf,bestfitdf=NULL,eUbin=NULL,facet_vars='Sample',helim=c(NA,NA),eUlim=c(NA,NA)){
if(is.null(bestfitdf)){
  bestfitdf<-data.frame(eU=numeric(),
                        Date=numeric())
}
p1=ggplot(hedf)+
  geom_vline(xintercept = eUbin,linetype='dashed',color='grey')+
  geom_line(aes(x=eU,y=Date), data=bestfitdf, alpha=0.6)+
  geom_point(aes(x=eU,y=Date, color=Color),size=2,show.legend = F)+
  geom_errorbar(aes(x = eU, ymax = Date+Unc, ymin = Date-Unc, color=Color), width=0.75,show.legend = F)+
  facet_wrap(facets={{facet_vars}}, ncol=4)+
  scale_color_grey()+
  labs(y='(U-Th)/He Date (Ma)', x='eU (ppm)')+
  coord_cartesian(ylim=helim, xlim=eUlim,expand=T)+
  theme_bw()+
  theme(axis.text = element_text(color='black'),
        axis.line = element_line(color='black'),
        strip.background=element_rect(fill=NA,color=NA),
        strip.text = element_text(color='black', margin=unit(c(0,0,0,0),'npc'))
  )
p1
}

#coord_cartesian(ylim=c(0,210), xlim=c(0,100),expand=T)+
