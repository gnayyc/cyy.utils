# notes about building hand template and registration

1. ehand.sh
  + Extract hand mask from green grid background
  + Extract RGB channel images
  + Get convex hull mask
  + `ehand.sh hand.jpg`
    + make `hand.output` directory
2. synhand.sh
  + do hand registration
  + `synhand.sh handfixed.jpg handmoving.jpg`
    + perform ehand.sh for each hand
    + make `handfixed_handmoving.output` directory
    + `antsRegistrationSyNQuick.sh -d 2 -f $hand1 -m $hand2 -o ${OUTPUT_PREFIX} -n 10 -t b -s 256`
      + use B-spline SyN # much better than SyN
3. build hand template
  + `antsMultivariateTemplateConstruction2.sh -d 2 -i 4 -o hand -t BSplineSyN -z handtemplate0.nii.gz -m MI *_hand.png`
4. Note
  + 
