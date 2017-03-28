#!/bin/sh
# Manuale istruzioni
  showHelp () {
    echo "--------------------------------------"
    echo "--------- MANUAL / HELP PAGE ---------"
    echo "--------------------------------------"
    echo
    echo "--config        configurazione delle cartelle sorgente e destinazione"
    echo
    echo "--help/--man/-h        mostra questa pagina"
    echo
    echo
    exit
  }

# colours
# --------------------------
# colori testo
RED=`tput setaf 1`
GREEN=`tput setaf 2`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
YELLOW=`tput setaf 3`

# colori sfondo
RED_BG=`tput setab 1`
GREEN_BG=`tput setab 2`
BLUE_BG=`tput setab 4`

# reset dei colori
COLOR_RESET=`tput sgr0`

# inizializzazione
CONFIG=false
SOURCE="/home/$USER/Documenti/"
DESTINATION="/home/$USER/Musica/"
# file di configurazione del backup
CONFIG_FILE="/home/alessandro/Musica/00.backup"
COUNTER=0

# parsing degli argomenti
for i in "$@"
do
    case $i in

        --config)
            CONFIG=true
            shift
            ;;

        --help|--man|-h)
            showHelp
            shift
            ;;
        *)

        ;;
    esac
done

# Messaggio di avvio
# (conferma a procedere)
echo "${GREEN}\navvio backup\n"
echo
echo ---------------------------------------------

read -p "continue (s/n)?" choice
case "$choice" in
  s|S ) echo "si";;
  n|N ) echo "no"; return;;
  * ) echo "invalid";;
esac

echo ---------------------------------------------

if [ "$CONFIG" = true ] ; then
  # creazione file di configurazione del backup
  # inserimento sorgente
  echo Inserire percorso della cartella sorgente seguito da INVIO
  read SOURCE
  echo $SOURCE > $CONFIG_FILE

  # test se sorgente fornita esiste
  if [ ! -d "$SOURCE" ]; then
    echo "la Directory fornita non esiste"
    exit 0
  fi

  # inserimento destinazione
  echo Inserire percorso della cartella destinazione seguito da INVIO
  read DESTINATION
  echo $DESTINATION >> $CONFIG_FILE

  # gestione destinazione non esistente
  if [ ! -d "$DESTINATION" ]; then
    echo "${RED}la Directory fornita non esiste, vuoi crearla?"
    read -p "continue (s/n)?" choice

    # conferma creazione destinazione non esistente
    case "$choice" in
      s|S ) echo "si"; mkdir $DESTINATION;;
      n|N ) echo "no"; return;;
      * ) echo "invalid";;
    esac
  fi

  #test di verifica se il file è esistente
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "file non trovato"
    read -p "continue (s/n)?" choice
  fi

else
  # esecuzione backup da file di configurazione precedentemente creato
  echo "Lettura del file di configurazione..."
  while read -r line
  do
    COUNTER=$((COUNTER+1))

    if [ $COUNTER = 1 ]; then
      SOURCE=$line
    else
      DESTINATION=$line
    fi

  done < "$CONFIG_FILE"
fi

# Esegui backup!!!
echo "backup dei file da $SOURCE a $DESTINATION"
rsync -avd $SOURCE $DESTINATION

# messaggio di conclusione
echo
echo "${BLUE}backup terminato"
echo ---------------------------------------------
