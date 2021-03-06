% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FPCReg.R
\name{FPCReg}
\alias{FPCReg}
\title{Function for performing functonal linear regression where the covariates are functions X1(t1),X2(t2),.. and the response is a function Y(t_y).}
\usage{
FPCReg(vars, varsOptns = NULL, isNewSub = NULL, method = "AIC",
  FVEthreshold = 0.99, alpha = 0.05, Kx = NULL)
}
\arguments{
\item{vars}{A list of input functional covariates with name of "X1", "X2",.. and a functional response with name "Y". Each field should have two fields: 'Lt', a list (sparse) or a matrix (Dense) specifying the time of observations, and 'Ly', a list (Sparse) or a matrix (Dense) of the observations.}

\item{varsOptns}{A list of options named by "X1", "X2",..."Y". Each filed specify the paramaters that control the corresponding variables. (default: see details of FPCA())}

\item{isNewSub}{A 1*n vector of 0s or 1s, where n is the total count of subjects. 0 denotes the corresponding subject is only used for estimation and 1 denotes the corresponding subject is only used for prediction. (default: 0's)}

\item{method}{The method used for selecting the number of principal components of functional predictors X's used in functional regression , including 'AIC', 'BIC' and 'FVE'. (default: "AIC")}

\item{FVEthreshold}{A scalar specifying the proportion used for 'FVE'. (default: 0.99)}

\item{alpha}{A scalar specifying the level of the confidence bands. (default: 0.05)}

\item{Kx}{The number of principal components of functional predictors X's used in functional regression.}
}
\value{
A list containing the following fields:
\item{estiBeta}{A list with fields of estimated beta_XiY(s,t) defiend on [range(Xi),range(Y)]}
\item{predictY}{A list containing fitted or predicted (when is NewSub is true) functions for E(Y|X).}
\item{cbandY}{A list with confidence bands of E(Y|X).}
\item{Q}{Quasi R-square}
\item{r2}{Functional R-square.}
\item{varsMean}{A list with mean function of covariates and response.}
\item{Kx}{The number of principal components of functional predictors X's used in functional regression.}
}
\description{
Function for performing functonal linear regression where the covariates are functions X1(t1),X2(t2),.. and the response is a function Y(t_y).
}
\examples{
set.seed(1000)
#Model: E(Y(t)|X) = int(beta(s,t)*X(s))
n <- 200 #number of subjects
ngrids <- 51 #number of grids in [0,1] for X(s)
ngridt <- 101 #number of grids in [0,1] for Y(t)
grids <- seq(0, 1, length.out=ngrids) #regular grids in [0,1] for X(s)
gridt <- seq(0, 1, length.out=ngridt) #regular grids in [0,1] for Y(t)

#generate X
#{1, sqrt(2)*sin(2*pi*s), sqrt(2)*cos(2*pi*t)} are used to generate X.
eigenFun <- list( function(s){1 + 0 * s}, 
                  function(s){sqrt(2) * sin(2*pi*s)},
                  function(s){sqrt(2) * cos(2*pi*s)})

sig <- matrix(c(1.5, 0.0, 0.0, 0.9, -.5, 0.1,
                0.0, 1.2, 0.0, -.3, 0.8, 0.4,
                0.0, 0.0, 1.0, 0.4, -.3, 0.7,
                0.9, -.3, 0.4, 2.0, 0.0, 0.0,
                -.5, 0.8, -.3, 0.0, 1.5, 0.0,
                0.1, 0.4, 0.7, 0.0, 0.0, 1.0),
                nrow=6,ncol=6)

scoreX <- MASS::mvrnorm(n,mu=rep(0,6),Sigma=sig)
scoreX1 <- scoreX[,1:3]
scoreX2 <- scoreX[,4:6]

basisX1 <- sapply(eigenFun,function(x){x(grids)})
latentX1 <- scoreX1 \%*\% t(basisX1)
measErrX1 <- sqrt(0.03) * matrix(rnorm(n * ngrids), n, ngrids) #0.01 is sigma^2.
denseX1 <- latentX1 + measErrX1

basisX2 <- sapply(eigenFun,function(x){x(grids)})
latentX2 <- scoreX2 \%*\% t(basisX2)
measErrX2 <- sqrt(0.03) * matrix(rnorm(n * ngrids), n, ngrids) #0.01 is sigma^2.
denseX2 <- latentX2 + measErrX2

#generate Y
#beta(s, t) <- sin(2 * pi * s)*cos(2 * pi * t)
betaEigen1 <- function(t){f <- function(s){
                            sin(2*pi*s) * cos(2*pi*t) * (1+0*s)}; return(f)}
betaEigen2 <- function(t){f <- function(s){
                            sin(2*pi*s) * cos(2*pi*t) * (sqrt(2)*sin(2*pi*s))}; return(f)}
betaEigen3 <- function(t){f <- function(s){
                            sin(2*pi*s) * cos(2*pi*t) * (sqrt(2)*cos(2*pi*s))}; return(f)}
betaEigen <- list(betaEigen1, betaEigen2, betaEigen3) 
basisY <- array(0,c(ngridt, 3))
for(i in 1:3){
	intbetaEigen <- function (t) {integrate(betaEigen[[i]](t), lower = 0, upper = 1)$value}
	basisY[, i] <- sapply(1:ngridt, function(x){intbetaEigen(gridt[x])})
	}
latentY <- scoreX1 \%*\% t(basisY) - scoreX2 \%*\% t(basisY)
measErrY <- sqrt(0.01) * matrix(rnorm(n*ngridt), n, ngridt) #0.01 is sigma^2
denseY <- latentY + measErrY

#======Dense data===============================================
timeX <- t(matrix(rep(grids, n),length(grids), n))
timeY <- t(matrix(rep(gridt, n),length(gridt), n))
denseVars <- list(X1 = list(Ly = denseX1, Lt = timeX),
                  X2 = list(Ly = denseX2, Lt = timeX),
                  Y=list(Ly = denseY,Lt = timeY))

resuDense <- FPCReg(denseVars, method="FVE") 

par(mfrow=c(1,2))
estiBetaX1Y_Dense <- resuDense$estiBeta$betaX1Y
args1 <- list(xlab = 's', ylab = 't', zlab = 'estiBetaX1Y_Dense(s, t)',
              lighting = FALSE, phi = 45, theta = 45)
args2 <- list(x = 1:ngrids, y = 1:ngridt, z = estiBetaX1Y_Dense[1:ngrids, 1:ngridt])
do.call(plot3D::persp3D,c(args2, args1))

estiBetaX2Y_Dense <- resuDense$estiBeta$betaX2Y
args1 <- list(xlab = 's', ylab = 't', zlab = 'estiBetaX2Y_Dense(s, t)',
             lighting = FALSE, phi = 45, theta = 45)
args2 <- list(x = 1:ngrids, y = 1:ngridt, z = estiBetaX2Y_Dense[1:ngrids, 1:ngridt])
 # do.call(plot3D::persp3D,c(args2, args1))

#======Sparse data===============================================
\dontrun{
sparsity = 5:8
sparseX1 <- Sparsify(denseX1, grids, sparsity)
sparseX2 <- Sparsify(denseX2, grids, sparsity)
sparseY <- Sparsify(denseY, gridt, sparsity)
sparseVars <- list(X1 = sparseX1, X2 = sparseX2, Y = sparseY)

resuSparse <- FPCReg(sparseVars, method="FVE", FVEthreshold=0.98) 
#or resuSparse <- FPCReg(vars = sparseVars,
#                        varsOptns = list(X1=list(userBwCov = 0.03)))

par(mfrow=c(1,2))
estiBetaX1Y_Sparse = resuSparse$estiBeta$betaX1Y
args1 = list(xlab = 's', ylab = 't', zlab = 'estiBetaX1Y_Sparse(s,t)', 
             lighting = FALSE, phi = 45,theta = 45)
args2 = list(x = 1:51, y = 1:51, z = estiBetaX1Y_Sparse[1:51, 1:51])
do.call(plot3D::persp3D, c(args2, args1))

estiBetaX2Y_Sparse = resuSparse$estiBeta$betaX2Y
args1 = list(xlab = 's', ylab = 't', zlab = 'estiBetaX2Y_Sparse(s,t)', 
             lighting = FALSE, phi = 45,theta = 45)
args2 = list(x = 1:51, y = 1:51, z = estiBetaX2Y_Sparse[1:51, 1:51])
do.call(plot3D::persp3D, c(args2, args1))

par(mfrow=c(2,3))
for(i in 1:6){
	plot(sparseVars[['Y']]$Lt[[i]], sparseVars[['Y']]$Ly[[i]], 
	xlab = 'time', ylab = 'observations', ylim = c(-1.5, 1.5))
	lines(seq(0, 1, length.out = 51), resuSparse$predictY[[i]])
	lines(seq(0, 1, length.out = 51), resuSparse$cbandY[[i]][,2], lty = 2)
	lines(seq(0, 1, length.out = 51), resuSparse$cbandY[[i]][,1], lty = 2)
	}
	}
}
\references{
\cite{Yao, F., Mueller, H.G., Wang, J.L. "Functional Linear Regression Analysis for Longitudinal Data." Annals of Statistics 33, (2005): 2873-2903.}
}
