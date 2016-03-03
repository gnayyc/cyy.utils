# notes

1. piperdream
  + `dicom2series <sorted_MRI_dir> 0 0 <raw_subject_exam_dicom_dir>` # 0: don't empty field; 0: don't rename files
    + `dicom2series MRI/S1 0 0 raw/S1`
    + `cd raw; foreach s in *; dicom2series ../MRI/$s 0 0 $s; end`
  + `dicom2nii "none" <subject_list_file> <protocol_list_file> <output_dir> [subdir_name]`
    + `dicom2nii “none” subject.txt protocol.txt ./MRI`
2. NeuroBattery # for multimodalities
3. antsCorticalThickness
4. antsMalfLabeling
5. KellyKapowski -d 3 -s exampleCorticalThickness.nii.gz,2,3 -o outputfilename
6. 
