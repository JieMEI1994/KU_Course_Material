# -*- coding: utf-8 -*-
"""
Created on Sat Jul 15 11:26:51 2017

@author: Administrator
"""

# Import modules
from OCC.gp import *
from OCC.GC import *
from OCC.BRep import *
from OCC.BRepAlgoAPI import *
from OCC.BRepBuilderAPI import *
from OCC.BRepFilletAPI import *
from OCC.BRepPrimAPI import *
from OCC.TopAbs import *
from OCC.TopoDS import *
from OCC.TopExp import *
from OCC.TopLoc import *

# Define the PartA dimensions
aLength = 200.
aWidth = 15.
aHeight = 115.

# Define the PartB dimensions
bLength = 200.
bWidth = 50.
bHeight = 25.

# Define the PartC dimensions
cLength = 200.
cWidth = 10.
cHeight = 115.

# Creat the PartA
aPnt1 = gp_Pnt(-aWidth / 2.0, 0, 0)
aPnt2 = gp_Pnt(-aWidth / 2.0, -aLength / 2.0, 0)
aPnt3 = gp_Pnt(aWidth / 2.0, -aLength / 2.0, 0)
aPnt4 = gp_Pnt(aWidth / 2.0, 0, 0)

aSegment1 = GC_MakeSegment(aPnt1, aPnt2)
aSegment2 = GC_MakeSegment(aPnt2, aPnt3)
aSegment3 = GC_MakeSegment(aPnt3, aPnt4)

aEdge1 = BRepBuilderAPI_MakeEdge(aSegment1.Value()).Edge()
aEdge2 = BRepBuilderAPI_MakeEdge(aSegment2.Value()).Edge()
aEdge3 = BRepBuilderAPI_MakeEdge(aSegment3.Value()).Edge()

aWire = BRepBuilderAPI_MakeWire(aEdge1, aEdge2, aEdge3).Wire()

aOrigin = gp_Pnt(0, 0, 0)
xDir = gp_Dir(1, 0, 0)
xAxis = gp_Ax1(aOrigin, xDir)

aTrsf = gp_Trsf()
aTrsf.SetMirror(xAxis)

aMirroredShape = BRepBuilderAPI_Transform(aWire, aTrsf).Shape()

aMirroredWire = topods.Wire(aMirroredShape)

akWire = BRepBuilderAPI_MakeWire()
akWire.Add(aWire)
akWire.Add(aMirroredWire)
aWireProfile = akWire.Wire()

aFaceProfile = BRepBuilderAPI_MakeFace(aWireProfile).Face()

aPrismVec = gp_Vec(0, 0, aHeight)
aBody = BRepPrimAPI_MakePrism(aFaceProfile, aPrismVec).Shape()

aTrsf = gp_Trsf()
aTrsf.SetTranslationPart(gp_Vec(-bWidth+aWidth/2.0+cWidth/2.0,0,25))
alocation = TopLoc_Location(aTrsf)
aBody.Location (alocation)


# Creat the PartB dimensions
bPnt1 = gp_Pnt(-bWidth / 2.0, 0, 0)
bPnt2 = gp_Pnt(-bWidth / 2.0, -bLength / 2.0, 0)
bPnt3 = gp_Pnt(bWidth / 2.0, -bLength / 2.0, 0)
bPnt4 = gp_Pnt(bWidth / 2.0, 0, 0)

bSegment1 = GC_MakeSegment(bPnt1, bPnt2)
bSegment2 = GC_MakeSegment(bPnt2, bPnt3)
bSegment3 = GC_MakeSegment(bPnt3, bPnt4)

bEdge1 = BRepBuilderAPI_MakeEdge(bSegment1.Value()).Edge()
bEdge2 = BRepBuilderAPI_MakeEdge(bSegment2.Value()).Edge()
bEdge3 = BRepBuilderAPI_MakeEdge(bSegment3.Value()).Edge()

bWire = BRepBuilderAPI_MakeWire(bEdge1, bEdge2, bEdge3).Wire()

bOrigin = gp_Pnt(0, 0, 0)
bxDir = gp_Dir(1, 0, 0)
bAxis = gp_Ax1(bOrigin, bxDir)

bTrsf = gp_Trsf()
bTrsf.SetMirror(bAxis)

bMirroredShape = BRepBuilderAPI_Transform(bWire, bTrsf).Shape()

bMirroredWire = topods.Wire(bMirroredShape)

bkWire = BRepBuilderAPI_MakeWire()
bkWire.Add(bWire)
bkWire.Add(bMirroredWire)
bWireProfile = bkWire.Wire()

bFaceProfile = BRepBuilderAPI_MakeFace(bWireProfile).Face()

bPrismVec = gp_Vec(0, 0, bHeight)
bBody = BRepPrimAPI_MakePrism(bFaceProfile, bPrismVec).Shape()

bTrsf = gp_Trsf()
bTrsf.SetTranslationPart(gp_Vec(-bWidth/2.0+cWidth/2.0,0,0))
blocation = TopLoc_Location(bTrsf)
bBody.Location (blocation)



# Creat the PartC
cPnt1 = gp_Pnt(-cWidth / 2.0, 0, 0)
cPnt2 = gp_Pnt(-cWidth / 2.0, -cLength / 2.0, 0)
cPnt3 = gp_Pnt(cWidth / 2.0, -cLength / 2.0, 0)
cPnt4 = gp_Pnt(cWidth / 2.0, 0, 0)

cSegment1 = GC_MakeSegment(cPnt1, cPnt2)
cSegment2 = GC_MakeSegment(cPnt2, cPnt3)
cSegment3 = GC_MakeSegment(cPnt3, cPnt4)

cEdge1 = BRepBuilderAPI_MakeEdge(cSegment1.Value()).Edge()
cEdge2 = BRepBuilderAPI_MakeEdge(cSegment2.Value()).Edge()
cEdge3 = BRepBuilderAPI_MakeEdge(cSegment3.Value()).Edge()

cWire = BRepBuilderAPI_MakeWire(cEdge1, cEdge2, cEdge3).Wire()

cOrigin = gp_Pnt(0, 0, 0)
cxDir = gp_Dir(1, 0, 0)
cAxis = gp_Ax1(cOrigin, cxDir)

cTrsf = gp_Trsf()
cTrsf.SetMirror(cAxis)

cMirroredShape = BRepBuilderAPI_Transform(cWire, cTrsf).Shape()

cMirroredWire = topods.Wire(cMirroredShape)

ckWire = BRepBuilderAPI_MakeWire()
ckWire.Add(cWire)
ckWire.Add(cMirroredWire)
cWireProfile = ckWire.Wire()

cFaceProfile = BRepBuilderAPI_MakeFace(cWireProfile).Face()

cPrismVec = gp_Vec(0, 0, cHeight)
cBody = BRepPrimAPI_MakePrism(cFaceProfile, cPrismVec).Shape() 

cCutBody = BRepPrimAPI_MakeBox(30,190,100).Shape()
cCutTrsf = gp_Trsf()
cCutTrsf.SetTranslationPart(gp_Vec(-15,-95,5))
clocation = TopLoc_Location(cCutTrsf)
cCutBody.Location (clocation)

cBody = BRepAlgoAPI_Cut(cBody, cCutBody).Shape()

cTrsf = gp_Trsf()
cTrsf.SetTranslationPart(gp_Vec(0,0,25))
clocation = TopLoc_Location(cTrsf)
cBody.Location (clocation)



# Combine A, B and C
myBody = BRepAlgoAPI_Fuse(aBody,bBody).Shape()
myBody = BRepAlgoAPI_Fuse(myBody,cBody).Shape()

# Cut inner part
transform = gp_Trsf()
aCut = BRepPrimAPI_MakeBox(aWidth-4.0, aLength-4.0, (aHeight+25.)-1.0).Shape()
transform.SetTranslationPart(gp_Vec(-aWidth*0.5-bWidth+aWidth/2.0+cWidth/2.0+2.0, -aLength/2.0+2.0, -1.0))
alocation = TopLoc_Location(transform)
aCut.Location (alocation)

transform = gp_Trsf()
bCut = BRepPrimAPI_MakeBox(bWidth-4.0, bLength-4.0, bHeight-1.0).Shape()
transform.SetTranslationPart(gp_Vec(-bWidth+6.5,-bLength*0.5+2.0,-1.0))
blocation = TopLoc_Location(transform)
bCut.Location (blocation)

transform = gp_Trsf()
cCut = BRepPrimAPI_MakeBox(12.0, 50.0, 10.0).Shape()
transform.SetTranslationPart(gp_Vec(-bWidth+4.5,-bLength*0.5+10.0,5.0))
clocation = TopLoc_Location(transform)
cCut.Location (clocation)

myCut = BRepAlgoAPI_Fuse(aCut, bCut).Shape()
myCut = BRepAlgoAPI_Fuse(myCut, cCut).Shape()

myBody = BRepAlgoAPI_Cut(myBody, myCut).Shape()



# Display the result in OCC viewer
from zeeko.occ.opencascade import *
occ, start_display = occviewer()
occ.Draw(myBody)
occ.FitAll()

# Export to STEP file
occexport('C:\Python27\myBody.step', [myBody])
