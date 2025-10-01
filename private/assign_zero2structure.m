function obj=assign_zero2structure(obj)
    x=zeros(2);
    obj.ends=x;
    obj.type=0;
    obj.n_end=0;
    obj.n_branch=0;
    obj.n_branchpoint=0;
    obj.n_tip=1;
    obj.skel={x};
    obj.skelsmooth={x};
    obj.smooth={x};
    obj.center={x};
    obj.sig={x};
    obj.centerfilt={x};
    obj.length=0/0;
    obj.tip={x};
end