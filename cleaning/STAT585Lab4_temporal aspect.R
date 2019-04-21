# read data
dat=read.csv("Data/Iowa_Liquor_Sales-Story.csv")
head(dat)
names(dat)

# read .zip file directly
data <- read.csv(unz("Data/story-sales.zip", "Iowa_Liquor_Sales-Story.csv"))
names(data)
str(data)
# Data is a factor
# 59 stores in total
# 90 addresses in total
# 

### 
library(dplyr)
library(ggplot2)
length(data$Store.Location)
class(data$Store.Location)
data$Store.Location=as.character(data$Store.Location)
stringr::str_split(data$Store.Location[1],"\n")[[1]][3]%>%stringr::str_split(",")
data$Store.Location[1]

library(lubridate)
data$Date=as.character(data$Date)
mdy(data$Date[1]) %>% wday() # 4 = Wed
mdy(data$Date[2]) %>% wday() # 2 = Mon

data$Sale..Dollars.[1:6]

data=data[1:1000,]
data$Date %>% mdy() %>% year() %>% table()

data$Category.Name %>% unique()


### y=sale
data$week=data$Date %>% mdy() %>% wday()
data %>% ggplot(aes(x=week,y=Sale..Dollars.)) + geom_point()
data %>% ggplot(aes(y=Sale..Dollars.,x=week))+geom_boxplot(aes(group=as.factor(week)))
data[which(data$Sale..Dollars.<1000),] %>% ggplot(aes(y=Sale..Dollars.,x=week))+geom_boxplot(aes(group=as.factor(week)))

data$month=data$Date %>% mdy() %>% month()
data[which(data$Sale..Dollars.<200),] %>% 
  ggplot(aes(y=Sale..Dollars.,x=as.factor(month))) +
  geom_boxplot(aes(group=as.factor(month))) + facet_wrap(~year, ncol = 2)

data %>% ggplot(aes(y=Sale..Dollars.,x=as.factor(month)))+geom_boxplot(aes(group=as.factor(month)))

data$season=data$Date %>% mdy() %>% quarter()
data[which(data$Sale..Dollars.<1000),] %>% ggplot(aes(y=Sale..Dollars.,x=as.factor(season)))+geom_boxplot(aes(group=as.factor(season)))
data %>% ggplot(aes(y=Sale..Dollars.,x=as.factor(season)))+geom_boxplot(aes(group=as.factor(season)))

data$year=data$Date %>% mdy() %>% year()
data$year %>% unique
data[which(data$Sale..Dollars.<1000),] %>% 
  ggplot(aes(y=Sale..Dollars.,x=as.factor(season))) +
  geom_boxplot(aes(group=as.factor(season))) +
  facet_wrap(~year, ncol = 2)


### category (y=count)
data %>% group_by(Category.Name) %>% count() 
data$Category %>% class()
data %>% ggplot(aes(x=as.factor(Category)))+geom_histogram(stat = "count") + facet_wrap(~season)

### volumn (y=count)
data$Bottle.Volume..ml. %>% unique()
data %>% ggplot(aes(x=as.factor(Bottle.Volume..ml.)))+geom_histogram(stat = "count") + facet_wrap(~week)
