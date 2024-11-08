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
            for j=1:n
                sum=sum+A[i,j]*x0[j]
            end
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
    @time kp2=run(A,C,x0)
    println("la somme est vraiment:",eco(C,kp2))

end
function run(A,C,x)
    kp=copy(x)
    res=eco(C,x)
    tmp2=ckp(A,C,kp)
    tmp=eco(C,tmp2)
    while(tmp>res)
        res=tmp
        kp=copy(tmp2)
        tmp2=ckp(A,C,kp)
        tmp=eco(C,tmp2)
    end
    tmp2=copy(kp)
    tmp2=bkp(A,C,tmp2)
    tmp=eco(C,tmp2)
    while(tmp>res)
        res=tmp
        kp=copy(tmp2)
        tmp2=bkp(A,C,kp)
        tmp=eco(C,tmp2)

    end
    tmp2=copy(kp)
    tmp2=akp(A,C,tmp2)
    tmp=eco(C,tmp2)
    while(tmp>res)
        res=tmp
        kp=copy(tmp2)
        tmp2=akp(A,C,kp)
        tmp=eco(C,tmp2)
    end
    return kp
end

function eco(C,x)
    sum=0
    for i in eachindex(x)
        sum=sum+x[i]*C[i]
    end
    return sum
end
function akp(A,C,x0)
    zero=findall(==(0),x0)
    cp=copy(x0)
    res=eco(C,x0)
    tmp=0.0
    for i in (zero)
        cp=copy(x0)
        cp[i]=1
        tmp=res+C[i]
            if(isValid2(A,cp,i))
                res=tmp
                x0=copy(cp)
            end
        tmp=res
    end
    println("la valeur de akp est: ", eco(C,x0))
    return x0
end


function bkp(A,C,x0)
    cp=copy(x0)
    one=findall(==(1),x0)
    zero=findall(==(0),x0)
    x_res=copy(x0)
    res=eco(C,x0)
    tmp=0.0    
    for i in eachindex(zero)
        cp[zero[i]]=1
            for k in eachindex(one)
                cp[one[k]]=0
                tmp=res+C[zero[i]]-C[one[k]]
                if(res<tmp)
                if(isValid2(A,cp,zero[i]))
                    x_res=copy(cp)
                end
                end
                cp[one[k]]=1
                res=tmp

            end
        cp[zero[i]]=0
    end
    println("valeur de bkp ", eco(C,x_res))
    return x_res
end



function ckp(A,C,x0)
    cp=copy(x0)
    x_res=copy(x0)
    res=eco(C,x0)
    one=findall(==(1),x0)
    zero=findall(==(0),x0)
    tmp=0.0
    for i in eachindex(one)
        cp[one[i]]=0
        for j=i+1:length(one)
            cp[one[j]]=0
            for k in eachindex(zero)
                cp[zero[k]]=1
                tmp=res+C[zero[k]]-C[one[i]]-C[one[j]]
                if(res<tmp)
                if(isValid2(A,cp,zero[k]))
                    x_res=copy(cp)
                    res=tmp
                    #println("échange ", one[i]," ", one[j], " ", zero[k])
                end
                end
                cp[zero[k]]=0
                tmp=res
            end
            cp[one[j]]=1
        end
        cp[one[i]]=1
    end
    #println("la valeur de ckp est: ", eco(C,x_res))
    return x_res
end
function isValid(A,x)
    m,n= size(A)
    sum=0
    for i=1:m
        sum=0
        for j=1:n
            if(x[j]==1 && A[i,j]==1)
                sum=1+sum
                if(sum>1)
                    return false
                end
            end
        end
    end
    return true
end

function isValid2(A,x,i)
    m,n = size(A)
    sum=0
    for a=1:m 
        sum=0
        if(A[a,i]==1)
            for b=1:n
                if(b!=i && x[b]==1 && A[a,b]==1)
                    return false
                end
            end
        end
    end
    return true
end