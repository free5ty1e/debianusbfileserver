#!/bin/bash

echo "Processing image $1 for archival storage in location $2 under an appropriate year folder - if jpeg, optimizing and shrinking.  If not jpeg, just moving."
echo "(You should provide the first parameter as the image filename)"

FILE_BASENAME=$(basename "$1")
TEMP_SHRUNK_IMAGE_OUTPUT_FILENAME="shrunk_$FILE_BASENAME"
TEMP_OPTIMIZED_FILENAME="optimized_temp.jpg"
TEMP_OPTIMIZED_STAGE2_FILENAME="optimized_stage2_temp.jpg"
YEAR_FROM_FILENAME=$(yearfromfiletimestamp.sh "$1")
TARGET_FOLDER="$2/$YEAR_FROM_FILENAME"
echo "Year extracted from filename via script: $YEAR_FROM_FILENAME, creating location $TARGET_FOLDER if it does not already exist..."
mkdir -pv "$TARGET_FOLDER"

if [[ $FILE_BASENAME == MVIMG_* ]]; then
	echo "Google Motion Photo file detected!  Extracting .mp4 and potentially a .jpg..."
	# googlemotionphotoextract.sh "$1"
else
	case $(file -b "$1") in
	  'JPEG '*)
	    echo "JPEG file $1 detected, proceeding with processing (optimize then shrink for best file size)..."
	    if imageoptimizejpeg.sh "$1" "$TEMP_OPTIMIZED_FILENAME" ; then 
		    if imageshrinktohd.sh "$TEMP_OPTIMIZED_FILENAME" "$TEMP_OPTIMIZED_STAGE2_FILENAME" ; then 
		    	mv "$TEMP_OPTIMIZED_STAGE2_FILENAME" "$TARGET_FOLDER/$FILE_BASENAME"
			    rm "$TEMP_OPTIMIZED_FILENAME"
			fi
		else
			echo "Input file must have already been optimized, just shrinking $1 instead..."
		    if imageshrinktohd.sh "$1" "$TEMP_OPTIMIZED_STAGE2_FILENAME" ; then 
		    	mv "$TEMP_OPTIMIZED_STAGE2_FILENAME" "$TARGET_FOLDER/$FILE_BASENAME"
			fi		
		fi
		if test -f "$TARGET_FOLDER/$FILE_BASENAME"; then
		    echo "Image processing appears to have succeeded and target file $TARGET_FOLDER/$FILE_BASENAME exists.  Removing source file and temp file."
		    rm "$1"
		fi	
	    ;;
	  *)
	    echo "$1 is not a JPEG file, skipping the processing and going straight to shrinking..."
	    if imageshrinktohd.sh "$1" "$TEMP_SHRUNK_IMAGE_OUTPUT_FILENAME" ; then 
	    	mv "$TEMP_SHRUNK_IMAGE_OUTPUT_FILENAME" "$TARGET_FOLDER/$FILE_BASENAME"
			if test -f "$TARGET_FOLDER/$FILE_BASENAME"; then
			    echo "Image processing appears to have succeeded and target file $TARGET_FOLDER/$FILE_BASENAME exists.  Removing source file."
			    rm "$1"
			fi
		fi
	    ;;
	esac
fi
