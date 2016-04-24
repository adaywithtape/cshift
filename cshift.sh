#!/bin/bash
#Caesar cipher Shift checker
#cshift.sh v0.4
#By TAPE 
#Last edit 28-05-2013 21:00
#Written on and intended for use on Kali Linux
#
##
###
VERS=$(sed -n 3p $0 | cut -d " " -f 2)
STD=$(echo -e "\e[0;0;0m")
R=$(echo -e "\e[0;31m")
RB=$(echo -e "\e[1;31m")
G=$(echo -e "\e[0;32m")
GB=$(echo -e "\e[1;32m")
B=$(echo -e "\e[0;36m")
BB=$(echo -e "\e[1;36m")
#
##
###HEADER
#########
f_header() {
echo $BB"           _     _  __ _   
          | |   (_)/ _| |  
   ___ ___| |__  _| |_| |_ 
  / __/ __| '_ \| |  _| __|
 | (__\__ \ | | | | | | |_ 
  \___|___/_| |_|_|_|  \__|
$STD Caesar cipher shift checker
"
}
#
##
###VERSION
##########
f_version() {
clear
f_header
echo " cshift $RB$VERS$STD"
echo " By TAPE"
echo " Last edit 28-05-2013"
echo
exit 0
}
#
##
###VARIABLES
############
INPUT=
SHIFT=
BRUTE=0
DIC=
IFS=""
#
##
###CTRL-C TRAP
##############
f_ctrl_c() {
if [ -f brute_dic.tmp ] ; then rm brute_dic.tmp
elif [ -f freq.tmp ] ; then rm freq.tmp
elif [ -f freq1.tmp ] ; then rm freq1.tmp
elif [ -f freq2tmp ] ; then rm freq2.tmp
fi
echo $STD""
exit 0
}
#
##
###HELP / INFO 
##############
f_help() {
echo $STD"GENERAL USAGE: 
./cshift.sh -i 'Input Text to check' -s shift_value 

OPTIONS:
-i  Input to run script on 
-s  Shift value (numeric)
-b  Bruteforce test of all shifts
-w  Wordlist/Dictionary check on bruteforce results (use with -b)
    (Run on input of a single, long word)
-c  Dont use colours
-f  Letter frequency analysis on input file
-h  This help information
-v  Version information

EXAMPLES
./cshift.sh -i 'Jhlzhy Zhshk' -s 19
./cshift.sh -i file.txt -s 7
./cshift.sh -i 'Jhlzhy Zhshk' -b
./cshift.sh -i 'puclzapnhapvu' -b -w dictionary.txt
./cshift.sh -i file.txt -f"
exit 0
}
#
##
###RUN CHECK ON INPUT WITH FIXED SHIFT_VALUE
############################################
f_input() {
SHIFT=$(expr $SHIFT % 26)
if (($SHIFT<0)) ; then
SHIFT=$(expr $SHIFT % 26 + 26)
fi

echo $INPUT |
while IFS= read -r -n1 c
do
c=$(printf "%d\n" \'$c)

if (($c>=65 && $c<=90)) || (($c>=97 && $c<=122)) ; then
	enc=$(expr $c + $SHIFT)
	if (($c>=65 && $c<=90)) && (($enc>90)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c>=97 && $c<=122)) && (($enc>122)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c<65)) || (($c>90 && $c<97)) || (($c>122)) ; then
	enc=$c
	fi
	else enc=$c
fi
printf $GB"\x$(printf %x $enc)"$STD
done
echo
echo
}
#
##
###BRUTEFORCE CHECKS
####################
f_brute() {
for SHIFT in {1..26} ; do SHIFT=$((expr $SHIFT - 26)|sed 's/-//') & printf "[$BB%2d$STD]--> %s" "$SHIFT" && echo "$INPUT" |
while IFS= read -r -n1 c
do
c=$(printf "%d\n" \'$c)

if (($c>=65 && $c<=90)) || (($c>=97 && $c<=122)) ; then
	enc=$(expr $c + $SHIFT)
	if (($c>=65 && $c<=90)) && (($enc>90)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c>=97 && $c<=122)) && (($enc>122)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c<65)) || (($c>90 && $c<97)) || (($c>122)) ; then
	enc=$c
	fi
	else enc=$c
fi
printf $GB"\x$(printf %x $enc)"$STD
done
echo
done
}
#
##
###BRUTEFORCE CHECKS WITH DIC
#############################
f_brute_dic() {
for SHIFT in {1..26} ; do SHIFT=$((expr $SHIFT - 26)|sed 's/-//') & printf "[%2d]--> %s" "$SHIFT" && echo "$INPUT" |
while IFS= read -r -n1 c
do
c=$(printf "%d\n" \'$c)

if (($c>=65 && $c<=90)) || (($c>=97 && $c<=122)) ; then
	enc=$(expr $c + $SHIFT)
	if (($c>=65 && $c<=90)) && (($enc>90)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c>=97 && $c<=122)) && (($enc>122)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c<65)) || (($c>90 && $c<97)) || (($c>122)) ; then
	enc=$c
	fi
	else enc=$c
fi
printf "\x$(printf %x $enc)"
done
echo
done > brute_dic.tmp
	while read -r line ; do
	x=$(echo $line | sed 's/.*\(> \)//')
	if grep -q -i $x $DIC ; then
	echo "$line $GB<-- Possible decoded text$STD"
	else
	echo "$line $RB<--$STD"
	fi
	done < brute_dic.tmp
	rm brute_dic.tmp
echo
}
#
##
###RUN SHIFT ON FILE
####################
f_file() {
SHIFT=$(expr $SHIFT % 26)
if (($SHIFT<0)) ; then
SHIFT=$(expr $SHIFT % 26 + 26)
fi

while IFS= read -r -n1 c
do
c=$(printf "%d\n" \'$c)

if (($c>=65 && $c<=90)) || (($c>=97 && $c<=122)) ; then
	enc=$(expr $c + $SHIFT)
	if (($c>=65 && $c<=90)) && (($enc>90)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c>=97 && $c<=122)) && (($enc>122)) ; then
	enc=$(expr $c + $SHIFT - 26)
	elif (($c<65)) || (($c>90 && $c<97)) || (($c>122)) ; then
	enc=$c
	fi
	else enc=$c
fi
printf "\x$(printf %x $enc)"
done < "$INPUT"
echo
echo
}
#
##
###SUBSTITUTION SCRIPT
######################
f_replace() {
if [ ! -f $INPUT ] ; then
echo $RB"Input error [$STD -i $INPUT $RB]$STD
Run on input file only"
echo
exit 0 
fi 
#Replace the characters as desired, save and and run on text again.
#Example to replace 'a' with 'Z' edit as: -e 's/a/a/g' \  -->  -e 's/a/Z/g' \
cat $INPUT | tr '[:upper:]' '[:lower:]' | sed \
-e 's/a/a/g' \
-e 's/b/b/g' \
-e 's/c/c/g' \
-e 's/d/d/g' \
-e 's/e/e/g' \
-e 's/f/f/g' \
-e 's/g/g/g' \
-e 's/h/h/g' \
-e 's/i/i/g' \
-e 's/j/j/g' \
-e 's/k/k/g' \
-e 's/l/l/g' \
-e 's/m/m/g' \
-e 's/n/n/g' \
-e 's/o/o/g' \
-e 's/p/p/g' \
-e 's/q/q/g' \
-e 's/r/r/g' \
-e 's/s/s/g' \
-e 's/t/t/g' \
-e 's/u/u/g' \
-e 's/v/v/g' \
-e 's/w/w/g' \
-e 's/x/x/g' \
-e 's/y/y/g' \
-e 's/z/z/g'
echo
echo
echo -ne $BB"Edit substitution characters currently in use ? y/n "$GB
read replace
echo $STD
if [[ "$replace" == "y" || "$replace" == "Y" ]] ; then 
nano +231 $0
exit 0
else
exit 0
fi
exit 0
}
#
##
###LETTER FREQUENCY ANALYSIS
############################
f_freq() {
if [ ! -f $INPUT ] ; then 
echo $RB"Input error [$STD -i $INPUT $RB]$STD
Can only run letter frequency analysis on file"
echo
exit 0
fi
#number of letters in file;
total=$(cat $INPUT | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z]//g' $1 | wc -c)
#number of each letter in file;
for i in {A..Z}
do count=$(cat $INPUT | tr '[:lower:]' '[:upper:]' | grep -o $i | wc -l) 
#percentage value for each letter in file;
perc=$(echo "scale=6;$count/$total*100" | bc | sed 's/^\./0./')
echo -e "$i\t$perc" >> freq.tmp
done
echo -e $BB"LETTER\tPERCENTAGE$STD$GB\tENGLISH STANDARD$STD"
echo -e "------\t----------\t----------------"
sort -n -k2 -r freq.tmp -o freq1.tmp
echo "E - 12.7020 %
T - 9.0560 %
A - 8.1670 %
O - 7.5070 %
I - 6.9662 %
N - 6.7490 %
S - 6.3270 %
H - 6.0940 %
R - 5.9870 %
D - 4.2530 %
L - 4.0250 %
C - 2.7820 %
U - 2.7580 %
M - 2.4060 %
W - 2.3600 %
F - 2.2280 %
G - 2.0150 %
Y - 1.9740 %
P - 1.9290 %
B - 1.4920 %
V - 0.9780 %
K - 0.7720 %
J - 0.1530 %
X - 0.1500 %
Q - 0.0950 %
Z - 0.0740 %" > freq2.tmp
paste -d "\t" freq1.tmp freq2.tmp
rm freq.tmp
rm freq1.tmp
rm freq2.tmp
echo
exit 0
}
#
##
###OPTION FUNCTIONS
###################
while getopts ":bcfhi:rs:vw:" opt; do
  case $opt in
	b) 
	BRUTE=1 ;;
	c)
	read R RB G GB B BB <<< $(echo -e "\e[0;0;0m")
	;;
	f)
	f_freq ;;
	h) 
	f_help ;;
	i) 
	INPUT=$OPTARG ;;
	r)
	f_replace ;;
	s)
	SHIFT=$OPTARG ;;
	w) 
	DIC=$OPTARG ;;	
	v)
	f_version ;;
  esac
done
#
##
###
trap f_ctrl_c INT
#
##
###INPUT CHECKS
###############
if [ $# == 0 ] ; then
f_header
f_help
elif [[ -z $INPUT ]] ; then 
echo
echo -e $RB"Input error [$STD missing -i $RB]$STD
Input text/file required\n"$STD
sleep 1
f_help
elif [[ -n $INPUT ]] && [[ -z $SHIFT && $BRUTE -eq 0 ]] ; then
echo
echo -e $RB"Input error [$STD missing -s / -b $RB]$STD
Enter numeric shift value with -s or enter -b for bruteforce check on input\n"$STD
sleep 1
f_help
elif [[ -f $INPUT ]] && [[ $BRUTE -eq 1 ]] ; then
echo
echo -e $RB"Input error [$STD -b $RB]$STD
Bruteforce checks on files not possible\n"
sleep 1
f_help
elif [ ! `expr $SHIFT + 1 2> /dev/null` ] ; then
echo
echo -e $RB"Input error [$STD -s $SHIFT $RB]$STD
Only numeric values possible for shift values\n"
sleep 1
f_help
elif [[ -n $SHIFT ]] && [[ $BRUTE -eq 1 ]] ; then
echo
echo -e $RB"Input error [$STD -s $SHIFT -b $RB]$STD
Cannot enter a shift value together with bruteforce value -b\n"
sleep 1
f_help
fi
#
##
###RUNNING SCRIPT
#################
if [ -f "$INPUT" ] ; then
f_file
exit 0
elif [[ ! -f "$INPUT" ]] && [[ -n $SHIFT ]] ; then
f_input
exit 0
elif [[ $BRUTE -eq 1 ]] && [[ -z $DIC ]]   ; then
f_brute
exit 0
elif [[ $BRUTE -eq 1 ]] && [[ -n $DIC ]]   ; then
	if [ ! -f $DIC ] ; then
	echo
	echo $RB"Input error [$STD -w $DIC $RB]$STD"
	echo "Cannot find '$DIC'"
	echo
	exit 0
	else
	echo
	f_brute_dic
exit 0
fi
fi
exit 0
# The End
#
##
###Version History
###################
#Version 0.1 Released 11-05-2013
#
#Version 0.2 Updated on 20-05-2013
#- Updated output formatting on 'brute force' checks
#- Bolded colours.
#
#Version 0.3 Updated on 22-05-2013
#- Major change in usage, getopts functions with required switches included.
#- Bruteforce result checks on dictionary included.
#
#Version 0.4 Updated on 26-05-2013
#- Included a letter frequency analysis.
#- Included replacement script (-r) but kept hidden from main menu.
#- Altered bruteforce option to -b, seemed more logical.
