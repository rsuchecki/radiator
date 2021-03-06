% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_hzar.R
\name{write_hzar}
\alias{write_hzar}
\title{Write a HZAR file from a tidy data frame.}
\usage{
write_hzar(data, distances = NULL, filename = NULL,
  parallel.core = parallel::detectCores() - 1)
}
\arguments{
\item{data}{A tidy data frame object in the global environment or
a tidy data frame in wide or long format in the working directory.
\emph{How to get a tidy data frame ?}
Look into \pkg{radiator} \code{\link{tidy_genomic_data}}.}

\item{distances}{(optional) A file with 2 columns, POP_ID The distance information per populations.
With default: \code{distances = NULL}, the column is left empty.}

\item{filename}{(optional) The file name prefix for the HZAR file
written to the working directory. With default: \code{filename = NULL},
the date and time is appended to \code{radiator_hzar_}.}

\item{parallel.core}{(optional) The number of core used for parallel
execution during import.
Default: \code{parallel::detectCores() - 1}.}
}
\value{
A HZAR file is written in the working directory.
}
\description{
Write a HZAR file (Derryberry et al. 2013), from a tidy data frame.
Used internally in
\href{https://github.com/thierrygosselin/radiator}{radiator}
and might be of interest for users.
}
\details{
\emph{Integrated filters:} Only markers found in common between
populations are used and monomorphic markers are automatically removed
before generating HZAR file.
}
\references{
Derryberry EP, Derryberry GE, Maley JM, Brumfield RT.
hzar: hybrid zone analysis using an R software package.
Molecular Ecology Resources. 2013;14: 652-663. doi:10.1111/1755-0998.12209
}
\author{
Thierry Gosselin \email{thierrygosselin@icloud.com}
}
