library(dplyr)
library(sf)
library(ggplot2)

setwd("/home/poshan/Desktop/Nepal_local_levelwise_Data/")

df <- read.csv("data/raw_data/health_facilities.csv")
##update the name of provinces
lookup <- c(
  "Province 1" = "Koshi Province",
  "Province 2" = "Madhesh Province",
  "Province 3" = "Bagmati Province",
  "Province 5" = "Lumbini Province"
)

df$Provinces <- ifelse(df$Provinces %in% names(lookup), lookup[df$Provinces], df$Provinces)
df |> write.csv("data/raw_data/health_facilities.csv")

local_levels <- read_sf("data/boundary/NepalLocalUnits0.shp")

local_levels |> inner_join(df, by = c("fid" ="fid")) -> joined_local_level

plot(joined_local_level$Total.health.facilities..Public.and.Non.Public.)


local_levels |> left_join(df, by = c("fid" ="fid")) -> joined_local_level

joined_local_level |> filter(!fid %in% c(295,283, 396)) -> joined_local_level_1

ggplot(data = joined_local_level_1) +
  geom_sf(aes(fill = Total.health.facilities..Public.and.Non.Public., geometry = geometry), linewidth = 0.1, alpha = 0.5)+
  scale_fill_viridis_c(option = "D", trans = "sqrt")+
  theme_minimal()




df |> select(any_of(c("Code","fid", "Provinces", "Districts", "Governance.Units", 
                      "Name.of.Government.Unit"))) -> codes.df

codes.df |> write.csv("codes.csv")


##for health count

df_1 <- read.csv("data/raw_data/health_data.csv")

df_1 |> inner_join(codes.df, by = c("Code" = "Code")) -> df_1
df_1$Provinces.x <- ifelse(df_1$Provinces.x %in% names(lookup), lookup[df_1$Provinces.x], df_1$Provinces.x)
df_1 |> write.csv("data/raw_data/health_data.csv")
