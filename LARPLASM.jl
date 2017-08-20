module LARPLASM

using PyCall
@pyimport pyplasm as p

function larview(V::Array{Float64,2}, EV::Array{Int64,1})
	a,b = PyObject(V'), PyObject(EV)
	p.VIEW(p.MKPOL([a,b,1]))
end

#=
function larview(V::Array{Any,2}, EV::Array{Any,1})
	a,b = PyObject(V'), PyObject(EV)
	p.VIEW(p.MKPOL([a,b,1]))
end
=#

#=
function lar2plasm(EV, FE)
    EV = sparse(EV)
    faces = Array{Array{Int64, 1}, 1}()

    for f in 1:size(FE, 1)
        verts = Array{Int64, 1}()
        done = Array{Int64, 1}()
        face = FE[f, :]
        edges = EV[face.nzind, :]

        push!(done, 1)
        vs = edges[1, :].nzind
        if face.nzval[1] < 0
            vs = vs[end:-1:1]
        end
        startv, nextv = vs
        push!(verts, startv)

        while nextv != startv
            println(edges[:, nextv].nzind, "; done: ", done)
            e = setdiff(edges[:, nextv].nzind, done)[1]
            push!(done, e)
            vs = edges[e, :].nzind
            if face.nzval[e] < 0
                vs = vs[end:-1:1]
            end
            curv, nextv = vs
            push!(verts, curv)
        end

        push!(faces, verts)
    end

    println("FV = ", string(faces)[15:end])
end

function lar2py(V, EV)
    print("V = [[0,0]")
    for i in 1:size(V, 1)
        print(",", vec(V[i, :]))
    end
    println("]")
    
    print("EV = [")
    for i in 1:size(EV, 1)
        if i > 1 print(",") end
        print(EV[i, :].nzind)
    end
    println("]")
end
=#


end