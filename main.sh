#!/bin/bash
#0 -> TRUE
#1 -> FALSE

#############################################################
#####		Tomasz Piescikowski			
#####		145418					
#####		Informatyka, grupa I2.2			
#####		Termin ukonczenia projektu: 26.06.2020	
#####		Zadanie 11: Zgadywanie stringow		
#############################################################
#####		CZESC GLOWNA PROGRAMU			
#############################################################

main () {	#main zeby przeniesc funkcje pod glowny program i poprawic estetyke

unset RANDOM; unset DYNAMIC; unset VERBOSE; unset NICE_VERBOSE
unset BIG; unset SMALL; unset DIGITS; unset TEST; unset LICZNIK	#unset wszystkiego zeby nie bylo problemow
unset LISTA; unset DLUGOSC; unset NOWY; unset LISTA1; unset LISTA2

DYNAMIC=1
RANDOM=1	
VERBOSE=1
NICE_VERBOSE=1	#zmienne
BIG="None"
SMALL="None"
DIGITS="None"
LICZNIK=0

while getopts ":drl:L:vhC:V" OPTION; do #wyciszone errory domyslne
	LICZNIK=$((LICZNIK+1))
	case $OPTION in	
		d) DYNAMIC=0; RANDOM=1;;
		r) DYNAMIC=1; RANDOM=0;;
		l) SMALL=$OPTARG; BIG="None"; DIGITS="None";;
		L) BIG=$OPTARG; SMALL="None"; DIGITS="None";;		#flagi z pomoca getopts
		C) DIGITS=$OPTARG; SMALL="None"; BIG="None";;
		v) VERBOSE=0; NICE_VERBOSE=1;;
		V) NICE_VERBOSE=0; VERBOSE=1;;
		h) helps;;		
		*) usage;; 
	esac; done

if [[ $LICZNIK == 0 ]]; then usage; fi #wlacza help jesli brak argumentow
if [[ $VERBOSE == 0 ]]; then set -x; fi  #wlaczenie verbose dokladnego
if [[ $DYNAMIC == 1 && $RANDOM == 1 ]]; then echo "Musisz wybrac strategie!!"; usage; fi
if [[ $BIG == "None" && $SMALL == "None" && $DIGITS == "None" ]]; then echo "Musisz wybrac typ inputu!"; usage; fi

LICZNIK=0	#wyzerowanie licznika na wszelki wypadek

if [[ $RANDOM == 0 ]]; then
	if [[ ! $BIG == "None" ]]; then random_big $BIG; fi	
	if [[ ! $SMALL == "None" ]]; then random_small $SMALL; fi
	if [[ ! $DIGITS == "None" ]]; then random_digits $DIGITS; fi	#wywolywanie funkcji, rozne kombinacje
else
	if [[ ! $BIG == "None" ]]; then dynamic_big $BIG; fi
	if [[ ! $SMALL == "None" ]]; then dynamic_small $SMALL; fi
	if [[ ! $DIGITS == "None" ]]; then dynamic_digits $DIGITS; fi
fi	
}

###################################################################
#####				FUNKCJE			      #####
###################################################################

usage () { echo -e "Sposob uzycia: $0 [-d|-r] [-v|-V| ] [<-l|-L|-C> <TEKST>]\nMozesz tez wpisac: $0 -h aby wywolac pomoc."; exit 2; }  #informacja o tym jak uzywac programu

##################	OPIS PIERWSZEJ FUNKCJI PASUJE DO NASTEPNYCH	   ########################

random_big () {
	TEST=$(echo $BIG | tr -d [:alpha:])	#sprawdza czy input jest taki jak podalismy na fladze przez usuniecie tych znakow
	if [[ -z $TEST ]]; then	#jezeli input wyzerowany, to znaczy ze jest poprawny i przechodzimy dalej
		if [[ $NICE_VERBOSE == 0 ]]; then 	#jezeli ladne verbose wlaczone to podajemy ladne dane
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$BIG\" poprawny"
			echo -e " -- Opcje: -r, -L, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi
		LISTA=($(echo $BIG | grep -o . | xargs))	#rozdzielamy ciag znakow na pojedyncze znaki
		DLUGOSC=${#LISTA[@]}		#ile bedzie tych znakow
		NOWY=$(cat /dev/urandom | tr -cd [A-Za-z] | tr -d [\[\]] | head -c $DLUGOSC)	#wylosowane slowo o danej dlugosci
		echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $BIG\nTrwa losowanie danych metoda losowa...\n"
		while [ ! $NOWY == $BIG ]; do #losuj dopoki input i nowe slowo nie beda takie same
			NOWY=$(cat /dev/urandom | tr -cd [A-Za-z] | tr -d [\[\]] | head -c $DLUGOSC)
			LICZNIK=$((LICZNIK+1))
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $NOWY"; fi	#wypisuj jesli NICE_VERBOSE wlaczone
		done
		echo "$BIG == $NOWY, znaleziono pasujace slowo po $LICZNIK testach, metoda losowa."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage	#jezeli input niepoprawny
		fi
 }

random_small () {
	TEST=$(echo $SMALL | tr -d [:lower:])
	if [[ -z $TEST ]]; then
		if [[ $NICE_VERBOSE == 0 ]]; then 
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$SMALL\" poprawny"
			echo -e " -- Opcje: -r, -l, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi 
		LISTA=($(echo $SMALL | grep -o . | xargs))
		DLUGOSC=${#LISTA[@]}
		NOWY=$(cat /dev/urandom | tr -cd [a-z] | tr -d [\[\]] | head -c $DLUGOSC)
		echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $SMALL\nTrwa losowanie danych metoda losowa...\n"
		while [ ! $NOWY == $SMALL ]; do
			NOWY=$(cat /dev/urandom | tr -cd [a-z] | tr -d [\[\]] | head -c $DLUGOSC)
			LICZNIK=$((LICZNIK+1))
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $NOWY"; fi
		done
		echo "$SMALL == $NOWY Znaleziono pasujace slowo po $LICZNIK testach, metoda losowa."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage
		fi
 }

random_digits () {
	TEST=$(echo $DIGITS | tr -d [:alnum:])
	if [[ -z $TEST ]]; then
		if [[ $NICE_VERBOSE == 0 ]]; then 
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$DIGITS\" poprawny"
			echo -e " -- Opcje: -r, -C, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi 
		LISTA=($(echo $DIGITS | grep -o . | xargs))
		DLUGOSC=${#LISTA[@]}
		NOWY=$(cat /dev/urandom | tr -cd [A-Za-z0-9] | tr -d [\[\]] | head -c $DLUGOSC)
		echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $DIGITS\nTrwa losowanie danych metoda losowa...\n"
		while [ ! $NOWY == $DIGITS ]; do
			NOWY=$(cat /dev/urandom | tr -cd [A-Za-z0-9] | tr -d [\[\]] | head -c $DLUGOSC)
			LICZNIK=$((LICZNIK+1))
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $NOWY"; fi
		done
		echo "$DIGITS == $NOWY	Znaleziono pasujace slowo po $LICZNIK testach, metoda losowa."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage
		fi
 }

 
dynamic_big () {
	TEST=$(echo $BIG | tr -d [:alpha:])
	if [[ -z $TEST ]]; then
		if [[ $NICE_VERBOSE == 0 ]]; then 
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$BIG\" poprawny"
			echo -e " -- Opcje: -d, -L, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi 
		 LISTA1=($(echo $BIG | grep -o . | xargs))
		 DLUGOSC=${#LISTA1[@]}
		 NOWY=$(cat /dev/urandom | tr -cd [a-zA-Z] | tr -d [\[\]] | head -c $DLUGOSC)
		 echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $BIG\nTrwa losowanie danych metoda dynamiczna...\n"
		 LISTA2=($(echo $NOWY | grep -o . | xargs))	
		 LICZNIK=0	 
		 while [[ ! ${LISTA1[@]} == ${LISTA2[@]} ]]; do
			for i in $(seq 0 $((DLUGOSC-1))); do
				if [[ ! ${LISTA2[$i]} == ${LISTA1[$i]} ]]; then	#losowanie pojedynczych elementow list
					LISTA2[$i]=$(cat /dev/urandom | tr -cd [a-zA-Z] | tr -d [\[\]] | head -c 1)
				fi
			done
			LICZNIK=$((LICZNIK+1))	#laczenie elementow spowrotem w stringa
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $(echo ${LISTA2[@]} | tr -d " ")"; fi
		done
		echo "$(echo ${LISTA1[@]} | tr -d " ") == $(echo ${LISTA2[@]} | tr -d " ") Znaleziono pasujace slowo po $LICZNIK testach, metoda dynamiczna."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage
		fi
}

dynamic_small () {
	TEST=$(echo $SMALL | tr -d [:lower:])
	if [[ -z $TEST ]]; then
		if [[ $NICE_VERBOSE == 0 ]]; then 
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$SMALL\" poprawny"
			echo -e " -- Opcje: -d, -l, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi 
		 LISTA1=($(echo $SMALL | grep -o . | xargs))
		 DLUGOSC=${#LISTA1[@]}
		 NOWY=$(cat /dev/urandom | tr -cd [a-z] | tr -d [\[\]] | head -c $DLUGOSC)
		 echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $SMALL\nTrwa losowanie danych metoda dynamiczna...\n"
		 LISTA2=($(echo $NOWY | grep -o . | xargs))	
		 LICZNIK=0	 
		 while [[ ! ${LISTA1[@]} == ${LISTA2[@]} ]]; do
			for i in $(seq 0 $((DLUGOSC-1))); do
				if [[ ! ${LISTA2[$i]} == ${LISTA1[$i]} ]]; then
					LISTA2[$i]=$(cat /dev/urandom | tr -cd [a-z] | tr -d [\[\]] | head -c 1)
				fi
			done
			LICZNIK=$((LICZNIK+1))
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $(echo ${LISTA2[@]} | tr -d " ")"; fi
		done
		echo "$(echo ${LISTA1[@]} | tr -d " ") == $(echo ${LISTA2[@]} | tr -d " ") Znaleziono pasujace slowo po $LICZNIK testach, metoda dynamiczna."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage
		fi
}

dynamic_digits () {
	TEST=$(echo $DIGITS | tr -d [:alnum:])
	if [[ -z $TEST ]]; then
		if [[ $NICE_VERBOSE == 0 ]]; then 
			echo -e " -- Uzywana funkcja: ${FUNCNAME[0]}"
			echo -e " -- Input: \"$DIGITS\" poprawny"
			echo -e " -- Opcje: -d, -C, -V"
			echo -e " -- Start w ciagu 5 sekund..."
			sleep 5s; fi 
		 LISTA1=($(echo $DIGITS | grep -o . | xargs))
		 DLUGOSC=${#LISTA1[@]}
		 NOWY=$(cat /dev/urandom | tr -cd [a-zA-Z0-9] | tr -d [\[\]] | head -c $DLUGOSC)
		 echo -e "\nWylosowano slowo: $NOWY		Szukane slowo: $DIGITS\nTrwa losowanie danych metoda dynamiczna...\n"
		 LISTA2=($(echo $NOWY | grep -o . | xargs))	
		 LICZNIK=0	 
		 while [[ ! ${LISTA1[@]} == ${LISTA2[@]} ]]; do
			for i in $(seq 0 $((DLUGOSC-1))); do
				if [[ ! ${LISTA2[$i]} == ${LISTA1[$i]} ]]; then
					LISTA2[$i]=$(cat /dev/urandom | tr -cd [a-zA-Z0-9] | tr -d [\[\]] | head -c 1)
				fi
			done
			LICZNIK=$((LICZNIK+1))
			if [[ $NICE_VERBOSE == 0 ]]; then echo "Test $LICZNIK: $(echo ${LISTA2[@]} | tr -d " ")"; fi
		done
		echo "$(echo ${LISTA1[@]} | tr -d " ") == $(echo ${LISTA2[@]} | tr -d " ") Znaleziono pasujace slowo po $LICZNIK testach, metoda dynamiczna."
	else echo -e "ERROR: Tekst jest niepoprawny!"; usage
		fi
}

helps () {
	echo -e "Skrypt zgaduje ci??g znak??w przez kilka iteracji za pomoc?? jednej z dw??ch strategii.

U??ytkownik podaje za pomoc?? parametr??w ci??g znak??w kt??ry ma zosta?? odgadni??ty, oraz strategi?? kt??ra ma zosta?? u??yta do odgadni??cia ci??gu: przyrostow?? lub losow??.

Dla strategii losowej skrypt generuje nowy string o d??ugo??ci tej samej co wz??r co iteracj?? i por??wnuje go ze wzorem podanym rpzez u??ytkownika. Skrypt ko??czy dzia??anie je??li s?? one identyczne.

Dla strategii przyrostowej skrypt generuje losowy string o d??ugo??ci tej samej co wz??r i por??wnuje go ze wzorem podanym rpzez u??ytkownika. Wszystkie litery kt??re s?? takie same s?? zachowywane na swoich pozycjach, natomiast wszystkie inne s?? losowane ponownie. Skrypt ko??czy dzia??anie w momencie kiedy string b??dzie identyczny ze wzorem.

U??ytkownik mo??e zdefiniowa?? przez parametry ??eby losowane by??y tylko ma??e litery lub wielkie i ma??e litery. Nale??y wtedy tak??e sprawdzi?? czy string wz??r zawiera tylko litery wyspecyfikowane przez u??ytkownika i zako??czy?? dzia??anie z b????dem jesli tak nie jest.

Skrypt wy??wietla pomoc (wszystkie parametry i ich obja??nienia) je??li u??ytkownik poda parametr -h.\n"


	
	echo -e "Dostepne flagi:\n"
	echo -e "-d	strategia dynamiczna"
	echo -e "-r	strategia losowa"
	echo -e "-l	male litery"
	echo -e "-L	male i duze litery"
	echo -e "-C	male i duze litery, oraz cyfry"
	echo -e "-v	debugger verbose"
	echo -e "-V	estetyczne verbose"
	exit 2
} 

main "$@"   #wywolanie programu










	 

