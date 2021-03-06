% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-mosaic-label.R
\name{geom_mosaic_label}
\alias{geom_mosaic_label}
\title{Labeling for Mosaic plots.}
\usage{
geom_mosaic_label(
  mapping = NULL,
  data = NULL,
  stat = "mosaic",
  position = "identity",
  na.rm = FALSE,
  divider = mosaic(),
  offset = 0.01,
  show.legend = NA,
  inherit.aes = FALSE,
  ...
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[ggplot2:aes]{aes()}} or
\code{\link[ggplot2:aes_]{aes_()}}. If specified and \code{inherit.aes = TRUE} (the
default), it is combined with the default mapping at the top level of the
plot. You must supply \code{mapping} if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[ggplot2:ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[ggplot2:fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{stat}{The statistical transformation to use on the data for this
layer, as a string.}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{na.rm}{If \code{FALSE} (the default), removes missing values with a warning. If \code{TRUE} silently removes missing values.}

\item{divider}{Divider function. The default divider function is mosaic() which will use spines in alternating directions. The four options for partitioning:
\itemize{
\item \code{vspine} Vertical spine partition: width constant, height varies.
\item \code{hspine}  Horizontal spine partition: height constant, width varies.
\item \code{vbar} Vertical bar partition: height constant, width varies.
\item \code{hbar}  Horizontal bar partition: width constant, height varies.
}}

\item{offset}{Set the space between the first spine}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[ggplot2:borders]{borders()}}.}

\item{...}{other arguments passed on to \code{layer}. These are often aesthetics, used to set an aesthetic to a fixed value, like \code{color = 'red'} or \code{size = 3}. They may also be parameters to the paired geom/stat.}
}
\description{
A mosaic plot with labels
}
\examples{
data(titanic)

ggplot(data = titanic) +
  geom_mosaic(aes(x = product(Class), fill = Survived)) +
  geom_mosaic_label(aes(x = product(Class), fill = Survived))

ggplot(data = titanic) +
  geom_mosaic(aes(x = product(Class, Sex),  fill = Survived),
              divider = c("vspine", "hspine", "hspine")) +
  geom_mosaic_label(aes(x = product(Class, Sex), fill = Survived),
              divider = c("vspine", "hspine", "hspine"), size = 2)

ggplot(data = titanic) +
  geom_mosaic(aes(x = product(Class), conds = product(Sex),  fill = Survived),
              divider = c("vspine", "hspine", "hspine")) +
  geom_mosaic_label(aes(x = product(Class), conds = product(Sex), fill = Survived),
              divider = c("vspine", "hspine", "hspine"))
}
