###chmod +x ~/mikrotik_chr/mikrotik_ssl_update.sh
DIR=~/public_html/chr/ssl/lets_encrypt

FILE_crt=$(find ~/ssl/certs -name *.crt | sort -n | tail -1)
FILE_key=$(find ~/ssl/keys -name *.key | sort -n | tail -1)

if [ -d "$DIR" ]; then
  echo "Directory EXISTS"
  if [ "$(ls -A $DIR)" ] 
  then
	 echo "Directory is NOT EMPTY. Cleaning Directory"
     rm -r $DIR/*
	 echo "Directory is NOW EMPTY"
  else
     echo "Directory is EMPTY"
  fi
else
  echo "Directory does NOT EXIST"
  mkdir -p $DIR
  echo "Directory has been CREATED"
  if [ "$(ls -A $DIR)" ] 
  then
	 echo "Directory is NOT EMPTY. Cleaning Directory"
     rm -r $DIR/*
	 echo "Directory is NOW EMPTY"
  else
     echo "Directory is EMPTY"
  fi
fi

if [ -z "$FILE_crt" ] 
then
	echo "Latest CRT File Variable is EMPTY"
else
	echo "Latest CRT File: "$FILE_crt
	cp $FILE_crt $DIR/skynode_link.crt
	chmod 644 $DIR/skynode_link.crt
fi

if [ -z "$FILE_key" ] 
then
	echo "Latest KEY File Variable is EMPTY"
else
	echo "Latest KEY File: "$FILE_key
	cp $FILE_key $DIR/skynode_link.key
	chmod 644 $DIR/skynode_link.key
fi
