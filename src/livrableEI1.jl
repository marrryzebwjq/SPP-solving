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
    x=x[sort_ind]
    x0=zeros(n)
    sum
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
    println("on prie")
    res=eco(C,x0)
    println("la somme nous donne:",res)
    k=2
    start=time()
    kp=run(C,x0)
    tutilise = time()-start
    println(tutilise)
    println("la somme est vraiment:",eco(C,kp))

end
function run(C,x)
    tmp=eco(C,x)
    kp=ckp(A,x)
    tmp2=x
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=kp
        kp=ckp(A,x)
    end
    kp=tmp2
    tmp=-1
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=kp
        kp=bkp(A,kp)
    end
    kp=tmp2
    tmp=-1
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=kp
        kp=akp(A,kp)
    end
    kp=tmp2
    return kp
end
function eco(C,x)
    sum=0
     sum=dot(C,x)
    return sum
end

function akp(A,x)
    m=length(x)
    liste=[]
    for j=1:m
        voisin=copy(x)
        if(voisin[j]==0 && x[j]==0)
            voisin[j]=1
            if(!in(liste,voisin)&&isValid(A,voisin))
                push!(liste,voisin)
            end
        end
    end
    res=zeros(length(liste))
    if(length(res)!=0)
        for i in eachindex(liste)
            if(isValid(A,liste[i]))
                res[i]=eco(C,liste[i])
            end
        end
        arg=argmax(res)
        println("valeur kp:", res[arg])
        return liste[arg]
    else
        return x
    end
end

function bkp(A,x)
    m=length(x)
    liste1=[]
    liste2=[]
    for j=1:m
        voisin=copy(x)
        if(voisin[j]==1)
            voisin[j]=0
            if(!in(voisin,liste1))
                push!(liste1,voisin)
            end
        end
    end
    for a in eachindex(liste1)
        for j=1:m
            voisin=copy(liste1[a])
            if(voisin[j]==0 && x[j]==0)
                voisin[j]=1
                if(isValid(A,voisin) && !in(voisin,liste2))
                    push!(liste2,voisin)
                end
            end
        end
    end
    res=zeros(length(liste2))
    if(length(res)!=0)
        for i in eachindex(liste2)
            if(isValid(A,liste2[i]))
                res[i]=eco(C,liste2[i])
            end
        end
        arg=argmax(res)
        println("valeur kp:", res[arg])
        return liste2[arg]
    else
        return x
    end
end
function ckp(A,x)
    m=length(x)
    liste1=[]
    liste2=[]
    liste3=[]
    for j=1:m
        voisin=copy(x)
        if(voisin[j]==1)
            voisin[j]=0
            if(!in(voisin,liste1))
                push!(liste1,voisin)
            end
        end
    end
    for a in eachindex(liste1)
        for j=1:m
            voisin=copy(liste1[a])
            if(voisin[j]==1)
                voisin[j]=0
                if(!in(voisin,liste2))
                    push!(liste2,voisin)
                end
            end
        end
    end
    for a in eachindex(liste2)
        for j=1:m
            voisin=copy(liste2[a])
            if(voisin[j]==0 && x[j]==0)
                voisin[j]=1
                if(isValid(A,voisin) && !in(voisin,liste3))
                    push!(liste3,voisin)
                end
            end
        end
    end
    res=zeros(length(liste3))
    if(length(res)!=0)
        for i in eachindex(liste3)
            if(isValid(A,liste3[i]))
                res[i]=eco(C,liste3[i])
            end
        end
        arg=argmax(res)
        println("valeur kp:", res[arg])
        return liste3[arg]
    else
        return x
    end
end



function max(x1,x2)
    if(x1>x2)
        return x1
    else
        return x2
    end
end

function isValid(A,x)
    m, n = size(A)
    for i=1:m
        sum=dot(A[i,:],x)
        if(sum>1)
            return false
        end
    end
    return true
end

function solution()
end



































#mes modif commencent ici
function kpExchange(k,p,A,x)
    m=length(x)
    ones=[]
    liste1=[]
    liste2=[]
    if(k==0)
       akp(A,x)
    else
        m=length(x)
        ones=[]
        liste1=[]
        liste2=[]
        for a=1:k
            liste2=[]
            if(a==1)
                push!(liste1,x)
            end
            for i in eachindex(liste1)
                for j=1:m
                    voisin=copy(liste1[i])
                    if (voisin[j]==0)
                        voisin[j]=1
                        push!(ones,j)
                        push!(liste2,voisin)
                    end
                end
            end
            liste1=copy(liste2)
        end
        for a=1:p
            liste2=[]
            for i in eachindex(liste1)
                for j=1:m
                    voisin=copy(liste1[i])
                    if(voisin[j]==1 && !in(ones,j))
                        voisin[j]=0
                        push!(liste2,voisin)
                    end
                end
            end
            liste1=copy(liste2)
        end
    end
    id=1
    maximum=0
    tmp=0
    for i in eachindex(liste1)
        if(isValid(A,liste1[i]))
            tmp=eco(C,liste1[i])
            maximum=max(tmp,maximum)
            if(maximum!=tmp)
                id=i
            end
        end
    end
    return liste1[id]
end