#!/usr/bin/env bash

# This script moves a file from Box to a Google Cloud Storage Bucket.
# This process is pretty indirect. First, it downloads the file from Box locally
# into a temporary directory, then uploads it to the Google Bucket using the file name,
# then the local temporary file is directed. This is repeated for each file ID specified
# in the IDs file.


# create temporary directory
mkdir ./tempreads

# iterate through lines in ID file
while read ID; do
    # get the file name
    FILENAME=$(box files:get "${ID}" | grep "^Name" | cut -d " " -f 2)
    echo "File: ${FILENAME}"

    # download file to temp directory
    echo "Downloading: ${FILENAME} (${ID}) . . ."
    box files:download $ID --destination=./tempreads

    # upload file to google storage bucket
    echo "Uploading ${FILENAME} to bucket ${2} . . ."
    gsutil cp ./tempreads/$FILENAME $2

    # remove file from temp directory
    echo "Remove ${FILENAME} from temporary directory"
    rm ./tempreads/$FILENAME

    # end with newline for formating
    echo ""
done < $1


# remove temporary directory
rm -r ./tempreads
