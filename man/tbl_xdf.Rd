% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tbl_xdf.R
\name{tbl_xdf}
\alias{tbl_xdf}
\title{Generate tbl_xdf data source object}
\usage{
tbl_xdf(xdf = NULL, file = NULL, createCompositeSet = NULL,
  fileSystem = rxGetFileSystem(xdf), ...)
}
\arguments{
\item{xdf}{A \code{\link{RxXdfData}} data source on which to base the tbl_xdf. If supplied, the parameters for the returned object, such as the filesystem and composite flag, will be based on this.}

\item{file}{The filename to use for the tbl_xdf -- this is the \emph{output} filename to use when writing the data. By default, a random filename is generated.}

\item{createCompositeSet}{Whether to create a composite Xdf file (see below).}

\item{fileSystem}{The filesystem in which to save the Xdf file.}

\item{...}{Further arguments passed to \code{RxXdfData}.}
}
\value{
An object of S4 class \code{tbl_xdf}, which inherits from \code{RxXdfData}.
}
\description{
Generate tbl_xdf data source object
}
\details{
dplyrXdf uses the tbl_xdf class as part of its file management tasks. A tbl_xdf object specifies the file to which a dplyrXdf verb will save its output, and from which the next verb in a pipeline will read its input.

Like an RxXdfData object, a tbl_xdf object is a pointer to a file on disk that stores the actual data. A tbl_xdf also includes information on whether the file was generated as part of a pipeline; if so, subsequent verbs will know to delete the file when they return. This way, only the final output of a pipeline is retained.

In general, you should never need to create a tbl_xdf object manually.

Since a tbl_xdf is an RxXdfData object, all RevoScaleR functions that can work with Xdf files should also work with tbl_xdf's. For example, you can pass the output from a dplyrXdf pipeline straight to a RevoScaleR or MicrosoftML modelling function like \code{rxLinMod} or \code{rxNeuralNet}. If you encounter code that only works with base RxXdfData objects (eg if it uses checks like \code{if(class(obj) == "RxXdfData") \{...\}}), you can strip off the tbl information with \code{as_xdf(obj)}. See the examples below.
}
\section{Note on composite Xdf}{

There are actually two kinds of Xdf files: standard and \emph{composite}. A composite Xdf file is a directory containing multiple data and metadata files, which the RevoScaleR functions treat as a single dataset. While Xdf files in the native filesystem can be in either format, those in HDFS must be composite.
}

\examples{
tbl_xdf()

# create an Xdf data source, and base a tbl_xdf object on it
xdf <- RxXdfData("file", createCompositeSet=TRUE)
tbl_xdf(xdf)

\dontrun{
# create a tbl_xdf in HDFS
tbl_xdf(fileSystem=RxHdfsFileSystem())
}

# example of code that requires a base RxXdfData object
my_model <- function(data, formula)
{
    if(class(data) != "RxXdfData")
        stop("must supply Xdf data source") 
    rxLinMod(formula, data=data)
}
mtx <- as_xdf(mtcars, overwrite=TRUE)
tbl <- select(mtx, mpg, wt, disp)
\dontrun{
# this will fail
my_model(tbl, mpg ~ wt + disp)
}
# use as_xdf() to convert back to RxXdfData
my_model(as_xdf(tbl), mpg ~ wt + disp)
}
\seealso{
\code{\link{RxXdfData}}, \code{\link{as_xdf}}
}
