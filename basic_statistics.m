function varargout = basic_statistics(varargin)


% Gather all input arguments
[~,args,nargs] = axescheck(varargin{:});

% Catch first argument as first dataset
obs = args{1};

% Catch second argument as second dataset if it is not a string
if nargs>1
    if ~ischar(args{2})
        error('Invalid arguments, only one dataset required...')
    end
end

indx_percentiles = find(strcmpi(args,'percentiles'), 1);
indx_bins = find(strcmpi(args,'bins'), 1);


% Eliminate data if they contain nans
nan_index = ~isnan(obs);
obs = obs(nan_index);


if isempty(indx_percentiles) && isempty(indx_bins) 
    [MEAN, STD, VAR, BINS] = statistics_one_set(obs);
elseif isempty(indx_percentiles)
    [MEAN, STD, VAR, BINS] = statistics_one_set(obs,'bins',args{indx_bins+1});
elseif isempty(indx_bins)
    [MEAN, STD, VAR, BINS, PERCENTILES] = statistics_one_set(obs,'percentiles',args{indx_percentiles+1});
    varargout{5} = PERCENTILES;
else
    [MEAN, STD, VAR, BINS, PERCENTILES] = statistics_one_set(obs,'percentiles',args{indx_percentiles+1},'bins',args{indx_bins+1});
    varargout{5} = PERCENTILES;
end
varargout{1} = MEAN;
varargout{2} = STD;
varargout{3} = VAR;
varargout{4} = BINS;


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Internal Function
function varargout = statistics_one_set(obs,varargin)

% Gather all input arguments
[~,args,~] = axescheck(varargin{:});

varargout{1} = mean(obs); 
varargout{2} = std(obs);
varargout{3} = var(obs);

indx_percentiles = find(strcmpi(args,'percentiles'));
indx_bins = find(strcmpi(args,'bins'));

out_index = 4;
% Calculate Bins
if isempty(indx_bins)
    [varargout{out_index}.N, varargout{out_index}.edges] = histcounts(obs);
else
    [varargout{out_index}.N, varargout{out_index}.edges] = histcounts(obs,args{indx_bins+1});
end

out_index = out_index + 1;


% Calculate percentiles
if ~isempty(indx_percentiles)
    for ij=args{indx_percentiles+1}
        p=sprintf('p%02d',ij);
        varargout{out_index}.(p)=prctile(obs,ij);
    end
else
    for ij=5:10:95
        p=sprintf('p%02d',ij);
        varargout{out_index}.(p)=prctile(obs,ij);
    end
    
end

end


