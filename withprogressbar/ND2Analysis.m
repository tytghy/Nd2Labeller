function post_info =  ND2Analysis(filename, obj, varargin)

switch nargin
    case 2
        output_every_frame = 1;
        split_channel_num = 1;
        output_channel = 1;
        shortest_side = 720;
    case 3
        output_every_frame =  varargin{1};
        split_channel_num = 1;
        output_channel = 1;
        shortest_side = 720;
    case 4
        output_every_frame =  varargin{1};
        split_channel_num = varargin{2};
        output_channel = 1;
        shortest_side = 720;
    case 5
        output_every_frame =  varargin{1};
        split_channel_num = varargin{2};
        output_channel = varargin{3};
        shortest_side = 720;
    case 6
        output_every_frame =  varargin{1};
        split_channel_num = varargin{2};
        output_channel = varargin{3};
        shortest_side =  varargin{4};
    otherwise
        error('Error: Number of argument is out of range. ')
end

interval = output_every_frame * split_channel_num;
imgInfo = ND2Info(filename);
img_num = imgInfo.numImages; % number of frames of movie
period_s = imgInfo.Experiment.parameters.periodDiff.avg/1000;
real_fps = round(1/imgInfo.Experiment.parameters.periodMs*1000); % real fps
output_fps = real_fps / interval; % output fps
temp = ND2ReadSingle(filename, 1);
min_size = min(size(temp));

if min_size <= shortest_side
    scale = 1;
else
    scale = shortest_side/min_size;
end
temp = imresize(temp, scale);

%Ensure frame number of each channel are the same. 
exported_frame = cell(numel(output_channel), 1);
compare_sample = cell(numel(output_channel), 1);
for i = 1:numel(output_channel)
    exported_frame{i} = output_channel(i):interval:img_num;
    compare_sample{i} = ND2ReadSingle(filename, output_channel(i));
end

minframe = min(cellfun(@numel, exported_frame));
exported_frame = cellfun(@(x) x(1:minframe), exported_frame, 'UniformOutput', 0);
exported_frame = uint16(cell2mat(exported_frame));

%Sort the channel by intensity. (largest the first)
intensity = cellfun(@(x) sum(x(:)), compare_sample);
[~, i_sort] = sort(intensity, 'descend');
exported_frame = exported_frame(i_sort, :);


%Info of compressed images.
post_info.resize_scale = scale;  % scale of image resize. 
post_info.scale = 6.5/obj/scale;  % um/px
post_info.original_fps = real_fps;  % original fps in the movie
post_info.final_fps = output_fps;   % final fps in the movie
post_info.output_channel = output_channel;  % export channel
post_info.img_size = size(temp);  % export movie size
post_info.frames = exported_frame;
[post_info.filepath, post_info.name, post_info.ext] = fileparts(filename);

end