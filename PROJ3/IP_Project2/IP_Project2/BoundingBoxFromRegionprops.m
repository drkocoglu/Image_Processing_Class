% BoundingBoxFromRegionprops gets the overall bounding box of a collection of objects,
% each of which has had its bounding box measured and returned by regionprops()
% and is contained in regionpropsOutput, which is the input argument for this function.
% BoundingBoxFromRegionprops returns a 1 by 4 array with the min and max X and Y.
% Note that regionprops has the bounding box go through the centers of the pixels,
% that is one "layer" outside the actual binary image blob, so they will all end in .5.
% So, if you want the pixel indexes like you'd get from this code:
%     verticalProfile = sum(binaryImage, 2);
%     horizontalProfile = sum(binaryImage, 1);
%     minX = find(horizontalProfile, 1, 'first')
%     maxX = find(horizontalProfile, 1, 'last')
%     minY = find(verticalProfile, 1, 'first')
%     maxY = find(verticalProfile, 1, 'last')
% then you'll have to do this:
%     x1 = ceil(xMin);
%     x2 = floor(xMax);
%     y1 = ceil(yMin);
%     y2 = floor(yMax);
% An easy way to do that is to just specify 1 for the second input argument, varargin.
function [xMin, xMax, yMin, yMax] = BoundingBoxFromRegionprops(regionpropsOutput, varargin)
	% Extract all the bounding boxes into one big array.
	boundingBox = [regionpropsOutput.BoundingBox];

	% Extract all the x1's, y1'x, widths, and heights into separate arrays.
	all_the_x1s = boundingBox(1:4:end);
	all_the_y1s = boundingBox(2:4:end);
	all_the_widths =  boundingBox(3:4:end);
	all_the_heights = boundingBox(4:4:end);

	% Determine the x2's and y2's.
	all_the_x2s = all_the_x1s + all_the_widths;
	all_the_y2s = all_the_y1s + all_the_heights;

	% Find the overall bounding box from all the x1's, x2's, y1's, and y2's.
	xMin = min(all_the_x1s);
	xMax = max(all_the_x2s);
	yMin = min(all_the_y1s);
	yMax = max(all_the_y2s);
	
	% Get the pixel indexes if requested.
	if nargin > 1
		usePixelIndexes = varargin{1};
		if usePixelIndexes
			xMin = ceil(xMin);
			xMax = floor(xMax);
			yMin = ceil(yMin);
			yMax = floor(yMax);
		end
	end
end % of function BoundingBoxFromRegionprops()
