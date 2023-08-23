
data_bucket="s3://ADHD_ASD"
s3_derivs=${data_bucket}/derivatives/adhd_prisma/derivatives/abcd-hcp-pipeline

#subj_id=101291
#ses_id=20161020
#sub-107441/ses-20161024
subj_id=107441
ses_id=20161024

for i in `s3cmd ls ${s3_derivs}/sub-${subj_id}/ses-${ses_id}/func/ | awk '{print $4}'`; do
    file=$(basename "$i")
    exp_file=sub-${subj_id}_ses-${ses_id}_task-rest_bold_desc-filtered_timeseries.dtseries.nii
    if [ "${exp_file}" = "${file}" ]; then
        dtseries=$file
    fi 

    exp_file=sub-${subj_id}_ses-${ses_id}_task-rest_acq-PrismaSingleBand_bold_timeseries.dtseries.nii
    if [ "${exp_file}" = "${file}" ]; then
        dtseries=$file
    fi 

    exp_file=sub-${subj_id}_ses-${ses_id}_task-rest_bold_desc-filtered_motion_mask.mat
    if [ "${exp_file}" = "${file}" ]; then
        motion=$file
    fi 

    exp_file=sub-${subj_id}_ses-${ses_id}_task-rest_acq-PrismaSingleBand_motion_mask.mat
    if [ "${exp_file}" = "${file}" ]; then
        motion=$file
    fi 
done

echo $dtseries
echo $motion

