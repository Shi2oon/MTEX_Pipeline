classdef shape2d < grain2d


  properties (Dependent=true)
    Vs      % list of vertices
    rho     % radius of polar coords
    theta   % angle of polar coords
  end


  % 1) should be constructed from calcTDF / circdensity (density function from a set of lines)
  % characteristicshape
  % surfor, paror
  % 2) purpose: take advantage of grain functions (long axis direction, aspect ratio..)
  %
  % additional functions I will try to put here: measure of asymmetry
  % nice plotting wrapper (replacing plotTDF)
  
  methods
    
    function shape = shape2d(Vs)
      % list of vertices [x y]
      % construct a fake grain2d
      prop = struct('x',1,'y',1,'grainId',1);
      ebsd = EBSD(rotation.nan,1,{'mineral'},prop);
      n = size(Vs,1);
      if n==0
        F = zeros(0,2);
      else
        F = [(1:n).',[(2:n).';1]];
      end
      I_DG = 1;
      I_FD = sparse(ones(size(F,1),1));
      A_Db = 1;
      shape = shape@grain2d(ebsd,Vs,F,I_DG,I_FD,A_Db);
      
    end

    function Vs = get.Vs(shape)
      Vs = shape.boundary.V;
    end
    
    function theta = get.theta(shape)
      theta = atan2(shape.boundary.V(:,2),shape.boundary.V(:,1));
    end
    
    function rho = get.rho(shape)
      rho = sqrt(shape.boundary.V(:,2).^2 + shape.boundary.V(:,1).^2);
    end
  end
    
  methods (Static = true)
    v = byRhoTheta(rho,theta)
  end
  
end
