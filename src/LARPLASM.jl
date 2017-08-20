module LARPLASM

include("lar2py.jl")

function pytest()
    c = p.CUBOID(PyObject([1,1,1]))
    p.VIEW(c)
end

function larview(V::Array{Float64,2}, EV::Array{Int64,1})
	a,b = PyObject(V'), PyObject(EV)
	p.VIEW(p.MKPOL([a,b,1]))
end

function lar2hpc(V::Array{Float64,2}, EV::Array{Any,1})
	EV = map(Int32, EV)
	lar2hpc(V,EV)
end

function lar2hpc(V::Array{Float64,2}, EV::Array{Array{Int64,1},1})
	EV = hcat(EV...)
	lar2hpc(V,EV)
end

function lar2hpc(V::Array{Float64,2}, EV::Array{Int32,2})
	a,b = PyObject(V'), PyObject(EV')
	verts = PyObject(a[:tolist]())
	cells = PyObject(b[:tolist]())
	p.MKPOL([verts,cells,1])
end

function lar2hpc(V::Array{Float64,2}, EV::Array{Int64,2})
	EV = map(Int32, EV)
	a,b = PyObject(V'), PyObject(EV')
	verts = PyObject(a[:tolist]())
	cells = PyObject(b[:tolist]())
	p.MKPOL([verts,cells,1])
end

# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Float64,2}, EV::Array{Int64,2})
	p.VIEW(lar2hpc(V,EV))
end

# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Float64,2}, EV::Array{Any,2})
	EV = map(Int64, EV)
	larview(V,EV)
end

# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Any,2}, EV::Array{Any,1})
	a,b = PyObject(V'), PyObject(EV)
	p.VIEW(p.MKPOL([a,b,1]))
end


# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Float64,2}, EV::Array{Any,1})
	p.VIEW(lar2hpc(V,EV))
end

# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Float64,2}, EV::Array{Array{Int64,1},1})
	a,b = PyObject(V'), PyObject(EV)
	verts = PyObject(a[:tolist]())
	cells = b
	p.VIEW(p.MKPOL([verts,cells,1]))
end

# visualize an HPC value from a Julia pair (Verts,Cells)
function larview(V::Array{Any,2}, EV::Array{Any,2})
	a,b = PyObject(V'), PyObject(EV')
	verts = a
	cells = b
	p.VIEW(p.MKPOL([verts,cells,1]))
end

# generate the triple of scaling factors needed by `larlib` explode
function scalingargs(scaleargs)
	if length(scaleargs)==1
		sx = sy = sz = scaleargs[1]
	elseif length(scaleargs)==3
		sx, sy, sz = scaleargs
	else
		println("error: wrong number of scaling arguments")
	end
	sx, sy, sz
end


# This requires a lar2py conversion
#=
# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Float64,2}, fv::Array{Array{Int64,1},1}, scaleargs=1.2)
	sx, sy, sz = scalingargs(scaleargs)
	a = PyObject(v')
	b = PyObject(Array{Any,1}[fv[k]-1 for k in 1:length(fv)])
	verts = PyObject(a[:tolist]())
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((verts,b))))
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Float64,2}, fv::Array{Any,1}, scaleargs=1.2)
	sx, sy, sz = scalingargs(scaleargs)
	a = PyObject(v')
	b = PyObject(Array{Any,1}[fv[k]-1 for k in 1:length(fv)])
	verts = PyObject(a[:tolist]())
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((verts,b))))
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Any,2}, fv::Array{Any,1}, scaleargs=1.2)
	sx, sy, sz = scalingargs(scaleargs)
	verts = PyObject(v')
	if typeof(verts)==PyObject
		a = verts
	else
		a = PyObject(verts[:tolist]())
	end
	b = PyObject(Array{Any,1}[fv[k]-1 for k in 1:length(fv)])
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((a,b))))
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Int64,2}, fv::Array{Int64,2}, scaleargs=(1.2,))
	v = map(Float64,v)
	viewexploded(v, fv, scaleargs)
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Float64,2}, fv::Array{Int64,2}, scaleargs=(1.2,))
	sx, sy, sz = scalingargs(scaleargs)
	a,b = PyObject(v'), PyObject(fv'-1)
	verts = PyObject(a[:tolist]())
	cells = PyObject(b[:tolist]())
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((verts,cells))))
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Float64,2}, fv::Array{Any,2}, scaleargs=(1.2,))
	fv = map(Int64, fv)
	viewexploded(v, fv, scaleargs)
end

# visualise an exploded `larlib` pair from a Julia pair (Verts,Cells)
function viewexploded(v::Array{Any,2}, fv::Array{Any,2}, scaleargs=(1.2,))
	sx, sy, sz = scalingargs(scaleargs)
	fv = map(Int,fv)-1
	cells = [(fv[:,k]) for k in 1:size(fv,2)]
	a,b = PyObject(v'), PyObject(cells)
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((a,b))))
end

function viewexploded(v::Array{Any,2}, fv::Array{Int64,2}, scaleargs=(1.2,))
	sx, sy, sz = scalingargs(scaleargs)
	fv = fv-1
	cells = [(fv[:,k]) for k in 1:size(fv,2)]
	a,b = PyObject(v'), PyObject(cells)
	p.VIEW(p.EXPLODE(sx,sy,sz)(p.MKPOLS((a,b))))
end
=#


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