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
        println(x[j])
    end
    sort_ind=sortperm(x,rev=true)
    x=x[sort_ind]
    x0=zeros(n)
    for j=1:n
        println(("valeur:", x[j], " indice originel:", sort_ind[j]))
    end
    sum
    for j=1:n
        x0[sort_ind[j]]=1
        for i=1:m
            sum=0
            for k=1:n
                sum+=dot(x0[k],A[i,k])
            end
            if(sum>1)
                x0[sort_ind[j]]=0
            end
        end
    end
    println("VALIDE OU PAS:", isValid(A,x0))
    res=eco(C,x0)
    println("la somme nous donne:",res)
    println("la somme avec kp exchange est de:",eco(C,kpExchange(2,1,A,kpExchange(2,1,A,x0))))
end

function eco(C,x)
    sum =  0
    n = length(C)
    for j=1:n
        sum+=dot(C[j],x[j])
    end
    return sum
end

function initExchange(A,x)
    m=length(x)
    j=m
    b=false
    while(!b)
        if(x[j]==1)
            x[j]=0
            if(!isValid(A,x))
                x[j]=1
            else
                b=true
            end
            if(j==1)
                b=true
            end
        end
        j-=1
    end
    return x
end
#mes modif commencent ici
function kpExchange(k,p,A,x)
    m=length(x)
    j=m
    b=false
    cpt=0
    indice=zeros(Int,k)
    while(!b && j>0)
        if(x[j]==0)
            x[j]=1
            if(!isValid(A,x))
                x[j]=0
            else
                cpt+=1
                indice[cpt]=j
            end
            if(j==1 || cpt>=k)
                b=true
            end
        end
        j-=1
    end
    j=m
    cpt=0
    while(b && j>0)
        if(x[j]==1)
            if(!in(j,indice))
                x[j]=0
                if(!isValid(A,x))
                    x[j]=1
                else
                cpt+=1
                end
            end
            if(j==1 || cpt>=p)
                b=false
            end
        end
        j-=1
    end
    j=1
    while(cpt<p-1)
        x[indice[j]]=1
        if(!isValid(A,x))
            x[indice[j]]=0
        end
        cpt+=1
        j+=1
    end
    return x
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
        sum=0
        for j=1:n
            sum+=dot(x[j],A[i,j])
        end
        if(sum>1)
            return false
        end
    end
    return true
end