using PyCall
@pyimport pyplasm as p

#=
def CCOMB(vectors):
return (sp.array(VECTSUM(vectors)) / float(len(vectors))).tolist()  


def MKPOLS (model):
if isinstance(model,Model):
    V,FV = model.verts,model.cells
elif (isinstance(model,tuple) or isinstance(model,list)):
    if len(model)==2: V,FV = model
    elif len(model)==3: V,FV,EV = model
pols = [MKPOL([[V[v] for v in f],[range(1,len(f)+1)], None]) for f in FV]
return pols  

def EXPLODE (sx,sy,sz):
def explode0 (scene):
    centers = [CCOMB(S1(UKPOL(obj))) for obj in scene]
    scalings = len(centers) * [S([1,2,3])([sx,sy,sz])]
    scaledCenters = [UK(APPLY(pair)) for pair in
                     zip(scalings, [MK(p) for p in centers])]
    translVectors = [ VECTDIFF((p,q)) for (p,q) in zip(scaledCenters, centers) ]
    translations = [ T([1,2,3])(v) for v in translVectors ]
    return STRUCT([ t(obj) for (t,obj) in zip(translations,scene) ])
return explode0  

""" Drawing numbers of cells """
def cellNumbering (larModel,hpcModel):
V,CV = larModel
def cellNumbering0 (cellSubset,color=WHITE,scalingFactor=1):
  text = TEXTWITHATTRIBUTES (TEXTALIGNMENT='centre', TEXTANGLE=0, 
                 TEXTWIDTH=0.1*scalingFactor, 
                 TEXTHEIGHT=0.2*scalingFactor, 
                 TEXTSPACING=0.025*scalingFactor)
  hpcList = [hpcModel]
  for cell in cellSubset:
     point = CCOMB([V[v] for v in CV[cell]])
     hpcList.append(T([1,2,3])(point)(COLOR(color)(text(str(cell)))))
  return STRUCT(hpcList)
return cellNumbering0

def larModelNumbering(scalx=1,scaly=1,scalz=1):
def  larModelNumbering0(V,bases,submodel,numberScaling=1):
    color = [ORANGE,CYAN,GREEN,WHITE]
    nums = AA(range)(AA(len)(bases))
    hpcs = [submodel]
    for k in range(len(bases)):
        hpcs += [cellNumbering((V,bases[k]),submodel)
                    (nums[k],color[k],(0.5+0.1*k)*numberScaling)]
    return STRUCT(hpcs)
    #return EXPLODE(scalx,scaly,scalz)(hpcs)
return larModelNumbering0

=#