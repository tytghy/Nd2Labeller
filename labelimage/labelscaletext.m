function imgText = labelscaletext(img, barInfo, fontsize)

[imgCatHeight, imgCatWidth] = size(img,[1 2]);
[barHeight, barWidth, right, bot, barcolor] = deal(barInfo.barHeight, barInfo.barWidth, barInfo.right, barInfo.bot, barInfo.barcolor);
imgText = zeros(size(img), 'like', img);
if barInfo.scalebarUm >= 1000
    umOrMm = ' mm';
    labelScaleValue = barInfo.scalebarUm/1000;
else
    labelScaleValue = barInfo.scalebarUm;
    umOrMm = ' μm';
end
text = [num2str(labelScaleValue) umOrMm];
position = [imgCatWidth-right-barWidth/2 imgCatHeight-bot-1.5*barHeight];
barcolor = repmat(barcolor, 1, 3);
% fontsize = round(28/720*max(size(img, 1:2)));
for iDim5 = 1:size(img, 5)
    for iDim4 = 1:size(img, 4)
        for iDim3 = 1:size(img, 3)
            RGB = insertText(img(:,:,iDim3, iDim4, iDim5),position,text,'FontSize',fontsize,'BoxOpacity', 0, 'TextColor',barcolor, 'AnchorPoint',"CenterBottom");
            imgText(:,:,iDim3, iDim4, iDim5) = RGB(:,:,1);
        end
    end
end
end