#!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp" # where to output data
data_bucket="/spaces/ngdr/ref-data/abcd/nda-3165-2020-09/derivatives/abcd-hcp-pipeline"
out_dir="/home/feczk001/shared/projects/crossotope/OUTPUTS/ABCD/LRvalues_ALL_HCP_ROIs"

run_folder=`pwd`

crossotope_folder="${run_folder}/run_files.crossotope_full"
crossotope_template="template.crossotope_full_run"
roi_groups="${run_folder}/ROIlists"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders exist delete them and recreate
if [ -d "${crossotope_folder}" ]; then
	rm -rf "${crossotope_folder}"
	mkdir "${crossotope_folder}"
else
	mkdir "${crossotope_folder}"
fi

# counter to create run numbers
k=0

for i in $(find ${data_bucket} -maxdepth 1 -type d -name "sub-*"); do
	subj_id=$(basename "$i" | cut -d'-' -f2)
	for j in $(find "$i" -maxdepth 1 -type d -name "ses-*Arm1"); do
		ses_id=$(basename "$j" | cut -d'-' -f2)
		if [ "$ses_id" = "baselineYear1Arm1" ]; then
			for r in ${roi_groups}/*; do 
				roi_list="$r" 
				sed -e "s|ROIBATCH|${roi_list}|g" -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" -e "s|OUTDIR|${out_dir}|g" ${run_folder}/${crossotope_template} > ${crossotope_folder}/run${k}
				k=$((k+1))
			done
		fi
	done
done

chmod 775 -R ${crossotope_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_crossotope_full_run.sh 