using LinearAlgebra
using Random
function construct2(C, A)
    alpha=rand((0.6,0.9))
    m, n = size(A)
    println(m, " ", n)
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
        println(eval[j])
        if(eval[j]>max)
            max=eval[j]
        end
        if(eval[j]<min)
            min=eval[j]
        end
    end
    println("on passe à la construction")
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
    println(eco(C,x0))
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

function GRASP()

end

function eco(C,x)
    sum=dot(C,x)
    return sum
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