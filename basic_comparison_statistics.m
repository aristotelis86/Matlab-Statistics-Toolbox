function varargout = basic_comparison_statistics(varargin)

% Gather all input arguments
[~,args,~] = axescheck(varargin{:});

% Catch first argument as first dataset
obs = args{1};
model = args{2};

% Catch third argument, it should be string (options)
if ~ischar(args{3})
    error('Argument 3 should be character/option...')
end

indx_eliminate = find(strcmpi(args,'eliminate'),1);
indx_eliminate_under = find(strcmpi(args,'eliminateunder'),1);
indx_eliminate_over = find(strcmpi(args,'eliminateover'),1);
indx_NS = find(strcmpi(args,'NS'),1);

% Eliminate data if they contain nans
nan_index = ~isnan(obs);
obs = obs(nan_index);
model = model(nan_index);

nan_index = ~isnan(model);
obs = obs(nan_index);
model = model(nan_index);

% Eliminate data if a range of values is given
if ~isempty(indx_eliminate)
    for il=1:length(args{indx_eliminate+1})
	
	  elim_index = obs(obs~=args{indx_eliminate+1}(il));
	  obs = obs(elim_index);
	  model = model(elim_index);
        
	  elim_index = model(model~=args{indx_eliminate+1}(il));
	  obs = obs(elim_index);
	  model = model(elim_index);
	
    end
end

% Eliminate data over a given value
if ~isempty(indx_eliminate_under)
        
    elim_index = obs(obs<args{indx_eliminate_under+1}(il));
    obs = obs(elim_index);
    model = model(elim_index);

    elim_index = model(model<args{indx_eliminate_under+1}(il));
    obs = obs(elim_index);
    model = model(elim_index);
  
end

% Eliminate data under a given value
if ~isempty(indx_eliminate_over)
    
    elim_index = obs(obs>args{indx_eliminate_over+1}(il));
    obs = obs(elim_index);
    model = model(elim_index);

    elim_index = model(model>args{indx_eliminate_over+1}(il));
    obs = obs(elim_index);
    model = model(elim_index);

end

% Calculate or assign NS value
if ~isempty(indx_NS)
    NS_mean = args{indx_NS+1};
    
else
    NS_mean = mean(obs);
    
end

% Provide results for two datasets
[BIAS, RMSE, RR, NS] = statistics_two_sets(obs,model,NS_mean);
varargout{1} = BIAS;
varargout{2} = RMSE;
varargout{3} = RR;
varargout{4} = NS;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Internal Function 
function varargout = statistics_two_sets(obs,model,ns_mean)

BIAS = obs - model;
NBIAS = BIAS./obs;

obs_range = range(obs);

RMSE = rms(BIAS);
% NRMSE = RMSE/mean(obs);
% NRMSE2 = RMSE/obs_range;

RR = corrcoef(obs,model);

varargout{1} = [mean(BIAS), mean(NBIAS)];
% varargout{2} = [RMSE, NRMSE, NRMSE2];
varargout{2} = RMSE;
varargout{3} = RR(1,2);

% Calculate Nash-Sutcliffe coefficient
varargout{4} = 1-((sum(BIAS.^2))/(sum((obs-ns_mean).^2)));


end