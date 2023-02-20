clear all; 
clf;
clc; 

caseDir = [pwd '/'];
resultsDir = [caseDir sprintf('results/')];

%% construct graph
% read connectivity.dat
flName = [resultsDir 'connectivity.dat'];
fid = fopen(flName,'rt'); 

conn = textscan(fid, '%s','delimiter','\n'); 
fclose(fid);
conn = conn{1};

nFrac = length(conn);
A = sparse(nFrac+2,nFrac+2);

for iP = 1:nFrac
    s = conn{iP};
    s = strsplit(s,' '); 
    s(end) = [];
    s = cellfun(@str2num,s);
    
    A(iP,s) = 1;    
end

% read left.dat (source)
flName = [resultsDir 'left.dat'];
fid = fopen(flName,'rt'); 

left = textscan(fid, '%s','delimiter','\n'); fclose(fid);
left = left{1};

left = cellfun(@str2num,left);

A(nFrac+1,left) = 1;    
A(left,nFrac+1) = 1;    

% read right.dat (target)
flName = [resultsDir 'right.dat'];
fid = fopen(flName,'rt'); 

right = textscan(fid, '%s','delimiter','\n'); fclose(fid);
right = right{1};

right = cellfun(@str2num,right);

A(nFrac+2,right) = 1;    
A(right,nFrac+2) = 1;    


nodeNames = cellstr([string([1:nFrac]'); 's';'t']);

G = graph(A,nodeNames);


%% dead-end fracture identification

binEdge = biconncomp(G); % biconnected component each edge in the graph belongs to
binNode = biconncomp(G, 'OutputForm', 'cell'); % node IDs of all nodes in each biconnected component

figG = plot(G); hold on

figG.MarkerSize = 2*ones(size(G.Nodes.Name)); 
figG.MarkerSize(end-1:end)= 10;

figG.Marker = [repmat({'o'},1,size(G.Nodes,1)-2) {'^'} {'o'}];
figG.NodeColor  = [zeros(size(G.Nodes,1)-2,3); 0 1 0; 1 0 0];
figG.EdgeColor = [0 0 0 ];

node_deadEnd = [];
for iBin = 1:length(binNode)
    
    indEdge = find(binEdge == iBin);
    G_blockCut = rmedge(G,indEdge);            
    component = conncomp(G_blockCut);
    if component(end-1) == component(end)
        node_deadEnd = [node_deadEnd find(component ~= component(end))];
        if length(binNode{iBin}(:))>2
            highlight(figG,'Edges',indEdge,'EdgeColor','b','linewidth',2)
        else
            highlight(figG,'Edges',indEdge,'EdgeColor','r','linewidth',2)
        end
        drawnow;
    end
end

node_deadEnd = unique(node_deadEnd);

