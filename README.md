
<!-- README.md is generated from README.Rmd. Please edit that file -->

# thermochronplotr

<!-- badges: start -->

<!-- badges: end -->

The goal of thermochronplotr is to make several commonly used plots for
low temperature thermochronology, particularly apatite (U-Th)/He
thermochronology, from data files. Ideally this makes plotting more
streamlined, while giving the user the option to customize aesthetics
using the wide range of tools in the ggplot2 package.

There several functios which import the text files output by the thermal
history modelling software HeFTy at the end of an inverse model run and
plots them as a single panel (for one model) or a faceted grid (for
multiple models)

Future versions will have tools to make date-eU plots from the AHe data
and plot these as a shuffled grid with HeFTy models

## Installation

This package is only available on github. To install this please install
`devtools` package within R. Then:

``` r
devtools::install_github('jstanley26/thermochronplotr')
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(thermochronplotr)
#> Loading required package: rlang
```

### Single HeFTy inversion plot

For a single inversion model using the example file (replace with your
own when
ready)

``` r
fn=system.file("extdata","HeFTyOut-Sample1.txt",package="thermochronplotr")
samplename = 'Sample 1'
cons = readconstraints(fn,samplename)
dfplot = readpaths(fn,samplename)
plot1 = plot_hefty_output(dfplot, cons)
plot1
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

`plot1` is a `ggplot2` opject, and can be customized accordingly. For
example, if you want to change the x axis limits

``` r
library(ggplot2)
plot1+coord_cartesian(xlim=c(200,0))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

### Multiple HeFTy inversion facet

To plot the results from multple inversions, for example from more than
one sample, you need to create a vector of the file names, and a
coresponding vector of the sample names (in the same
order)

``` r
fn=system.file("extdata","HeFTyOut-Sample1.txt",package="thermochronplotr")
samplename = 'Sample 1'
fn2=system.file("extdata","HeFTyOut-Sample2.txt",package="thermochronplotr")
samplename2 = 'Sample 2'

fns = c(fn, fn2)
sns = c(samplename,samplename2)

cons2 = readconstraints(fns,sns)
dfplot2 = readpaths(fns,sns)
plot2 = plot_hefty_output(dfplot2, cons2)
plot2
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

Again, `plot2` is a `ggplot` object and can be customized
