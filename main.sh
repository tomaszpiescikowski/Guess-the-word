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
	echo -e "Skrypt zgaduje ciąg znaków przez kilka iteracji za pomocą jednej z dwóch strategii.

Użytkownik podaje za pomocą parametrów ciąg znaków który ma zostać odgadnięty, oraz strategię która ma zostać użyta do odgadnięcia ciągu: przyrostową lub losową.

Dla strategii losowej skrypt generuje nowy string o długości tej samej co wzór co iterację i porównuje go ze wzorem podanym rpzez użytkownika. Skrypt kończy działanie jeśli są one identyczne.

Dla strategii przyrostowej skrypt generuje losowy string o długości tej samej co wzór i porównuje go ze wzorem podanym rpzez użytkownika. Wszystkie litery które są takie same są zachowywane na swoich pozycjach, natomiast wszystkie inne są losowane ponownie. Skrypt kończy działanie w momencie kiedy string będzie identyczny ze wzorem.

Użytkownik może zdefiniować przez parametry żeby losowane były tylko małe litery lub wielkie i małe litery. Należy wtedy także sprawdzić czy string wzór zawiera tylko litery wyspecyfikowane przez użytkownika i zakończyć działanie z błędem jesli tak nie jest.

Skrypt wyświetla pomoc (wszystkie parametry i ich objaśnienia) jeśli użytkownik poda parametr -h.\n"


	
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










	 

