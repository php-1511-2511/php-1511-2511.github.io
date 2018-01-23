suppressMessages(library(mongolite))
suppressMessages(library(knitr))
suppressMessages(library(dplyr))

strip_attrs = function(obj)
{
  attributes(obj) = NULL
  obj
}


#sessionInfo()

options(nwarnings = 50)

args = commandArgs(trailingOnly = TRUE)

stopifnot(length(args) == 3)
team = args[1]
mongo_url = args[2]
test_url = args[3]

cat("Updating scores for Team", team,"\n")

load(url(test_url))  #load  ames_test.Rdata
load(url(test_url))  #load  ames_test.Rdata

m = mongo("final_project", url = mongo_url)
leaderboard = m$find()

#knitr::kable(leaderboard, digits=2)

if (!team %in% leaderboard$Team)
    stop("Invalid team name.")

if (!(file.exists("prediction-validation-local.Rdata" ) |
      file.exists("predict-validation-local.Rdata" ))) {
    leaderboard[leaderboard$Team == team,-1] = NA
    m$drop()
    r = m$insert(leaderboard)
    stop("No prediction file to score.  Make sure your repo has a file prediction-validation.Rdata for  the dataframe predictions (this should have columns for PIP, fit and lwr and upr !")
}
if ( file.exists("predict-validation-local.Rdata" )) load("predict-validation-local.Rdata")
if ( file.exists("prediction-validation-local.Rdata" )) load("prediction-validation-local.Rdata")

if (! ("predictions" %in% ls()))
    stop("dataframe  named `predictions` is missing; please rename and try again")

pred=predictions


#if (!"PID" %in% colnames(pred))
#    stop("predictions must have PIP column")

if (!"fit" %in% colnames(pred))
    stop("predictions must have fit column")

if ( any(is.na(pred[,"fit"])))
  stop("predictions contain NA's - please check results and resubmit")

if (nrow(ames_validation) != nrow(pred))
    stop("number of rows in predict-validation.Rdata does not equal the number of rows in the test data")

error = ames_validation$price - pred[, "fit"]

coverage = function(y, pred) {
  if (!all(c("lwr", "upr")  %in% colnames(pred) ))  return(0)
  mean((pred[,"lwr"] < y) & (pred[,"upr"] > y))
}

Bias = mean(error)
Coverage = coverage(ames_validation$price, pred)
maxDeviation = max(abs(error))
MeanAbsDeviation = mean(abs(error))
RMSE= sqrt(mean(error^2))

new_score = c(Bias, Coverage, maxDeviation, MeanAbsDeviation, RMSE)
old_score = leaderboard[leaderboard$Team == team,]

leaderboard[leaderboard$Team == team,-1] = new_score

m$drop()
r = m$insert(leaderboard)

cat(" successful predictions!  You are are done!\n\n")
#cat("\n\n")
#cat("Old score: \n")
#knitr::kable(old_score)

#cat("\n\n")
#cat("New score: \n")
#knitr::kable(leaderboard[leaderboard$Team == team, ])
#cat("New score:", new_score, "\n")


#leaderboard = arrange(leaderboard, RMSE)
#cat("\n\n\nLeaderboard\n")
#knitr::kable(leaderboard)


