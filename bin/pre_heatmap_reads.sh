#!/bin/env bash

##header done
## cutoff eg >200 reads
cutoff=200
####PHYLUM

for i in *pavian_report_filtered.csv ; do

	samplename=$(echo "$i" | awk -F"_pavian_report_filtered.csv" '{print $1}')

## get experiment deplete or enrich
	if [[ "$i" == *"depletion"* ]]
	then 
	  experiment="depletion"
	elif [[ "$i" == *"enrich"* ]]
	then
	  experiment="enrich"
	else
	  experiment="deep"
	fi

########### Phylum
	cat $i | grep -w "P" | cut -f1,2,6 | tr "\t" "," | tr -d  " " | awk -v z="$cutoff" -F"," '$2>=z' > tmp1_"$i"
	# add column:  samplename
	awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$4=d; print}' tmp1_"$i" > tmp2_"$i"
	# add experiment column
	awk -v f="$experiment" -F"," 'BEGIN { OFS = "," } {$5=f; print}' tmp2_"$i" > phylum_only_"$i"
	
	
########### Genus
# get abundance and genus name
	cat $i | grep -w "G" | cut -f1,2,6 | tr "\t" "," | tr -d  " " | awk -v z="$cutoff" -F"," '$2>=z' > tmp1_"$i"
	# add column:  samplename
	awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$4=d; print}' tmp1_"$i" > tmp2_"$i"
	# add experiment column
	awk -v f="$experiment" -F"," 'BEGIN { OFS = "," } {$5=f; print}' tmp2_"$i" > genus_only_"$i"

	
############ Class
# get abundance and class name
	cat $i | grep -w "C" | cut -f1,2,6 | tr "\t" "," | tr -d  " " | awk -v z="$cutoff" -F"," '$2>=z' > tmp1_"$i"
	# add column:  samplename
	awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$4=d; print}' tmp1_"$i" > tmp2_"$i"
	# add experiment column
	awk -v f="$experiment" -F"," 'BEGIN { OFS = "," } {$5=f; print}' tmp2_"$i" > class_only_"$i"

	
############ Species
# get abundance and species name
	cat $i | grep -w "S" | cut -f1,2,6 | tr "\t" "," | tr -s " " | awk -v z="$cutoff" -F"," '$2>=z' | awk '{sub(/^ +/,""); gsub(/, /,",")}1' > tmp1_"$i"
	# add column:  samplename
	awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$4=d; print}' tmp1_"$i" > tmp2_"$i"
	# add experiment column
	awk -v f="$experiment" -F"," 'BEGIN { OFS = "," } {$5=f; print}' tmp2_"$i" > species_only_"$i"
	
done


# create files for facet grid plot
cat phylum_only* > phylum_plot.csv
sed -i '1s/.*/Abundance,reads,Organism,Sample_name,experiment\n&/' phylum_plot.csv

cat genus_only* > genus_plot.csv
sed -i '1s/.*/Abundance,reads,Organism,Sample_name,experiment\n&/' genus_plot.csv

cat class_only* > class_plot.csv
sed -i '1s/.*/Abundance,reads,Organism,Sample_name,experiment\n&/' class_plot.csv

cat species_only* > species_plot.csv
sed -i '1s/.*/Abundance,reads,Organism,Sample_name,experiment\n&/' species_plot.csv
## remove data trash
rm phylum_only* genus_only* class_only* species_only* tmp1* tmp2*