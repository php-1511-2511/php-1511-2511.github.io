#Load Data
#Load Data
load( "/home/php2560/BRFSS_2014.rda")


#Cleaning Variables
# Missing Data coded as answers that do not make sense

brfss$insurance <- NA
brfss$insurance[brfss$hlthpln1==1] <-1 
brfss$insurance[brfss$hlthpln1==2] <-0 


brfss$carrier <- NA
brfss$carrier[brfss$hlthcvr1==1] <-1
brfss$carrier[brfss$hlthcvr1==2] <-1
brfss$carrier[brfss$hlthcvr1==3 | brfss$hlthcvr1==4 | brfss$hlthcvr1==5] <-2
brfss$carrier[brfss$hlthcvr1==6] <-3
brfss$carrier[brfss$hlthcvr1==7] <-3
brfss$carrier[brfss$hlthcvr1==8] <-4

brfss$carrier <- factor(brfss$carrier, levels = c(1,2,3,4), 
                        labels=c("Work or Fam", "Govt", "Other", "None"))
#Do you have any kind of health care coverage, including health insurance, prepaid plans such as HMOs, or government
#plans such as Medicare, or Indian Health Service?
#1-yes 0-no

brfss$pcp <- NA
brfss$pcp[brfss$persdoc2==2] <-2
brfss$pcp[brfss$persdoc2==1] <-1 
brfss$pcp[brfss$persdoc2==3] <-0
#Do you have one person you think of as your personal doctor or health care provider? 
#0-no, 1- one provider, 2- more than one provider

brfss$cost <- NA
brfss$cost[brfss$medcost==1] <-1 
brfss$cost[brfss$medcost==2] <-0
#Was there a time in the past 12 months when you needed to see a doctor but could not because of cost?

brfss$orientation <- NA
brfss$orientation[brfss$sxorient==1] <- 1
brfss$orientation[brfss$sxorient==2] <- 2
brfss$orientation[brfss$sxorient==3] <- 3
brfss$orientation[brfss$sxorient==4] <- 4
#sexual orientation
#1-straight 2-lesbian gay 3-bisexual 4-other






brfss$education = NULL #get rid of refused answer
brfss$education = brfss$educa
brfss$education[brfss$education==9] = NA
#What is the highest grade or year of school you completed?
#1- Never attended school or only kindergarten, 2-Grades 1 through 8 (Elementary) 3-Grades 9 through 11 (Some high school) 
#4-Grade 12 or GED (High school graduate) 5-College 1 year to 3 years (Some college or technical school)
#6-6 College 4 years or more (College graduate) 166,972 36.07 25.79


#most of children is missing. Maybe exclude in analysis
brfss$children_count = NULL #recode so that if you have more than 4 or more coded as 1
brfss$children_count = brfss$children
brfss$children_count[brfss$children_count==99] = NA
brfss$children_count[brfss$children_count==88] = 0

# How many children less than 18 years of age live in your household
# Note we recode the missing first because they are 88 and 99 which our 
# below code would have set to 4
brfss$children_count[brfss$children_count>=4] = 4

#What is the highest grade or year of school you completed?
#1 employed, 2 not employed
brfss$employed = NULL
brfss$employed[brfss$employ1==1] = 1
brfss$employed[brfss$employ1==8 | brfss$employ1 ==9] = NA
brfss$employed[brfss$employ1>=2] = 2


#income-dichot
#1- 75000 or more, 0- not
brfss$annual_income = NULL
brfss$annual_income[brfss$income2==77 | brfss$income2==99] = NA
brfss$annual_income[brfss$income2 == 8] = 1
brfss$annual_income[brfss$income2 < 8] = 0

brfss$age = brfss$age80 #left it as continuous


#Creating Factors
#Labeling factors

brfss$imprace <- factor(brfss$imprace, levels = c(1,2,3,4,5,6),
                        labels= c("White", "Black", "Asian", "AI/AN", "Hispanic", "Other" ))

brfss$orientation <- factor(brfss$orientation, levels=c(1,2,3,4), label=c("straight", "Les/Gay", "Bi", "Other"))
brfss$pcp = factor(brfss$pcp, levels=c(0,1,2), label = c("more than one", "only one", "no"))
brfss$education = factor(brfss$education, levels=c(1,2,3,4,5,6),
                         labels = c("never attended school", "elementary", "some high school",
                                    "high school graduate", "some college", "college graduate"))



brfss$disabled <- NA
brfss$disabled[brfss$useequip==1] <-1 
brfss$disabled[brfss$useequip==2] <-0 
brfss$disabled[brfss$useequip==7 | brfss$useequip==9] = NA
brfss$disabled = factor(brfss$disabled, levels=c(0,1), 
                        label = c("not disabled", "physical disabled"))

brfss$selfhlth <- NA
brfss$selfhlth[brfss$genhlth==7 | brfss$genhlth==9] <- NA
brfss$selfhlth[brfss$genhlth>=4]=1
brfss$selfhlth[brfss$genhlth<=3]=0
brfss$selfhlth = factor(brfss$selfhlth, levels=c(0,1), 
                        label = c("good health", "poor/fair health"))

brfss$selfhlth2<- NA
brfss$selfhlth2[brfss$genhlth==7 | brfss$genhlth==9] <- NA
brfss$selfhlth2[brfss$genhlth==5]=1
brfss$selfhlth2[brfss$genhlth==4]=2
brfss$selfhlth2[brfss$genhlth==3]=3
brfss$selfhlth2[brfss$genhlth==2]=4
brfss$selfhlth2[brfss$genhlth==1]=5

brfss$selfhlth2 = factor(brfss$selfhlth2, levels=c(1,2,3,4,5), 
                         label = c("poor", "fair", "good", "very good", "excellent"))

#Heart Attack
brfss$heartattack <- NA
brfss$heartattack[brfss$cvdinfr4==1] <- 1
brfss$heartattack[brfss$cvdinfr4==2] <- 0



brfss$internet = NA
brfss$internet[brfss$internet==7 | brfss$internet==9] = NA
brfss$internet[brfss$internet == 1] = 0
brfss$internet[brfss$internet == 2] = 1

#Cellphone
brfss$cell = NA
brfss$cell[brfss$cpdemo1==7 | brfss$cpdemo1==9] = NA
brfss$cell[brfss$cpdemo1 == 1] = 0
brfss$cell[brfss$cpdemo1 == 2] = 1

brfss$smoked = NA
brfss$smoked[brfss$smoke100==1] = 1
brfss$smoked[brfss$smoke100==2] = 0
brfss$smoked[brfss$smoke100==7 | brfss$smoke100==9] = NA #get rid of refused or not know

brfss$equip <- NULL
brfss$equip[brfss$useequip==1] = 1
brfss$equip[brfss$useequip==2] = 0
brfss$equip[brfss$useequip==7 | brfss$useequip ==9] = NA


# Times since last dental visit
brfss$dent = NA
brfss$dent[brfss$lastden3==1] = 1
brfss$dent[brfss$lastden3==2] = 2
brfss$dent[brfss$lastden3==3] = 3
brfss$dent[brfss$lastden3==4] = 4
brfss$dent[brfss$lastden3==8] = 8

worried = NULL #Get rid of don't know, refused, and no applicable answers
brfss$worried = brfss$scntmny1
brfss$worried[brfss$scntmny1==7 | brfss$scntmny1 ==8 | brfss$scntmny1==9] = NA
brfss$worried[brfss$scntmny1==1 | brfss$scntmny1 ==2 | brfss$scntmny1==3] = 1
brfss$worried[brfss$scntmny1==4 | brfss$scntmny1 ==5] = 2
brfss$worried <- factor(brfss$worried, levels = c(1,2), labels= c("Yes", "No"))


brfss$preg <- NA
brfss$preg[brfss$pregnant==1] <-1 
brfss$preg[brfss$pregnant==2] <-0

brfss$preg <- factor(brfss$preg, levels = c(0,1), labels = c("Yes", "No"))



### recode seatbelt use
#1 always
#2 not always
brfss$seat = NA
brfss$seat[brfss$seatbelt==1] = 1
brfss$seat[brfss$seatbelt==7 | brfss$seatbelt==8 | brfss$seatbelt==9] = NA
brfss$seat[brfss$seatbelt>=2] = 2
brfss$seat <- factor(brfss$seat, levels=c(1,2), labels=c("Always", "Not Always"))

###recode metropolitan status
#1 city 
#2 outskirt
#3 suburban 
#4 rural
brfss$msc <- NA
brfss$msc[brfss$mscode==1] <- 1
brfss$msc[brfss$mscode==2] <- 2
brfss$msc[brfss$mscode==3] <- 3
brfss$msc[brfss$mscode==5] <- 4
brfss$msc = factor(brfss$msc, levels=c(1,2,3,4), labels = c("city", "outskirt","suburban", "rural"))

# Satisfaction with Life
brfss$satisfaction <- brfss$lsatisfy
brfss$satisfaction[brfss$lsatisfy==7|brfss$lsatisfy==9] <- NA
brfss$satisfaction <- factor(brfss$satisfaction,levels=c(1,2,3,4),labels=c("Very satisfied","Satisfied","Dissatisfied","Very dissatisfied"))

# Exercise
brfss$exercise <- NA
brfss$exercise[brfss$exerany2==1] <- 1
brfss$exercise[brfss$exerany2==2] <- 0


#Pneumonia shot
brfss$pne <- NA
brfss$pne[brfss$pneuvac3==1] <- 0 
brfss$pne[brfss$pneuvac3==2] <- 1 
brfss$pne[brfss$pneuvac3==7|brfss$pneuvac3==9] <- NA 


#Pap test ever
brfss$pap <- NA
brfss$pap[brfss$hadpap2 == 1] <- 0
brfss$pap[brfss$hadpap2 == 2] <- 1


#recode asthma status
brfss$asthma.stat <- NULL
brfss$asthma.stat[brfss$asthma3==1] <-1
brfss$asthma.stat[brfss$asthma3==2] <-0
brfss$asthma.stat[brfss$asthma3==7 | brfss$asthma3==9] <-NA
#Label factor: asthma status
brfss$asthma.stat<-factor(brfss$asthma.stat,levels=c(0,1), labels=c("no","yes"))

#weight
brfss$weight <- NA
brfss$weight[brfss$weight2 < 250] = 0
brfss$weight[brfss$weight2>250 & brfss$weight2<999] = 1
brfss$weight <- factor(brfss$weight, levels=c(0,1), 
                       label=c("<250", ">250"))

#satisfied with health care
brfss$satisf = NA
brfss$satisf[brfss$carercvd==1] = 2
brfss$satisf[brfss$carercvd==2] = 1
brfss$satisf[brfss$carercvd==3] = 0
brfss$satisf[brfss$carercvd==7 | brfss$carercvd ==8| brfss$carercvd ==9] = NA
brfss$satisf = factor(brfss$satisf, levels=c(0,1,2), label = c("not satisfied", "somewhat satisfied", "very satisfied"))

# Recoding depression: 0 - no; 1 - yes
brfss$depressed = NA
brfss$depressed[brfss$addepev2==1] = 1
brfss$depressed[brfss$addepev2==2] = 0

# `cvdinfr4`: Ever Diagnosed with Heart Attack 
brfss$heart <- NA #1- yes, 0- no
brfss$heart[brfss$cvdinfr4==1] <-1 
brfss$heart[brfss$cvdinfr4==2] <-0

brfss$stroke<-NA
brfss$stroke[brfss$cvdstrk3==1]<-1 ## 1-YES
brfss$stroke[brfss$cvdstrk3==2]<-0 ## 0-NO
brfss$stroke<-factor(brfss$stroke,levels=c(0,1), labels=c("NO","YES"))




brfss$pcp.bin <- brfss$pcp
brfss$pcp.bin <- as.numeric(brfss$pcp.bin)
brfss$pcp.bin[brfss$pcp.bin==2] <-1
brfss$pcp.bin[brfss$pcp.bin==3] <-0


brfss$healthy.days <- brfss$physhlth
brfss$healthy.days[brfss$healthy.days==88]<- 0
brfss$healthy.days[brfss$healthy.days==77 | brfss$healthy.days==99] <- NA

#This is a list of variables we care about
vars <- c( "insurance", "imprace",  "pcp", "pcp.bin",
           "education", "age", "annual_income", "employed", "sex", 
           "military", "cost", "children_count", "psu", "llcpwt", "ststr",
           "stroke", "heart", "depressed", "satisf", "weight", 
           "asthma.stat", "pap", "pne", "exercise", 
           "msc", "seat",  "dent", "equip" , "carrier",
           "smoked", "cell",   "disabled", "selfhlth", "selfhlth2", "healthy.days")     

#Select only these variables
brfss_sub <- brfss[vars]

#Use only complete cases
brfss_sub_com <- brfss_sub[complete.cases(brfss_sub),]


library(survey)

brfss.design <- svydesign(data=brfss_sub_com, nest=TRUE, weight= ~llcpwt, id= ~psu, strata= ~ststr)

save( brfss.design , file =  'design.rda' )


