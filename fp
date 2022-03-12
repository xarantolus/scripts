#!/usr/bin/env bash 

f || true

USELESS_COMMIT_MESSAGES=(
    "Add hat wobble"
    "Remove herobrine"

    # Some animal-themed messages
    "Busy as a bee"
    "Horsing around"
    "Breaking the camel's back"
    "Letting the cat out of the bag"
    "Opening a can of worms"
    "Getting the ducks in a row"
    "The thing with two birds and a stone"
    "Not sure if this is the chicken or the egg"
    "Putting the elephant in the room"
    "Moving the elephant out of the room"
)

random_message() {
    MSG_COUNT=${#USELESS_COMMIT_MESSAGES[@]}
    RANDOM_INDEX=$(($RANDOM % $MSG_COUNT))
    echo "${USELESS_COMMIT_MESSAGES[$RANDOM_INDEX]}"
}

MSG="$@"
ALTERNATIVE_MSG="$(random_message)"

git commit -am"${MSG:-$ALTERNATIVE_MSG}" && git push
