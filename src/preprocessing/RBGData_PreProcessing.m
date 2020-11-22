function preprocessed_data = RBGData_PreProcessing(original_data)
% Retime data on an homogeneous grid and interpolate short sequence of
% missing values (NaN)

T = 5; %min
nan_th=30; %min


n_subj = length(original_data);
for s = 1:n_subj
    disp(['Subject',num2str(s)]);
    % Change to datetime variables
    datanew(s).CGM.time = datetime(datevec(original_data(s).CGM.time));
    datanew(s).CGM.values = original_data(s).CGM.values;

    % Synchronize to nearest CGM sample
    cgm = RetimeTimeseries(datanew(s).CGM,T,'mean','CGM');
    preprocessed_data(s).time = cgm.Time;
    
    % Linear interpolate short nan windows
    [short_nan,~,~,~]=Find_nan_islands(cgm.CGM,nan_th/T); %more than nan_th minutes = long_nan (6 samples)
    cgm.CGM(short_nan)=interp1(find(~isnan(cgm.CGM)),cgm.CGM(~isnan(cgm.CGM)),short_nan);
    
    preprocessed_data(s).values = round(cgm.CGM);

end


