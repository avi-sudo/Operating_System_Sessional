#!/bin/bash
#touch list.txt
#touch list3.txt
#touch output.csv
root="$(realpath .)"
if [ -f output.csv ];then
rm output.csv
fi
echo "File_Path,Line_Number,Line_Containing_searched_String" >> output.csv
if [ -d $root/output_dir ];then
rm -r $root/output_dir
fi
mkdir -p $root/output_dir

#echo ${#root}
output_directory_path=$(realpath $root/output_dir)
#echo $output_directory_path
func1()
{
	if [ ! -f $1 ]
	then
	echo "input file does not exist"
	echo "please give a valid input file name"
        read line
	command=$(head -1 $line)
	line_no=$(head -2 $line | tail -1)
	searching_word=$(head -3 $line | tail -1)
	#echo $command
	#echo $line_no
	#echo $searching_word
	else
	input=$1
	command=$(head -1 $input)
	line_no=$(head -2 $input | tail -1)
	searching_word=$(head -3 $input | tail -1)
	#echo $command
	#echo $line_no
	#echo $searching_word
	fi
}
if [ $# -eq 2 ]
then
input_file=$2
d=$1
c="${d%/*}"
#echo $c
#cd $1
func1 $2
elif [ $# -eq 1 ]
then
input_file=$1
#directory=$(pwd)/working_dir/
d=working_dir
c=$root
#echo $c
func1 $1
else 
echo "please run the script by giving an input file name"
read line
d=working_dir
c=$root
func1 $line
fi
number_of_file=0
p=$(realpath working_dir)
#echo $directory
#c="${d%/*}"
#echo ${#c}
searching_function()
{
 
	cd "$1"
	
	for i in *
	do
		if [ -d "$i" ];then
#echo $i
		searching_function "$i"
		else
			if file "$i"|grep -qi text ;then
#echo $i
				if [ $command = "begin" ];then
					 if head -n $line_no $i | grep -qi $searching_word ;then
						y=$(realpath $i)
						extension="${y##*.}"
	#echo ${#extension}
						file_name="${y%.*}"
						
						searched_line_number=$(head -n $line_no $i | grep -ni $searching_word | head -n 1 | cut -d ':' -f 1)
						echo "$(head -n $line_no $i | grep -ni $searching_word)" >> ~/Documents/list4.txt
#echo $searched_line_number
						searched_line=$(head -n $line_no $i | grep -ni $searching_word | head -n 1 | cut -d ':' -f 2) 
						
						if [ ${#extension} -le 10 ];then
						  new_file_name="${file_name}_${searched_line_number}.${extension}"
						else 
						  new_file_name="${file_name}_${searched_line_number}"
						  fi
						#cp $i "${output_directory_path}/${new_file_name}"
					echo "${new_file_name}" > ~/Documents/list.txt
						l1=${#new_file_name}
						l2=${#c}
						l3=$(($l2+2))
						cut -c$l3-$l1 ~/Documents/list.txt > ~/Documents/list3.txt
						#cut -d '/' -f 5- ~/Documents/list.txt > ~/Documents/list3.txt
						sed 's/\//\./g' ~/Documents/list3.txt > ~/Documents/list2.txt
						
						while read line 
							do
							new_name=$line
							
							cp $i "${output_directory_path}/${new_name}"
							done < ~/Documents/list2.txt
						while read line 
							do
							new_name1=$line
							
							#cp $i "${output_directory_path}/${new_name}"
							done < ~/Documents/list3.txt
						ext="${new_name1##*.}"
	#echo ${#extension}
						fn="${new_name1%.*}"
#echo $fn+see
						fn1="${fn%_*}"
#echo $fn1
						if [ ${#ext} -le 10 ];then
						fn2="${fn1}.${ext}"
						else 
						fn2="${fn1}"
						fi
						while read line
						do
						var=$line
						searched_line2=$(echo $var | cut -d ':' -f 2) #| sed 's/\,/\ /g')
						searched_line_number2=$(echo $var | cut -d ':' -f 1)
						#echo $searched_line2
						echo "\"$fn2\",$searched_line_number2,\"$searched_line2\"" >> $root/output.csv
						done < ~/Documents/list4.txt
						rm ~/Documents/list4.txt
						#echo "$fn2,$searched_line_number,$searched_line" >> $root/output.csv
						number_of_file=`expr $number_of_file + 1`
						fi
				elif [ $command = "end" ];then
			
					 if tail -n $line_no $i | grep -qi $searching_word;then
						y=$(realpath $i)
						extension="${y##*.}"
	#echo ${#extension}
						file_name="${y%.*}"
						line_number=$(tail -n $line_no $i | grep -ni $searching_word | tail -n 1 | cut -d ':' -f 1)
#echo $line_number+avi				
						echo "$(tail -n $line_no $i | grep -ni $searching_word)" >> ~/Documents/list4.txt	
						searched_line=$(tail -n $line_no $i | grep -ni $searching_word | tail -n 1 | cut -d ':' -f 2) 
						
						total_line=$(wc -l $i | cut -d ' ' -f 1)
#echo $total_line+da
						a=$(($total_line-$line_no))
						#echo $a+c
						searched_line_number=$(($a+$line_number))
		#echo $searched_line_number-ed
						if [ ${#extension} -le 10 ];then
						  new_file_name="${file_name}_${searched_line_number}.${extension}"
						else 
						  new_file_name="${file_name}_${searched_line_number}"
						  fi
						echo "${new_file_name}" > ~/Documents/list.txt
						l1=${#new_file_name}
						l2=${#c}
						
						l3=$(($l2+2))
						cut -c$l3-$l1 ~/Documents/list.txt > ~/Documents/list3.txt
						#cut -d '/' -f 5- ~/Documents/list.txt > ~/Documents/list3.txt
						sed 's/\//\./g' ~/Documents/list3.txt > ~/Documents/list2.txt
						
						while read line 
							do
							new_name=$line
							
							cp $i "${output_directory_path}/${new_name}"
							done < ~/Documents/list2.txt
						
						while read line 
							do
							new_name1=$line
							
							#cp $i "${output_directory_path}/${new_name}"
							done < ~/Documents/list3.txt
						ext="${new_name1##*.}"
	#echo ${#extension}
						fn="${new_name1%.*}"
#echo $fn+see
						fn1="${fn%_*}"
#echo $fn1
						if [ ${#ext} -le 10 ];then
						fn2="${fn1}.${ext}"
						else 
						fn2="${fn1}"
						fi
						while read line
						do
						var=$line
						searched_line2=$(echo $var | cut -d ':' -f 2) #| sed 's/\,/\ /g')
						line_number2=$(echo $var | cut -d ':' -f 1)
						ab=$(($total_line-$line_no))
						
						searched_line_number2=$(($ab+$line_number2))
						echo "\"$fn2\",$searched_line_number2,\"$searched_line2\"" >> $root/output.csv
						done < ~/Documents/list4.txt
						rm ~/Documents/list4.txt
						#echo "$fn2,$searched_line_number,$searched_line" >> $root/output.csv
						number_of_file=`expr $number_of_file + 1`
						
						fi
				fi
			else echo "$i" is a non readable file >> ~/Documents/d.txt
			fi
		fi
	done
	cd ../
	echo $number_of_file > ~/Documents/os.txt
}
searching_function $d
#echo $number_of_file
while read line 
do
a=$line
echo "The Total Number of Matched Files is $a"
done < ~/Documents/os.txt
#cut -d '/' -f 5- list.txt > list3.txt
#sed 's/\//\./g' list3.txt > list2.txt
rm ~/Documents/list.txt
rm ~/Documents/list2.txt
rm ~/Documents/list3.txt

rm ~/Documents/d.txt
rm ~/Documents/os.txt
