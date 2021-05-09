#!/bin/bash
# extract-mvimg: Extract .mp4 video and .jpg still image from a Pixel phone
# camera "motion video" file with a name like MVIMG_20191216_153039.jpg
# to make files like IMG_20191216_153039.jpg and IMG_20191216_153039.mp4
#
# From https://stackoverflow.com/a/59536201/3686125
#
# Usage: extract-mvimg MVIMG*.jpg [MVIMG*.jpg...]

for srcfile
do
  case "$srcfile" in
  MVIMG_*_*.jpg) ;;
  *)
    echo "extract-mvimg: skipping '$srcfile': not an MVIMG*.jpg file?" 2>&1
    continue
    ;;
  esac

  # Get base filename: strip leading MV and trailing .jpg
  # Example: MVIMG_20191216_153039.jpg becomes IMG_20191216_153039
  basefile=${srcfile#MV}
  basefile=${basefile%.jpg}

  # Get byte offset. Example output: 2983617:ftypmp4
  offset=$(grep -F --byte-offset --only-matching --text ftypmp4 "$srcfile")
  # Strip trailing text. Example output: 2983617
  offset=${offset%:*}

  echo "basefile=$basefile"
  echo "offset=$offset"

  # If $offset isn't an empty string, create .mp4 file and
  # truncate a copy of input file to make .jpg file.
  if [[ $offset ]]
  then

  	echo "Extracting .mp4 videos from $srcfile..."
    perl -0777 -ne 's/^.*(....ftypmp4.*)$/$1/s && print' "$srcfile" >"${srcfile%.jpg}.mp4";

  	echo "Removing .mp4 videos from $srcfile, leaving the single .jpg image..."
    perl -0777 -pi -e 's/^(.*?)....ftypmp4.*$/$1/s' "$srcfile";

    echo "Checking if we are left with a .jpg at all or was it just an .mp4, if so remove the 0-byte .jpg..."
    if [ -s "$srcfile" ] 
	then
		echo "$srcfile has some data.  We have a .jpg, probably, leaving it alone!"
	else
		echo "$srcfile is empty, deleting empty file..."
		rm -v "$srcfile"
	fi
 
 #Below method doesn't seem to work on my Vagrant Ubuntu Buster:
    # dd "if=$srcfile" "of=${basefile}.mp4" bs=$((offset-4)) skip=1
    # cp -ip "$srcfile" "${basefile}.jpg" || exit 1
    # truncate -s $((offset-4)) "${basefile}.jpg"

  else
    echo "extract-mvimg: can't find ftypmp4 in $srcfile; skipping..." 2>&1
  fi
done
