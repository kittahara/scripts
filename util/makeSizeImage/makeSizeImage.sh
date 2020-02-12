#!/bin/sh

ONE_MB=1048218;
DUMMY_COMMENT_FILE="./dummy.txt";
OUTPUT_IMAGE_FILE="./dummy.jpg";

function computeByteSize() {
    echo $(($1 * $ONE_MB))
};

function makeDummyComment() {
    cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w "$1" | head -n 1 > $DUMMY_COMMENT_FILE
};

function getDummyBaseImage() {
    image_url="https://placehold.jp/3d4070/ffffff/1000x1000.jpg?text=$1";
    curl -sS --output $OUTPUT_IMAGE_FILE $image_url
};

function makeImageFileName() {
    filename="./dummy_$1.jpg"
    cp -r $OUTPUT_IMAGE_FILE $filename;
    echo $filename
};

function error() {
    echo "ERROR: $*" 1>&2
}

# Look for command line flags.
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--h|--help)
        error "sorry not ready yet."
        exit 1
        ;;
    -*)
        error "unknown option flag: $1"
        exit 1
      ;;
    *)
        if [ -n "$1" ] ; then
            byte=`computeByteSize "$1"`
            getDummyBaseImage "$byte"
            makeDummyComment "$byte"
            filename=`makeImageFileName "$byte"`
            exiftool $filename -comment\<="$DUMMY_COMMENT_FILE"
        else
            error "unknown args."
            exit 2
        fi
        ;;
    esac
    shift
done

exit 0