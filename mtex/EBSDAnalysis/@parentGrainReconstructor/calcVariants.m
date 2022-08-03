function calcVariants(job,varargin)
% compute variants and packet Ids
%
% Syntax
%   job.calcVariants
%
% Input
%   job - @parentGrainReconstructor
%
% Output
%   job.transformedGrains.variantId - variant ids
%   job.transformedGrains.packetId  - packet ids
%

isTr = job.isTransformed;
childOri = job.grainsPrior(isTr).meanOrientation;
parentOri = job.grains('id',job.mergeId(isTr)).meanOrientation;

% compute variantId and packetId
[job.variantId(isTr), job.packetId(isTr)] = calcVariantId(...
  parentOri,childOri,job.p2c,varargin{:});
