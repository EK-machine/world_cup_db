#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

csv_file="games.csv"

while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; 
do
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  if [[ -z $WINNER_ID ]]
    then
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  fi

  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
    then
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  fi

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')" 


done < <(tail -n +2 "$csv_file")
