function [ClusterIm_GMM,CCIm_GMM] = MyGMM3(Im,Type,k)

% tic
warning off

[m,n,p] = size(Im);

Im_Reshape = reshape(Im,m*n,p);

X = double(Im_Reshape);

gm = fitgmdist(X,k,'RegularizationValue',0.1);
idx = cluster(gm,X);

ClusterIm_GMM = reshape(idx,m,n);

% figure,imagesc(ClusterIm_GMM)
% axis image

% CCIm_GMM_temp = zeros(m*n,k);
% 
% for i = 1 : k
%     CCIm_GMM_temp(find(ClusterIm_GMM == i),i) = 1;
% end
% 
% CCIm_GMM_temp = reshape(CCIm_GMM_temp,m,n,k);

switch Type
    case ('RGB')
        CCIm_GMM = getCCIm(ClusterIm_GMM);%CCIm_GMM_temp;
    case ('Hyper')
        CCIm_GMM = [];
end

% toc
end


function CCIm = getCCIm(ClusterIm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT: ClusterIm
%%% OUTPUT: CCIm

%%% NOTE: minCluIdx >= 0, or it will crash, MAR 27 730AM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    minCluIdx = min(min(ClusterIm));
    if( minCluIdx == 0)
        ClusterIm = ClusterIm + 1;
        minCluIdx = minCluIdx + 1;
    end
    CCIm = ClusterIm;
    maxCluIdx = max(max(ClusterIm));
    numClusters = maxCluIdx - minCluIdx + 1;
    CC = cell(numClusters,1);
    for n = minCluIdx:maxCluIdx
        tempIm = ClusterIm;
        tempIm(find(tempIm == n)) = -1;
        tempIm(find(tempIm ~= -1)) = -2;
        tempIm(find(tempIm == -1)) = 1;
        tempIm(find(tempIm == -2)) = 0;
        CC{n,1} = bwconncomp(tempIm);
    end

    ctr = numClusters;
    for n = minCluIdx:maxCluIdx
        temp = CC{n,1}.PixelIdxList;
        if(size(temp,2)==1)
            continue;
        else
            endIdx = size(temp,2);
            for m = 2:endIdx
                ctr = ctr + 1;
                CCIm(temp{1,m}) = ctr;
            end
        end
    end
    
end
