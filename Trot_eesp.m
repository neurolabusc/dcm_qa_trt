% Test computation of TotalReadOutTime and EffectiveEchoSpacing
% for dcm2niix

% EchoSpaing from DICOM is us
ESP = 580
Asset_R_factor = 1
PE_AcquisitionMatrix = 80
ReconMatrixPE = 128
Round_factor = 2 % or 4 if Partial Fourier

% then etl = number of acquired Ky-Lines
etl = ((ceil((1/Round_factor) * PE_AcquisitionMatrix / Asset_R_factor ) * Round_factor));
% PhysTrot = Physical TotalReadOutTime
PhysTrot = (etl -1) * ESP * 1e-6 ; 

% BIDS official input are
% EESP = EffectiveEchoSpacing
EESP = PhysTrot/(PE_AcquisitionMatrix-1); 
% Trot = TotalReadOutTime
Trot = EESP*(ReconMatrixPE-1);


fprintf("etl = %d\nPhysTrot = %.9f\nEESP = %.9f\nTrot = %.9f\n", ...
    etl, PhysTrot, EESP, Trot); 

% Now let's compare this calculation versus what we get with the modified
% dcm2niix 
basedir = '/home/brice/tmp/nii_e21_Simulation_TROT_ESP'
list_json = unixlistfiles([ ' -d ' fullfile(basedir, '*', '*.json') ]);

for k = list_json,
    file = k{:};
    fprintf('Testing %s\n', file);
    json = jsondecode(fileread(file));
    
    ESP = json.EchoSpacingMicroSecondsGE; 
    if(isfield(json, 'ParallelReductionFactorInPlane'))
        Asset_R_factor = json.ParallelReductionFactorInPlane;
    else
        Asset_R_factor = 1;
    end
    PE_AcquisitionMatrix = json.AcquisitionMatrixPE;
    ReconMatrixPE = json.ReconMatrixPE;
    
    if(contains(json.ScanOptions, 'PFF'))
        Round_factor = 4; 
    else
        Round_factor = 2; 
    end
    
    % then etl = number of acquired Ky-Lines
    etl = ((ceil((1/Round_factor) * PE_AcquisitionMatrix / Asset_R_factor ) * Round_factor));
    % PhysTrot = Physical TotalReadOutTime
    PhysTrot = (etl -1) * ESP * 1e-6 ;
    
    % BIDS official input are
    % EESP = EffectiveEchoSpacing
    EESP = PhysTrot/(PE_AcquisitionMatrix-1);
    % Trot = TotalReadOutTime
    Trot = EESP*(ReconMatrixPE-1);
    
    % 
    errETL = etl - json.NotPhysicalNumberOfAcquiredPELinesGE ; 
    errPhysTrot = PhysTrot - json.NotPhysicalTotalReadOutTimeGE ; 
    errEESP = EESP - json.EffectiveEchoSpacing; 
    errTrot = Trot - json.TotalReadoutTime; 
    
    % display error in microsec
    fprintf('%f %f %f %f\n', errETL*1e6, errETL*1e6, errEESP*1e6, errTrot*1e6);
    
    
end

