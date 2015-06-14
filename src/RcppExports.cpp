// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppEigen.h>
#include <Rcpp.h>

using namespace Rcpp;

// Rmullwlsk
Eigen::MatrixXd Rmullwlsk(const Eigen::Map<Eigen::VectorXd>& bw, const std::string kernel_type, const Eigen::Map<Eigen::MatrixXd>& tPairs, const Eigen::Map<Eigen::MatrixXd>& cxxn, const Eigen::Map<Eigen::VectorXd>& win, const Eigen::Map<Eigen::VectorXd>& xgrid, const Eigen::Map<Eigen::VectorXd>& ygrid);
RcppExport SEXP tPACE_Rmullwlsk(SEXP bwSEXP, SEXP kernel_typeSEXP, SEXP tPairsSEXP, SEXP cxxnSEXP, SEXP winSEXP, SEXP xgridSEXP, SEXP ygridSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::VectorXd>& >::type bw(bwSEXP);
    Rcpp::traits::input_parameter< const std::string >::type kernel_type(kernel_typeSEXP);
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::MatrixXd>& >::type tPairs(tPairsSEXP);
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::MatrixXd>& >::type cxxn(cxxnSEXP);
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::VectorXd>& >::type win(winSEXP);
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::VectorXd>& >::type xgrid(xgridSEXP);
    Rcpp::traits::input_parameter< const Eigen::Map<Eigen::VectorXd>& >::type ygrid(ygridSEXP);
    __result = Rcpp::wrap(Rmullwlsk(bw, kernel_type, tPairs, cxxn, win, xgrid, ygrid));
    return __result;
END_RCPP
}
