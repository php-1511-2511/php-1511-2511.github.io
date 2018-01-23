suppressMessages(library(mongolite))
#suppressMessages(library(sf))
suppressMessages(library(knitr))
#suppressMessages(library(sp))

mongo_url = "mongodb://sta521:sta521_final_project@saxon.stat.duke.edu:52123/sta521"

train_url= "http://stat.duke.edu/courses/Spring17/sta521/Data/ames_train.Rdata"
test_url= "http://stat.duke.edu/courses/Spring17/sta521/Data/ames_test.Rdata"

VALDATA_URL = "http://stat.duke.edu/courses/Spring17/sta521/Data/ames_validation.Rdata"

options(nwarnings = 50)

load(url(test_url))  #load  ames_test.Rdata
load(url(train_url))

m = mongo("final_project", url = mongo_url)
leaderboard = m$find()

webdir = "~/Dropbox/sta521-S17/sta521-website/STA521_S17_web/Data/"
final.teams = read.csv(paste0(webdir,"STA521_Final_Teams.csv"), header=TRUE)

team.names = c(as.character(unique(final.teams$TeamName)), "Instructional_Team", "BayesianSadistics")

leaderboard = data.frame(Team = team.names)

error = ames_test$price - mean(ames_train$price)
pred = predict(lm(price ~ 1, data=ames_train), newdata=ames_test, interval="pred")

coverage = function(y, pred) {
    mean((pred[,"lwr"] < y) & (pred[,"upr"] > y))

}

#coverage(ames_test$price, pred)

leaderboard$Bias = mean(error)
leaderboard$Coverage = coverage(ames_test$price, pred)*0
leaderboard$maxDeviation = max(abs(error))
leaderboard$MeanAbsDeviation = mean(abs(error))
leaderboard$RMSE= sqrt(mean(error^2))


m$drop()
r = m$insert(leaderboard)
cat("\n\n\nLeaderboard\n")
knitr::kable(leaderboard, digits=2)


### github
library(devtools)
install_github("rundel/ghclass")
library(ghclass)
token =get_github_token()
ghclass::create_org_teams("STA521-S17", teams=team.names)
add_org_team_member(org = "STA521-S17",
                    users = as.character(final.teams$Account),
                    teams = as.character(final.teams$TeamName))

gh.teams = get_org_teams("STA521-S17", exclude=T, filter="Team_")
create_team_repos("STA521-S17", teams=gh.teams, prefix="Project_")
gh.repos = get_org_repos("STA521-S17", filter="Project")
dir = "~/Dropbox/sta521-S17/Final-Project/"
add_files(repos=gh.repos, message="initialize", files=paste0(dir,"README.md"))
add_files(repos=gh.repos, message="initialize", files=paste0(dir,"Final-Data-Analysis.Rmd"))
add_files(repos=gh.repos, message="initialize", files=paste0(dir,"predict.Rdata"))
add_files(repos=gh.repos, message="final scoring", files=paste0(dir,"wercker.yml"))
add_files(repos=gh.repos, message="correct data", files=paste0(dir,"ames_train.Rdata"))
add_files(repos=gh.repos, message="correct data", files=paste0(dir,"ames_test.Rdata"))
add_files(repos=gh.repos, message="correct data", files=paste0(dir,"ames_validation.Rdata"))

add_wercker(repos=gh.repos, "STA521-S17", verbose=F)
add_badges(gh.repos, badges=get_badges(gh.repos))

badges = get_badges(gh.repos)
save(badges, file="../sta521-website/STA521_S17_web/knitr/Final_Project/badges.Rdata")
save(gh.repos, file="../sta521-website/STA521_S17_web/knitr/Final_Project/ghrepos.Rdata")


#pull repos

ghclass::grab_repos(get_org_repos("STA521-S17", filter="Project_"), localpath = "~/Dropbox/sta521-S17/FP-Teams")
