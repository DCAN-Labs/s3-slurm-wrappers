#!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp" # where to output data
data_bucket="s3://ADHD_ASD"
rois_dir="/home/faird/shared/projects/wlf-test/fr/output-half-HCP"

run_folder=`pwd`

crossotope_folder="${run_folder}/run_files.crossotope_full"
crossotope_template="template.crossotope_full_run"

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

for i in `s3cmd ls ${data_bucket}/derivatives/adhd_prisma/derivatives/abcd-hcp-pipeline/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/derivatives/adhd_prisma/derivatives/abcd-hcp-pipeline/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
				for r in ${rois_dir}/L_*/; do 
					roi_dir=$(basename "$r") 
					sed -e "s|ROIDIR|${roi_dir}|g" -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${crossotope_template} > ${crossotope_folder}/run${k}
					k=$((k+1))
				done				
			fi
		done
	fi
done

chmod 775 -R ${crossotope_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_crossotope_full_run.sh 

