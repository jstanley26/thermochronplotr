

#' A plotting function for single HeFTy inversions
#'
#' This function will take a tidy dataframe made from the text file output of a HeFTy inversion and plot it
#' @import dplyr
#' @import ggplot2
#' @param dF tidy dataframe extracted from HeFTy paths extracted with `readpaths()`
#' @param constraints dataframe with HeFTy constraints extracted with `readconstraints()`
#' @param facet_vars which variable to facet on, defaults to `Sample`. Currently the only option
#' @export
#' @examples
#' HeFTySinglePlot()
plot_hefty_output <- function(dF,constraints,facet_vars='Sample'){
  constraints2 <-  constraints %>% semi_join(dF, by='Sample')
  p2=dF %>%
    ggplot()+
    geom_path(aes(x=TimeMa,y=TempC,color=Fit_cat,group=Fit))+
    geom_rect(aes(xmin=MinTime, ymin=MinTemp, xmax=MaxTime, ymax=MaxTemp, group=Const_num), data=constraints2, fill=NA, linetype='dashed', color='black')+
    facet_wrap(facets={{facet_vars}}, ncol=4)+
    scale_color_grey(start=0.8, end=.2)+
    labs(y='Temp (C)', x='Time (Ma)', title='HeFTy Time-Temp Paths')+
    theme_linedraw()+
    guides(color=guide_legend(title='Model Fit'))+
    theme(strip.background=element_rect(fill=NA,color=NA),
          strip.text = element_text(color='black', margin=unit(c(0,0,0,0),'npc')),
          legend.key=element_rect(fill=NA, color=NA),
          legend.position='bottom'
    )+
    scale_x_reverse()+
    scale_y_reverse()
    p2
  return(p2)
}


