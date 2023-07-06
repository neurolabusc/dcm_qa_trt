## About

dcm_qa_trt is a simple DICOM to NIfTI validator script and dataset. This repository is similar to [dcm_qa](https://github.com/neurolabusc/dcm_qa), but is designed to validate the `TotalReadoutTime` for [GE](https://github.com/rordenlab/dcm2niix/tree/master/GE) MRI scanners.

## Details

The BIDS definition of [TotalReadoutTime](https://bids-specification.readthedocs.io/en/stable/glossary.html#totalreadouttime-metadata) is not intuitive, and it is **not** the actual, physical duration of the readout train. BIDS adopted the [FSL's TOPUP](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide) definition. It is worth emphasizing the TOPUP guide notes: `If your readout time is identical for all acquisitions you don't neccessarily have to specify a valid value in this column (you can e.g. just set it to 1), but if you do specify correct values the estimated field will be correctly scaled in Hz, which may be a useful sanity check.` The [dcm2niix GE notes](https://github.com/rordenlab/dcm2niix/tree/master/GE) describes how the formula is implemented by dcm2niix, and Matlab code is provided in this repository.

## Useful Links

 - dcm2niix's GE `TotalReadoutTime` formula to handle details like interpolation with [v1.0.20230609](https://github.com/rordenlab/dcm2niix/pull/725).

