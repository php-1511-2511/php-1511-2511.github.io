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

m = mongo("final_project", url = mongo_url)
leaderboard = m$find()

#knitr::kable(leaderboard, digits=2)

if (!team %in% leaderboard$Team)
    stop("Invalid team name.")

if (!file.exists("predict.Rdata"))
    stop("No prediction file to score.  Make sure your repo has a file predict.Rdata for  the dataframe predictions (this should have columns for PIP, fit and lwr and upr !")

load("predict.Rdata")

if (! ("predictions" %in% ls()))
    stop("dataframe with name `predictions` is missing; please rename and try again")

pred=predictions


if (!"PID" %in% colnames(pred))
    stop("Predictions must have PIP column")

if (!"fit" %in% colnames(pred))
    stop("Predictions must have fit column")

if ( any(is.na(pred[,"fit"])))
  stop("Predictions contain NA's - please check results and resubmit")

if (nrow(ames_test) != nrow(pred))
    stop("number of rows in prediction.Rdata does not equal the number of rows in the test data")

error = ames_test$price - pred[, "fit"]

coverage = function(y, pred) {
  if (!all(c("lwr", "upr")  %in% colnames(pred) ))  return(0)
  mean((pred[,"lwr"] < y) & (pred[,"upr"] > y))
}

Bias = mean(error)
Coverage = coverage(ames_test$price, pred)
maxDeviation = max(abs(error))
MeanAbsDeviation = mean(abs(error))
RMSE= sqrt(mean(error^2))

new_score = c(Bias, Coverage, maxDeviation, MeanAbsDeviation, RMSE)
old_score = leaderboard[leaderboard$Team == team,]

leaderboard[leaderboard$Team == team,-1] = new_score

m$drop()
r = m$insert(leaderboard)


cat("\n\n")
cat("Old score: \n")
knitr::kable(old_score)

cat("\n\n")
cat("New score: \n")
knitr::kable(leaderboard[leaderboard$Team == team, ])
#cat("New score:", new_score, "\n")


leaderboard = arrange(leaderboard, RMSE)
cat("\n\n\nLeaderboard\n")
knitr::kable(leaderboard)


