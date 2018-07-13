# Bundesliga German Soccer Data:

library(bundesligR)
library(dplyr)

soccer <- as.data.frame(bundesligR)

head(soccer)

# Season is the year when the season started until the end of the next year.

# Rename a few columns: W = Wins, D = Draws, L = Losses

# Remove Pts_pre_95 variable/column
soccer <- soccer %>% 
              select(-Pts_pre_95) %>%
              rename(Games.Played = Played, Wins = W, Draws = D, Losses = L)

head(soccer)

# ----------------------------------------------

# 2015 Bundesliga Season from 2015 to 2016:

season_2015 <- soccer %>% filter(Season == 2015)
season_2015

# ----------------------------------------------
# Best Season where the title winning team had the most points 
# in history from 1964-2016.

best_season <- soccer %>% filter(Points == max(Points))
best_season

# ----------------------------------------------
# Worst Season where the last place (and relegated) team had the lowest points 
# in history from 1964-2016.

worst_season <- soccer %>% filter(Points == min(Points))
worst_season

# ----------------------------------------------

# Top 5 Teams per Season:
# Remove the GF, GA, 

top5 <- soccer %>% 
           group_by(Season) %>% 
           filter(Position <= 5)

top5 <- data.frame(top5)

head(top5, n = 30)

# ----------------------------------------------

# Totals:

# ----------------------------------------------

# How Many Times Bayern Muenchen have won the domestic 
# Bundesliga title (1964-2016). They won in 1931-1932.

bayern_wins <- soccer %>%
               group_by(Season) %>%
               filter(Team == "FC Bayern Muenchen" & Points == max(Points)) 

bayern_wins <- as.data.frame(bayern_wins)
bayern_wins

bayern_winCount <- nrow(bayern_wins); bayern_winCount

# How Many Times Borussia Dortmund have won the domestic 
# Bundesliga title (1964-2016). 

dortmund_wins <- soccer %>%
                    group_by(Season) %>%
                    filter(Team == "Borussia Dortmund" & Points == max(Points)) 

dortmund_wins <- data.frame(dortmund_wins)
dortmund_wins

dortmund_winCount <- nrow(dortmund_wins); dortmund_winCount


# Title Winning Teams and Their Counts:

winning_teams <- soccer %>%
                   group_by(Season) %>%
                      filter(Position == 1) %>% 
                        group_by(Team) %>% 
                          count(Team) %>%
                            rename(Title.Wins = n) %>%
                              arrange(desc(Title.Wins))

winning_teams <- data.frame(winning_teams)

winning_teams 

#-----------------------------


# Total Number of Games Played, Wins, Draws and Losses, goals for 
# Bayern Muenchen

bayern_totals <- soccer %>% 
  group_by(Team) %>%
  filter(Team == "FC Bayern Muenchen") %>%
  summarise_each(funs(sum), Games.Played = Games.Played, Wins = Wins, 
                 Draws = Draws, Losses = Losses, GF = GF, GA = GA, GD = GD) 

bayern_totals <- data.frame(bayern_totals)
bayern_totals


# Total Number of Games Played, Wins, Draws and Losses, goals for 
# Bayern Muenchen, Borussia Dortmund & Borussia Moenchengladbach &
# Bayer 04 Leverkusen

bteams <- soccer %>% 
  group_by(Team) %>%
  filter(Team %in% c("FC Bayern Muenchen", "Borussia Dortmund", 
                     "Borussia Moenchengladbach", "Bayer 04 Leverkusen")) %>%
  summarise_each(funs(sum), Games.Played = Games.Played, Wins = Wins, 
                 Draws = Draws, Losses = Losses, GF = GF, GA = GA, GD = GD) 

bteams <- data.frame(bteams)
bteams


# Add win rate to bteams data:

bteams_wrate <- bteams %>% mutate(Win.Rate = round(Wins / Games.Played, 2))
                
bteams_wrate
                         
## Test..........................


# bayern_totals <- soccer %>% 
#                    group_by(Team) %>%
#                    filter(Team == "FC Bayern Muenchen") %>%
#   summarise_each(funs(sum), Games.Played = Games.Played, Wins = Wins, 
#                  Draws = Draws, Losses = Losses, GF = GF, GA = GA, GD = GD) 
# 
# bayern_totals <- data.frame(bayern_totals)
# bayern_totals

# Overall Record For All Teams in Bundesliga:

teams <- soccer %>% 
  group_by(Team) %>%
  summarise_each(funs(sum), Games.Played = Games.Played, Wins = Wins, 
                 Draws = Draws, Losses = Losses, GF = GF, GA = GA, GD = GD) %>% 
  mutate(Win.Rate = round(Wins / Games.Played, 2)) %>% 
  arrange(desc(Wins), desc(Win.Rate))

teams <- data.frame(teams)
teams