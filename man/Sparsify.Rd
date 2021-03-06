% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sparsify.R
\name{Sparsify}
\alias{Sparsify}
\title{Sparsify densely observed functional data}
\usage{
Sparsify(samp, pts, sparsity, aggressive = FALSE, fragment = FALSE)
}
\arguments{
\item{samp}{A matrix of densely observed functional data, with each row containing one sample.}

\item{pts}{A vector of grid points corresponding to the columns of \code{samp}.}

\item{sparsity}{A vector of integers. The number of observation per sample is chosen to be one of the elements in sparsity with equal chance.}

\item{aggressive}{Sparsify in an "aggressive" manner making sure that near-by readings are excluded.}

\item{fragment}{Sparsify the observations into fragments, which are (almost) uniformly distributed in the time domain. Default to FALSE as not fragmenting. Otherwise a positive number specifying the approximate length of each fragment.}
}
\value{
A list of length 2, containing the following fields:
\item{Lt}{A list of observation time points for each sample.}
\item{Ly}{A list of values for each sample, corresponding to the time points.}
}
\description{
Given a matrix of densely observed functional data, make a sparsified sample.
}
