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
    kp=kpExchange(2,1,A,x0)
    println("la somme avec kp exchange est de:",eco(C,kp))
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
    ones=[]
    liste1=[]
    liste2=[]
    if(k==0)
        for a=1:p
            liste2=[]
            if(a==1)
                push!(liste1,x)
            end
            for i in eachindex(liste1)
                for j=1:m
                    voisin=copy(liste1[i])
                    if(voisin[j]==1)
                        voisin[j]=0
                        push!(liste2,voisin)
                    end
                end
            end
            liste1=copy(liste2)
        end
        res=zeros(length(liste1))
        for i in eachindex(liste1)
            if(isValid(A,liste1[i]))
                res[i]=eco(C,liste1[i])
                println("res=",res[i])
            else
                res[i]=-1
            end
        end
        arg=argmax(res)
        return liste1[arg]
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
                    if(voisin[j]==1 &&!in(ones[i],j))
                        voisin[j]=0
                        push!(liste2,voisin)
                    end
                end
            end
            liste1=copy(liste2)
        end
    end
    res=zeros(length(liste1))
    for i in eachindex(liste1)
        if(isValid(A,liste1[i]))
            res[i]=eco(C,liste1[i])
            println("res[i] =", res[i])
        else
            res[i]=-1
        end
    end
    arg=argmax(res)
    truc=x-liste1[arg]
    println("Elements diffÃ©rents:")
    for i in eachindex(truc) 
        if(truc[i]!=0)
            println(i,": ",truc[i])
        end
    end
    return liste1[arg]
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



"""
result : les voisins du vecteur x selon un 1-1 exchange
function kp11Exchange(x)
    n = length(x)
    izero = []
    iun = []
    # récup des indices des 0 et des 1
    for i in x
        i == 0 ? push!(izero,i) : push!(iun,i)
    end

    liste_voisins = []
    if length(izero) == 0 || length(iun) == 0 return liste_voisins end

    for i in izero
        for j in iun
            voisin = copy(x)
            voisin[i] = 1 #swap d'un 0
            voisin[j] = 0 #swap d'un 1
            push!(liste_voisins, voisin)
        end
    end
    return liste_voisins
end
"""


"""
01 3456  9 z 0:6
  2    78  u 0:2
0010000110
0 2
0      7
0       8
 12    
 1     7
 1      8
   3   7
   3    8
"""


"""
result : les voisins du vecteur x selon un 1-1 exchange
"""
function kp11Exchange(x)
    # récup des indices des 0 et des 1 :
    izero = []
    iun = []
    for i in x
        i == 0 ? push!(izero,i) : push!(iun,i)
    end
 
    # ajout de tous les voisins dans une liste :
    liste_voisins = []   
    voisin = copy(x)
    z=0
    while z<length(izero)
        voisin[z] = 1 #swap 0->1

        u=0
        while u<length(iun)
            if iun[u]<izero[z]
                u+=1 #pour éviter de refaire une combinaison déjà faite d'échanges
            else
                voisin[u] = 0 #swap 1->0
                push!(liste_voisins, voisin)

                voisin[u] = 1 #on remet à 1, puis next swap
                u+=1
            end
        end
        voisin[z] = 0 #next swap
        z+=1
    end

    return liste_voisins
end
