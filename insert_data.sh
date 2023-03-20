#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

clear
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  WINNER_RESULT=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'") 
  OPPONENT_RESULT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'") 
  if [[ -z $WINNER_RESULT ]]
  then
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
  fi
  if [[ -z $OPPONENT_RESULT ]]
  then
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
   fi
  fi

#insert into games table
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") 
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 
if [[ $YEAR != 'year' ]]
then
    INSERT_MATCH=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
    if [[ $INSERT_MATCH == "INSERT 0 1" ]]
    then
     echo Inserted into games, $WINNER beat $OPPONENT during the $ROUND in year $YEAR $WINNER_GOALS to $OPPONENT_GOALS 
    fi
fi
done
