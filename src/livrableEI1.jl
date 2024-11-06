using LinearAlgebra

function construct(C, A)
    m, n = size(A)
    x = zeros(Float64, n)
    for j=1:n
        top=C[j]
        bottom=0
        for i=1:m
            bottom+=A[i,j]
        end
        x[j]=top/bottom
    end
    sort_ind=sortperm(x,rev=true)
    x0=zeros(Int,n)
    sum=0
    for j=1:n
        x0[sort_ind[j]]=1
        for i=1:m
            sum=0
            sum=dot(A[i, :],x0)
            if(sum>1)
                x0[sort_ind[j]]=0
            end
        end
    end
    sum=0
    for j in eachindex(x0)
        if(x0[j]!=0)
            sum+=1
        end
    end
    println("sum est ", sum)
    println("on prie")
    res=eco(C,x0)
    println("la somme nous donne:",res)
    k=2
    start=time()
    kp=copy(run(A,C,x0))
    tutilise = time()-start
    println(tutilise)
    println(isValid(A,x0))
    println(eco(C,x0))
    println("la somme est vraiment:",eco(C,kp))

end
function run(A,C,x)
    tmp=eco(C,x)
    kp=copy(ckp(A,C,x))
    tmp2=copy(x)
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=copy(kp)
        kp=copy(ckp(A,C,x))
    end
    tmp=-1
    kp=copy(tmp2)
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=copy(kp)
        kp=copy(bkp(A,C,kp))
    end
    tmp=-1
    kp=copy(tmp2)
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=copy(kp)
        kp=copy(akp(A,C,kp))
    end
    kp=copy(tmp2)
    return kp
end
function run2(A,C,x0)
    return akp(A,C,akp(A,C,bkp(A,C,akp(A,C,bkp(A,C,bkp(A,C,ckp(A,C,ckp(A,C,x0))))))))
end
function eco(C,x)
    sum=0
    for i in eachindex(x)
        sum+=C[i]*x[i]
    end
    return sum
end
function eco2(C,base,i,j,k)
    return C[k]-C[i]-C[j]+base
end
function eco3(C,base,i,j)
    return C[i]-C[j]+base
end
function eco4(C,base,i)
    return C[i]+base
end

function akp(A,C,x0)
    nb_zeros=count(a->a==0,x0)
    zero=zeros(Int, nb_zeros)
    cp=copy(x0)
    res=eco(C,x0)
    x_res=copy(x0)
    it=1
    tmp=0.0
    for i in eachindex(x0)
        if(x0[i]==0)
            zero[it]=i
            it+=1
        end
    end
    for i in eachindex(zero)
        cp[zero[i]]=1
        tmp=eco4(C,res,zero[i])
        if(res<tmp)
            if(isValid4(A,cp,zero[i]))
            res=tmp
            x_res=copy(cp)
            end
        end
        cp[zero[i]]=0
    end
    println("la valeur de akp est: ", res)
    return x_res
end

function bkp(A,C,x0)
    cp=copy(x0)
    nb_zeros=count(a->a==0,x0)
    nb_ones=count(a->a==1,x0)
    zero=zeros(Int, nb_zeros)
    one=ones(Int, nb_ones)
    x_res=copy(x0)
    res=eco(C,x0)
    tmp=0.0
    it1=1
    it2=1
    for i in eachindex(x0)
        if(x0[i]==1)
            one[it1]=i
            it1+=1
        else
            zero[it2]=i 
            it2+=1
        end
    end
    for i in eachindex(zero)
        cp[zero[i]]=1
            for k in eachindex(one)
                cp[one[k]]=0
                tmp=eco3(C,res,zero[i],one[k])
                if(res<(tmp) && isValid3(A,cp,zero[i],one[k]))
                    x_res=copy(cp)
                    res=tmp
                end
                cp[one[k]]=1
            end
        cp[zero[i]]=0
    end
    println("valeur de bkp ", res)
    return x_res
end

function ckp(A,C,x0)
    cp=copy(x0)
    x_res=copy(x0)
    res=eco(C,x0)
    nb_zeros=count(a->a==0,x0)
    nb_ones=count(a->a==1,x0)
    one=ones(Int,nb_ones)
    zero=zeros(Int,nb_zeros)
    it1=1
    it2=1
    tmp=0.0
    for i in eachindex(x0)
        if(x0[i]==1)
            one[it1]=i
            it1+=1
        else
            zero[it2]=i 
            it2+=1
        end
    end
    for i in eachindex(one)
        cp[one[i]]=0
        for j=i+1:length(one)
            cp[one[j]]=0
            for k in eachindex(zero)
                cp[zero[k]]=1
                tmp=eco2(C,res,one[i],one[j],zero[k])
                if(isValid2(A,cp,one[i],one[j],zero[k]) && res<tmp)
                    x_res=copy(cp)
                    res=tmp
                    println("Ã©change ", one[i]," ", one[j], " ", zero[k])
                end
                cp[zero[k]]=0
            end
            cp[one[j]]=1
        end
        cp[one[i]]=1
    end
    println("la valeur de ckp est: ", res)
    return x_res
end

function max(x1,x2)
    if(x1>x2)
        return x1
    else
        return x2
    end
end

function isValid(A,x)
    m,n= size(A)
    sum=0
    for i=1:m
        sum=0
        for j=1:n
            if(x[j]==1 && A[i,j]==1)
                sum+=1
                if(sum>1)
                    return false
                end
            end
        end
    end
    return true
end

function isValid2(A,x,i,j,k)
    m,n = size(A)
    sum=0
    for a=1:m 
        sum=0
        if(A[a,i]==0 && A[a,j]==0 && A[a,k]==1)
            sum=dot(A[a,:],x)
            if(sum>1)
                return false
            end
        end
    end
    return true
end

function isValid3(A,x,i,k)
    m,n = size(A)
    sum=0
    for a=1:m 
        sum=0
        if(A[a,k]==0 && A[a,i]==1)
            sum=dot(A[a,:],x)
            if(sum>1)
                return false
            end
        end
    end
    return true
end

function isValid4(A,x,i)
    m,n = size(A)
    sum=0
    for a=1:m 
        sum=0
        if(A[a,i]==1)
            sum=dot(A[a,:],x)
            if(sum>1)
                return false
            end
        end
    end
    return true
end
