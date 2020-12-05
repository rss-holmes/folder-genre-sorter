#!/bin/bash

# START PROVIDED TO STUDENTS
FILENAME='../music.txt'

# File column numbers (starts at 1 instead of 0)
ENTRY_NUMBER_COL=1
ALBUM_TYPE_COL=2
ALBUM_NAME_COL=3
ARTIST_COL=4
FEAT_ARTIST_COL=5
SONG_NAME_COL=6
GENRE_COL=7
RELEASE_YEAR_COL=8
PREV_URL_COL=9

# Main Music Genres
PUNK="punk"
POP="pop"
INDIE="indie"
ROCK="rock"

# This funciton is a black box.  Under no circumstances are you to edit it.
# Furthermore, it is a black box because if something in this function was not taught to you in the textbook
# or in the background section for this assignment, do not use it.  In otherwords, everything you need is in
# the assignment specifications and textbook.
create_directory_structure() {
    IFS=$'\n' # input field separator (or internal field separator)
    FILE_GENRES=$(cat $FILENAME | cut -d $'\t' -f $GENRE_COL | sort -u)

    for GENRE in ${FILE_GENRES[@]}; do
        if [[ $GENRE == "Genre" ]]; then
            continue
        fi

        IFS=' '
        read -ra GENRE_SPLIT <<<$GENRE
        GENRE=$(echo "$GENRE" | tr ' ' '-')
        COUNT=1
        FOUND=1
        NUM_SPLIT="${#GENRE_SPLIT[@]}"

        for SPLIT in ${GENRE_SPLIT[@]}; do
            if [[ $SPLIT == *$INDIE* ]] && [[ ${GENRE_SPLIT[*]} != $INDIE ]]; then
                PARENT_GENRE=$INDIE
            elif [[ $SPLIT == *$PUNK* ]] && [[ ${GENRE_SPLIT[*]} != $PUNK ]]; then
                PARENT_GENRE=$PUNK
            elif [[ $SPLIT == *$POP* ]] && [[ ${GENRE_SPLIT[*]} != $POP ]]; then
                PARENT_GENRE=$POP
            elif [[ $SPLIT == *$ROCK* ]] && [[ ${GENRE_SPLIT[*]} != $ROCK ]]; then
                PARENT_GENRE=$ROCK
            else
                if [ "$GENRE" = "None" ]; then
                    mkdir -p "uncategorized"
                    break
                elif [[ $FOUND -eq 0 ]]; then
                    if [[ $COUNT -eq $NUM_SPLIT ]]; then
                        break
                    fi

                    ((COUNT += 1))
                    continue
                elif [ $COUNT -ne $NUM_SPLIT ] && [ $FOUND -eq 1 ]; then
                    ((COUNT += 1))
                    continue
                else
                    mkdir -p "${GENRE}"
                    continue
                fi
            fi

            mkdir -p "${PARENT_GENRE}/${GENRE}"
            FOUND=0
            ((COUNT += 1))
        done
    done
}
# END PROVIDED TO STUDENTS

read_each_line_of_file() {
    while read -r line into myArray; do
        while IFS=$'\t' read -r -a myArray; do
            read_data myArray
        done
    done <$FILENAME
}

read_data() {

    ENTRY_NUMBER=${myArray[$ENTRY_NUMBER_COL - 1]}
    ALBUM_TYPE=${myArray[$ALBUM_TYPE_COL - 1]}
    ALBUM_NAME=${myArray[$ALBUM_NAME_COL - 1]}
    ARTIST=${myArray[ARTIST_COL - 1]}
    FEAT_ARTIST=${myArray[FEAT_ARTIST_COL - 1]}
    SONG_NAME=${myArray[SONG_NAME_COL - 1]}
    GENRE=${myArray[GENRE_COL - 1]}
    RELEASE_YEAR=${myArray[RELEASE_YEAR_COL - 1]}
    PREV_URL=${myArray[PREV_URL_COL - 1]}
    GENRE_ARRAY=(${GENRE})
    ALBUM_NAME_FORMATTED=$(echo "$ALBUM_NAME" | tr ' ' '_')
    ARTIST_FORMATTED=$(echo "$ARTIST" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    GENRE_FORMATTED=$(echo "$GENRE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    FEAT_ARTIST_FORMATTED=$(echo "$FEAT_ARTIST" | tr ' ' '_')
    if [[ $FEAT_ARTIST_FORMATTED != 'None' ]]; then
        SONG_NAME_FORMATTED="${SONG_NAME}_(ft._${FEAT_ARTIST_FORMATTED})"
    else
        SONG_NAME_FORMATTED="${SONG_NAME}"
    fi

    ARTIST_FOLDER_NAME=$ARTIST_FORMATTED
    FILE_NAME="${RELEASE_YEAR}_-_${ALBUM_NAME_FORMATTED}_(${ALBUM_TYPE})"
    ENTRY="${SONG_NAME_FORMATTED}: ${PREV_URL}"
    

    # echo "Entry Number: $ENTRY_NUMBER"
    # echo "ALBUM_TYPE: $ALBUM_TYPE"
    # echo "ALBUM_NAME: $ALBUM_NAME"
    # echo "ARTIST: $ARTIST"
    # echo "FEAT_ARTIST: $FEAT_ARTIST"
    # echo "SONG_NAME: $SONG_NAME"
    # echo "GENRE: $GENRE"
    # echo "RELEASE_YEAR: $RELEASE_YEAR"
    # echo "PREV_URL: $PREV_URL"
    # echo "ALBUM_NAME_FORMATTED: $ALBUM_NAME_FORMATTED"
    # echo "ARTIST_FORMATTED: $ARTIST_FORMATTED"
    # echo "GENRE_FORMATTED: $GENRE_FORMATTED"
    # echo "FEAT_ARTIST_FORMATTED: $FEAT_ARTIST_FORMATTED"
    # echo "ARTIST_FOLDER_NAME : $ARTIST_FOLDER_NAME"
    # echo "FILE_NAME : $FILE_NAME"
    # echo "ENTRY : $ENTRY"

    punk_count=0
    pop_count=0
    indie_count=0
    rock_count=0

    if [[ " ${GENRE_ARRAY[@]} " =~ " ${PUNK} " ]]; then
        punk_count=1
    fi

    if [[ " ${GENRE_ARRAY[@]} " =~ " ${POP} " ]]; then
        pop_count=1
    fi

    if [[ " ${GENRE_ARRAY[@]} " =~ " ${INDIE} " ]]; then
        indie_count=1
    fi

    if [[ " ${GENRE_ARRAY[@]} " =~ " ${ROCK} " ]]; then
        rock_count=1
    fi

    net_count=$((punk_count + pop_count + indie_count + rock_count))

    if [ $net_count == 0 ]; then
        mkdir -p "${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
        touch "${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}" 
        echo "$ENTRY" >>"${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
    fi

    if [ $net_count == 1 ]; then
        mkdir -p "${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
        touch "${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}" 
        echo "$ENTRY" >>"${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
    fi

    if [ $net_count == 2 ]; then

        if [ $punk_count == 1 ]; then
            
            mkdir -p "punk/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
            touch "punk/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
            echo "$ENTRY" >>"punk/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
        fi

        if [ $pop_count == 1 ]; then
            
            mkdir -p "pop/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
            touch "pop/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
            echo "$ENTRY" >>"pop/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
        fi

        if [ $indie_count == 1 ]; then
            
            mkdir -p "indie/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
            touch "indie/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
            echo "$ENTRY" >>"indie/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
        fi

        if [ $rock_count == 1 ]; then
            
            mkdir -p "rock/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}"
            touch "rock/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
            echo "$ENTRY" >>"rock/${GENRE_FORMATTED}/${ARTIST_FOLDER_NAME}/${FILE_NAME}"
        fi
    fi
}

echo "Script running ..."
mkdir -p music && cd music
create_directory_structure
read_each_line_of_file
cd ..
zip -r music.zip music> zip-output.txt
echo "Done"
