using LinearAlgebra
using Random
include("livrableEI1.jl")

function construct2(C, A, alpha)
    m, n = size(A)
    eval = zeros(Float64, n)
    cand=[]
    max=0
    min=0
    for i=1:n
        push!(cand,i)
    end
    for j=1:n
        top=C[j]
        bottom=0
        for i=1:m
            bottom+=A[i,j]
        end
        eval[j]=top/bottom
        if(eval[j]>max)
            max=eval[j]
        end
        if(eval[j]<min)
            min=eval[j]
        end
    end
    x0=zeros(n)
    while(!isempty(cand))
        evali=copy(eval[cand])
        min=minimum(evali)
        max=maximum(evali)
        limit=min+alpha*(max-min)
        RCL=[]
        for i in eachindex(evali)
            if(evali[i]>=limit)
                push!(RCL,i)
            end
        end
        e=rand(collect(RCL))
        e2=cand[e]
        cand=filter!(a->a!=e, cand)
        del=[]
        for i in eachindex(cand)
            for j in 1:m
                if(A[j,cand[i]]+A[j,e2]>1)
                    push!(del,cand[i])
                end
            end
        end
        cand=setdiff(cand,del)
        x0[e2]=1
    end
    return x0
end

function buildRCL(x,alpha,min,max)
    limit=min+alpha*(max-min)
    ind=1
    RCL=[]
    for i=1:n
        if(x[i]>=limit)
            push!(RCL,ind)
        end
    end
    return limit, RCL
end

function GRASP(C,A,alpha)
    s=[]
    m=length(C)
    x=zeros(m)
    k=20
    for i=1:k
        x=copy(construct2(C,A,alpha))
        x=copy(run(A,C,x))
        push!(s,x)
    end
    val=zeros(k)
    tmp=-1
    ind=0
    for i in eachindex(val)
        val[i]=eco(C,s[i])
        if(eco(C,val[i])>tmp)
            tmp=eco(C,val[i])
            ind=i
        end
    end
    x_res=copy(s[ind])
    return x_res
end

function reactiveGRASP(C,A)
    sol=[]
    sigma=3
    pool_alpha=[]
    n=50
    m=9
    res=0
    valuation=zeros(Float64,m)
    setAlpha=zeros(Float64,m)
    k=0.1
    for i in eachindex(setAlpha)
        setAlpha[i]=k
        k=k+0.1
    end
    proba=zeros(Float64,m)
    for i in eachindex(proba)
        proba[i]=1/m
    end
    for i=1:n
        alpha=rand(setAlpha)
        init=GRASP(C,A,alpha)
        improved=run(A,C,init)
        push!(sol,improved)
        push!(sol,pool_alpha)
        if(i%8==0)
            for j=1:m
                valuation[j]=((mean(C,pool_alpha)-worst(C,sol))/(best(C,sol)-worst(C,sol)))^sigma
            end
            for j=1:m
                proba[j]=valuation[j]/(somme(C,valuation))
            end
        end
    end
    x_res=best(C,sol)
    res=eco(C,x_res)
    println("la solution de reactiveGRASP est:", res)
    return x_res
end

function mean(C,v)
    res=0
    cpt=1
    for i in eachindex(v)
        res=res+eco(C,v[i])
        cpt=cpt+1
    end
    return res/cpt
end

function worst(C,v)
    res=0
    tmp=0
    for i in eachindex(v)
        tmp=eco(C,v[i])
        if(res>tmp)
            res=tmp
        end
    end
    return res
end

function best(C,v)
    res=0
    tmp=0
    for i in eachindex(v)
        tmp=eco(C,v[i])
        if(res<tmp)
            res=tmp
        end
    end
    return res
end

function somme(C,v)
    res=0
    for i in eachindex(v)
    res=res+eco(C,v[i])
    end
    return res
end