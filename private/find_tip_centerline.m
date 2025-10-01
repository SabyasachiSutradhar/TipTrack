function obj=find_tip_centerline(obj)
    global inner_extp_length;
    ll=inner_extp_length;
    if length(obj.skelsmooth{1})<=inner_extp_length
        ll=length(obj.skelsmooth{1});
    end
    %%%%%%%%%%%%%%%% some parameters %%%%%%%%%%%%%%%%%%
    bpx=0;bpy=0;
    crosslength=16;
    find_tipwidth=16;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if obj.n_branchpoint==0
        Y=obj.skelsmooth{1};
        [xx,yy,sig]=gaussian_vertical(Y(:,2),Y(:,1),crosslength);
        tipgauss{1}(:,2)=xx;tipgauss{1}(:,1)=yy;
        x1=flipud(tipgauss{1}(1:ll,2));y1=flipud(tipgauss{1}(1:ll,1));
        [tip1,sigv1,sigp1]=extrapolate_findtip(x1,y1,find_tipwidth);%%%%%%%%%%%%%% Find left tip location
        tip1=flipud(tip1);
        x2=tipgauss{1}(end-ll+1:end,2);y2=tipgauss{1}(end-ll+1:end,1);
        [tip2,sigv2,sigp2]=extrapolate_findtip(x2,y2,find_tipwidth);%%%%%%%%%%%%%% Find right tip location
        xin=vertcat(tip1,tipgauss{1},tip2);
        xs=fit_smoothingspline(xin(:,1),xin(:,2));
        tipgauss{1}=curvspace(xs,length(xs));
        tipsig{1}(:,1)=vertcat(sigv1,sig,sigv2);
        tipend{1}=[tipgauss{1}(1,1),tipgauss{1}(1,2);tipgauss{1}(end,1),tipgauss{1}(end,2)];
        tipendsig{1}=horzcat(sigp1,sigp2);
        clear var xx yy sig X Y
    else %%if there is branch point
        for j=1:obj.n_tip          
            X=obj.skelsmooth{j};
            ll=inner_extp_length;
            if length(obj.skelsmooth{1,j})<inner_extp_length
                ll=length(X);
            end
            if obj.ends(j,1)==obj.skel{1,j}(1,2)
                ind=1;
                xo=X(1:ll,2);yo=X(1:ll,1);
                xo=flipud(xo);yo=flipud(yo);
            else
                xo=X(end-ll+1:end,2);yo=X(end-ll+1:end,1);
                ind=2;
            end
            
            [xx,yy,sig]=gaussian_vertical(X(:,2),X(:,1),crosslength);
            tipgauss{j}(:,2)=xx;tipgauss{j}(:,1)=yy;
            [tip,sigp]=extrapolate_findtip(xo,yo,find_tipwidth);%%%%%%%%%%%%%% Find tip location
            if ind==1
                tipind{j}=1;
                tipgauss{j}=vertcat(flipud(tip),tipgauss{j});
                bpx=bpx+tipgauss{j}(end,1);bpy=bpy+tipgauss{j}(end,2);
            else
                tipind{j}=2;
                tipgauss{j}=vertcat(tipgauss{j},tip);
                bpx=bpx+tipgauss{j}(1,1);bpy=bpy+tipgauss{j}(1,2);
            end

        xs=fit_smoothingspline(tipgauss{j}(:,1),tipgauss{j}(:,2));
        tipgauss{1}=curvspace(xs,length(xs));
        tipsig{j}(:,1)=sig;
        tipendsig{j}=sigp;
        tipend{j}=[tipgauss{j}(1,1),tipgauss{j}(1,2);tipgauss{j}(end,1),tipgauss{j}(end,2)];
            
            clear var xx yy sig Y X tip
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Merge the branchpoint
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%
        bpx=bpx/obj.n_tip;bpy=bpy/obj.n_tip;
%         scatter(bpx,bpy)
        for j=1:obj.n_tip
            if tipind{j}==1
                tipgauss{j}(end,1)=bpx; tipgauss{j}(end,2)=bpy;
                x1=bpx;y1=bpy;
                x0=tipgauss{j}(end-1,1);y0=tipgauss{j}(end-1,2);                               
                theta=wrap_angle(atan2(y1-y0,x1-x0));
                mu=sqrt((x0-x1)^2+(y0-y1)^2); 
                NP=25;
                for ii=0: NP
                    jj=ii+1;
                    del=double(ii)*mu/ double(NP);
                   brp(jj,1)=x0+del*cos(theta);
                    brp(jj,2)=y0+del*sin(theta);
                end
               tipgauss{j}=vertcat(tipgauss{j}(1:end-2,:),brp); 
                xs=fit_smoothingspline(tipgauss{j}(:,1),tipgauss{j}(:,2));
                tipgauss{j}=curvspace(xs,length(xs));
                clear var brp
            else
                tipgauss{j}(1,1)=bpx; tipgauss{j}(1,2)=bpy;
                x1=bpx;y1=bpy;
                x0=tipgauss{j}(2,1);y0=tipgauss{j}(2,2);                               
                theta=wrap_angle(atan2(y1-y0,x1-x0));
                mu=sqrt((x0-x1)^2+(y0-y1)^2); 
                NP=25;
                for ii=0:NP
                    jj=ii+1;
                    del=double(ii)*mu/ double(NP);
                   brp(jj,1)=x1+del*cos(pi+theta);
                    brp(jj,2)=y1+del*sin(pi+theta);
                end
               tipgauss{j}=vertcat(brp,tipgauss{j}(3:end,:));  
                  xs=fit_smoothingspline(tipgauss{j}(:,1),tipgauss{j}(:,2));
                tipgauss{j}=curvspace(xs,length(xs));
               tipend{j}=[tipgauss{j}(1,1),tipgauss{j}(1,2);tipgauss{j}(end,1),tipgauss{j}(end,2)];
                clear var brp
                
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=obj.n_tip+1:obj.n_tip+obj.n_branch
            X=obj.skelsmooth{j};
            [xx,yy,sig]=gaussian_vertical(X(:,2),X(:,1),crosslength);
            tipgauss{j}(:,2)=xx;tipgauss{j}(:,1)=yy;
             xs=fit_smoothingspline(tipgauss{j}(:,1),tipgauss{j}(:,2));
            tipgauss{j}=curvspace(xs,length(xs));
            tipsig{j}(:,1)=sig;
           tipend{j}=[tipgauss{j}(1,1),tipgauss{j}(1,2);tipgauss{j}(end,1),tipgauss{j}(end,2)];
            clear var xx yy sig X Y
        end
    end
    obj.center=tipgauss;
    obj.sig=tipsig;
    obj.tip=tipend;
    obj.tipendsig=tipendsig;
% for kk=1:length(tipgauss)
%          plot(tipgauss{kk}(:,1),tipgauss{kk}(:,2),'ob')
%          plot(tipend{kk}(:,1),tipend{kk}(:,2),'*g')
% end

end