using LinearAlgebra
using Random
include("livrableEI1.jl")
function construct2(C, A)
    m, n = size(A)
    eval = zeros(Float64, n)
    max=0
    min=0
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
    alpha=rand((0.6,0.9))
    cand=[]
    for i=1:n
        push!(cand,i)
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
    println("la valeur de la fonction économique est:", eco(C,x0))
    return x0
end

function buildRCL(eval,alpha,min,max)
    alpha=rand((0.6,0.9))
    m, n = size(A)
    cand=[]
    for i=1:n
        push!(cand,i)
    end
    x0=zeros(n)
    while(!isempty(cand))
        evali=copy(eval[cand])
        min=minimum(evali)
        max=maximum(evali)
        limit=min+alpha*(max-min)
        println(limit)
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
        println(cand)
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
end

function GRASP(C,A)
    res=0
    j=0
    x_res=[]
    while j<20
        init=construct2(C,A)
        improved=run(C,init)
        tmp=eco(C,improved)
        if(res<tmp)
            res=tmp
            x_res=copy(improved)
        end
        j+=1
    end
    println("valeur finale: ", res)
    return x_res
end
