alpha=rand((0.6,0.9))

function construct(C, A)
    m, n = size(A)
    x = zeros(Float64, n)
    cand=[]
    for i=1:n
        push!(cand,C[i])
    end
    min=x[1]
    max=x[1]
    for j=1:n
        top=C[j]
        bottom=0
        for i=1:m
            bottom+=A[i,j]
        end
        x[j]=top/bottom
        if(x[j]>max)
            max=x[j]
        end
        if(x[j]<min)
            min=x[j]
        end
    end
   
    x0=zeros(n)
    sum
    for i=1:n 
    limit, RCL=buildRCL(x,alpha,min,max)
    end
    
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