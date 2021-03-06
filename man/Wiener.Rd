% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Wiener.R
\name{Wiener}
\alias{Wiener}
\title{Simulate standard Wiener processes (Brownian motions)}
\usage{
Wiener(n = 1, pts = seq(0, 1, length = 50), sparsify = NULL,
  K = 50)
}
\arguments{
\item{n}{Sample size.}

\item{pts}{A vector of points in [0, 1] specifying the support of the processes.}

\item{sparsify}{A vector of integers. The number of observations per curve will be uniform distribution on sparsify.}

\item{K}{The number of components.}
}
\value{
If \code{sparsify} is not specified, a matrix with \code{n} rows corresponding to the samples are returned. Otherwise the sparsified sample is returned.
}
\description{
Simulate \code{n} standard Wiener processes on [0, 1], possibly
sparsifying the results.
}
\details{
The algorithm is based on Karhunen-Loeve expansion.
}
\seealso{
Sparsify
}
