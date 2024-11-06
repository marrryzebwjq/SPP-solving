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
    tmp=-1
    kp=tmp2
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=kp
        kp=bkp(A,kp)
    end
    tmp=-1
    kp=tmp2
    while(eco(C,kp)>tmp)
        tmp=eco(C,kp)
        tmp2=kp
        kp=akp(A,kp)
    end
    kp=tmp2
    return kp
end
function eco(C,x)
    sum=dot(C,x)
    return sum
end

function akp(A,x0)
    liste=findall(x->x==0, x0)
    cp=copy(x0)
    cp1=[]
    res=eco(C,x0)
    x_res=copy(x0)
    for i in eachindex(liste)
        cp1=copy(cp)
        cp[liste[i]]=1
        if(res<eco(C,cp))
            if(isValid(A,cp))
            res=eco(C,cp)
            x_res=copy(cp)
            end
        end
        cp=copy(x0)
    end
    println("la valeur de akp est: ", res)
    return x_res
end

function bkp(A,x0)
    cp=copy(x0)
    cp1=copy(x0)
    m=length(x0)
    x_res=copy(x0)
    res=eco(C,x0)
    for i=1:m
        cp=copy(x0)
        if(cp[i]==1)
            cp[i]=0
            for j=i+1:m
                cp1=copy(cp)
                if(j!=i && cp[j]==0)
                    cp[j]=1
                    if(res<eco(C,cp))
                        if(isValid(A,cp))
                        res=eco(C,cp)
                        x_res=copy(cp)
                        end
                    end
                    cp=copy(cp1)
                end
            end
        else
            cp[i]=1
            if(res<eco(C,cp))
                for j=i+1:m
                    cp1=copy(cp)
                    if(j!=i && cp[j]==1)
                        cp[j]=0
                        if(res<eco(C,cp))
                            if(isValid(A,cp))
                            res=eco(C,cp)
                            x_res=copy(cp)
                            end
                        end
                        cp=copy(cp1)
                    end
                end
            end
        end
    end
    println("valeur de bkp ", res)
    return x_res
end

"""
result : meilleur candidat entre x et ses voisins selon un 2-1 exchange
function kp21Exchange(x)
"""
function ckp(x)
    iun = []
    izero = []
    # récup des indices des 0 et des 1
    for i in x
        i == 0 ? push!(izero,i) : push!(iun,i)
    end

    if length(iun) < 2 || length(izero) < 1 return x end

    # test des voisins
    meilleur_candidat = x;
    meilleur_eco=eco(C,x)
    voisin = copy(x);
    for i=1:length(iun)
        voisin[iun[j]] = 0; # swap 1->0
        for j=i+1:length(iun)
            voisin[iun[j]] = 0; # swap 1->0
            for k=1:length(izero)
                voisin[izero[k]] = 1; # swap 0->1

                if(eco(C,voisin) > meilleur_eco && isValid(A,voisin)) # test de validité
                    meilleur_eco = eco(C,voisin);
                    meilleur_candidat = voisin;
                end

                voisin[izero[k]] = 0; # on remet le 0
            end
            voisin[iun[j]] = 1; # on remet le 1
        end
        voisin[iun[j]] = 1; # on remet le 1
    end
    return meilleur_candidat;
end

function swap(x, i)
    x[i] = x[i]==1 ? 0 : 1;
end

# function ckp(A,x0)
#     cp=copy(x0)
#     x_res=copy(x0)
#     res=eco(C,x0)
#     m=length(x0)
#     zeros=findall(a->a==0,x0)
#     ones=findall(a->a==1,x0)
#     for i=1:m
#         cp=copy(x0)
#         if(x0[i]==1)
#             cp[i]=0
#             for j=i+1:m
#                 cp1=copy(cp)
#                 if(j!=i)
#                     if(cp[j]==1)                    
#                             cp[j]=0
#                             for k=j+1:m
#                                 cp2=copy(cp)
#                                  if(k!=j && k!=i && cp[k]==0)
#                                     cp[k]=1
#                                     if(res<eco(C,cp))
#                                         if(isValid(A,cp))
#                                             x_res=copy(cp)
#                                             res=eco(C,cp)
#                                         end
#                                    end
#                                end
#                             cp=copy(cp2)
#                         end
#                     else
#                         cp[j]=1
#                         if(res<eco(C,cp))
#                             for k=j+1:m
#                                 cp2=copy(cp)
#                                 if(k!=j && k!=i && cp[k]==1)
#                                     cp[k]=0
#                                     if(res<eco(C,cp))
#                                         if(isValid(A,cp))
#                                             x_res=copy(cp)
#                                             res=eco(C,cp)
#                                         end
#                                     end
#                                 end
#                                 cp=copy(cp2)
#                             end
#                         end
#                     end
#                 end
#                 cp=copy(cp1)
#             end
#         else
#             cp[i]=1
#             if(res<eco(C,cp))
#                 for j=i+1:m
#                     cp1=copy(cp)
#                     if(j!=i)
#                         if(cp[j]==1)
#                             cp[j]=0
#                             for k=j+1:m
#                                 cp2=copy(cp)
#                                 if(k!=j && k!=i && cp[k]==1)
#                                     cp[k]=0
#                                     if(res<eco(C,cp))
#                                         if(isValid(A,cp))
#                                             x_res=copy(cp)
#                                             res=eco(C,cp)
#                                         end
#                                     end
#                                 end
#                                 cp=copy(cp2)
#                             end
#                         end
#                     end
#                     cp=copy(cp1)
#                 end
#             end
#         end
#     end
#     println("la valeur de ckp est: ", res)
#     return x_res
# end


function ckp0(A,x0)
    cp=copy(x0)
    x_res=copy(x0)
    res=eco(C,x0)
    zeros=findall(a->a==0,x0)
    ones=findall(a->a==1,x0)
    #1er parcours de vecteur, prendre l'indice i tq et on switch
    #copier le voisin à update au fur et a mesure
    #verifier si eco(voisin) est plus grand que le eco(vecteur), si oui on teste sa validité, si valid on maj le max, sinon on remet le vecteur de base et on continue la recherche de voisin

    for i in eachindex(zeros)
        cp[i]=1
            for j in eachindex(ones)
                cp[j]=0
                for k in eachindex(zeros)
                    if(k!=i)
                        cp[k]=1
                        if(eco(C,cp)>res)
                            if(isValid(A,cp))
                                x_res=copy(cp)
                                res=eco(C,cp)
                            end
                        end
                        cp[k]=0
                    end
                end
                cp[j]=1
            end
            for j in eachindex(zeros)
                if(j!=i)
                    cp[j]=1
                    for k in eachindex(ones)
                        cp[k]=0
                        if(eco(C,cp)>res)
                            if(isValid(A,cp))
                                x_res=copy(cp)
                                res=eco(C,cp)
                            end
                        end
                        cp[k]=1
                    end
                end
                cp[j]=0
            end
        cp[i]=0
    end
    for i in eachindex(ones)
        cp[i]=0
        for j in eachindex(zeros)
            cp[j]=1
            for k in eachindex(zeros)
                if(k!=j)
                    cp[k]=1
                    if(eco(C,cp)>res)
                        if(isValid(A,cp))
                            x_res=copy(cp)
                            res=eco(C,cp)
                        end
                    end
                    cp[k]=0
                end
            end
            cp[j]=0
        end
        cp[i]=1
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
    m,n = size(A)
    for i=1:m
        sum=0
        for j = 1:n
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

function solution()
end