#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
 
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

 echo "$($PSQL "TRUNCATE TABLE teams, games")"


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # if not found
      if [[ -z $WINNER_ID ]]
      then
        # insert team
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        # if inserted s
        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then 
          echo "Inserted the winner"
        # get team_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$WINNER_ID'")
        echo "Insert success : ${WINNER_NAME}"
        fi
      fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # if not found
      if [[ -z $OPPONENT_ID ]]
      then
        # insert team
        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        # if inserted s
        if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then 
          echo "Inserted the loser"
        # get team_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$OPPONENT_ID'")
        echo "Insert success : ${OPPONENT_NAME}"
        fi
      fi

    INSERT_GAMES=$($PSQL"INSERT INTO games(year,round,winner_goals,winner_id,opponent_goals,opponent_id)VALUES ($YEAR, '$ROUND', $WINNER_GOALS, $WINNER_ID, $OPPONENT_GOALS, $OPPONENT_ID)")
    if [[ $INSERT_GAMES = "INSERT 0 1" ]]
    then
      echo "Insert success : $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi


done