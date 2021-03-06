#' Titration Curve for Diprotic Weak Base
#' 
#' This function calculates and plots the titration curve for a 
#' diprotic weak base analyte using a monoprotic strong acid as 
#' the titrant. The calculation uses a single master equation
#' that finds the volume of titrant needed to achieve a fixed pH, 
#' as outlined in R. de Levie's \emph{Principles of Quantitative 
#' Chemical Analysis} (McGraw-Hill, 1997).
#' 
#' @param conc.base Molar concentration of the diprotic weak base 
#' analyte; defaults to 0.10 M.
#' 
#' @param  conc.acid Molar concentration of the strong base titrant;
#' defaults to 0.10 M.
#' 
#' @param pka1 The pKa1 value for the diprotic weak base analyte's 
#' conjugate weak acid; defaults to a pKa1 of 5, or a pKb2 of 9 for the
#' weak base analyte.
#' 
#' @param pka2 The pKa2 value for the diprotic weak base analyte's
#' conjugate weak acid; defaults to a pKa2 of 9, or a pKb1 of 5.
#' 
#' @param pkw The pKw (or pKs) value for the solvent; defaults to water
#' as a solvent with a pKw of 14.
#' 
#' @param vol.base The initial volume, in mL, of the solution that 
#' contains the weak base analyte; defaults to 50.00 mL.
#' 
#' @param plot Logical; if TRUE, plots the titration curve.
#' 
#' @param eqpt Logical; if TRUE, draws a vertical line at the titration
#' curve's equivalence point.
#' 
#' @param overlay Logical; if TRUE, adds the current titration curve
#' to the existing titration curve.
#' 
#' @param \dots Additional arguments to pass to \code{plot()} function.
#' 
#' @return A two-column data frame that contains the volume of titrant
#' in the first column and the solution's pH in the second column. Also
#' produces a plot of the titration curve with options to display the
#' equivalence point and to overlay titration curves.
#' 
#' @author David T. Harvey, DePauw University. \email{harvey@@depauw.edu}
#' 
#' @export
#' 
#' @importFrom graphics plot lines 
#' 
#' @examples
#' ### Simple titration curve with equivalence points
#' ex6 = diwb_sa(eqpt = TRUE)
#' head(ex6)
#' 
#' ### Overlay titration curves using different pKa1 and pKa2 values
#' diwb_sa(pka1 = 5, pka2 = 9, eqpt = TRUE)
#' diwb_sa(pka1 = 6, pka2 = 10, overlay = TRUE)
#' diwb_sa(pka1 = 4, pka2 = 8,  overlay = TRUE)

diwb_sa = function(conc.base = 0.1, conc.acid = 0.1, pka1 = 5, 
                   pka2 = 9, pkw = 14, vol.base = 50, plot = TRUE,
                   eqpt = FALSE, overlay = FALSE, ...) {
  veq1 = conc.base * vol.base/conc.acid
  ka1 = 10^-pka1
  ka2 = 10^-pka2
  kw = 10^-pkw
  ph = seq(pkw, 1, -0.01)
  h = 10^-ph
  oh = kw/h
  delta = h - oh
  alpha1 = (ka1 * h)/(ka1 * ka2 + ka1 * h + h^2)
  alpha2 = h^2/(ka1 * ka2 + ka1 * h + h^2)
  volume = vol.base * 
    (conc.base * alpha1 + 2 * conc.base * alpha2 + delta)/
    (conc.acid - delta)
  df = data.frame(volume, ph)
  df = df[df$volume > 0 & df$volume < 4 * veq1, ]
  rownames(df) = 1:nrow(df)
  if (plot == TRUE) {
  if (overlay == FALSE) {
    plot(df$volume, df$ph, type = "l", lwd = 2,
         xlim = c(0, 1.5 * (2 * veq1)), ylim = c(0, pkw), 
         xlab = "volume of strong acid (mL)",
       ylab = "pH", xaxs = "i", yaxs = "i", ...)
  } else {
    lines(df$volume, df$ph, type = "l", lwd = 2, ...)
  }
  if (eqpt == TRUE){
    x1 = c(veq1, veq1)
    x2 = c(2 * veq1, 2 * veq1)
    y = c(0, pkw + 1)
    lines(x1, y, type = "l", lty = 2, col = "red")
    lines(x2, y, type = "l", lty = 2, col = "red")
  }
  }
  invisible(df)
}