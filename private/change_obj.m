function obj3=change_obj(obj1,obj2)
    f = fieldnames(obj1);
 for i = 1:length(f)
    obj3.(f{i}) = obj1.(f{i});
 end
    f = fieldnames(obj2);
 for i = 1:length(f)
    obj3.(f{i}) = obj2.(f{i});
 end

   
end