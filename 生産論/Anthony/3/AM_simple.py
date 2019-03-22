# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 10:51:57 2017

@author: Administrator
"""

# Import workpiece from STEP file
from zeeko.occ.opencascade import*
work = occimport("C:\Python27\Body.step")
occ, start_display = occviewer()
from OCC.gp import*
from OCC.TopLoc import*
transform = gp_Trsf()
angle = deg2rad(90)
axis = gp_Ax1(gp_Pnt(0,0,0),gp_Dir(0,1,0))
transform.SetRotation(axis, angle)
transform.SetTranslationPart(gp_Vec(0,100,5))
location = TopLoc_Location(transform)
work[0].Location(location)
occ.Draw(work[0])
occ.FitAll()

# Compute ths bounding box for this workpiece
xMin, yMin, zMin, xMax, yMax, zMax = occbounds(work[0])
xLen = (xMax - xMin)
yLen = (yMax - yMin)
zLen = (zMax - zMin)
print xLen, yLen, zLen

# Select some faces
occ.SelectFaces([1,4,7,10])

# Generate shell from the selected faces
faces = occ.GetSelection(work[0])
shell = occshell(faces)

# Define section plane
from OCC.gp import*
from OCC.BRepAlgoAPI import*
from zeeko.occ.sectioning import*
sectionList = []
for i in linspace(0,200,51):
    secPlane = gp_Pln(gp_Pnt(0,i,0),gp_Dir(0,1,0))
    section = BRepAlgoAPI_Section(shell, secPlane)
    points, normals, tangents = occsample(section, gp_Dir(1,0,0), 0.5)
    sectionList.append([points, normals])
    occ.Draw(section.Shape())

# Compute the required number of voxels
voxRes = 2.0
xNum = int(xLen/voxRes)
yNum = int(yLen/voxRes)
zNum = int(zLen/voxRes)
print xNum, yNum, zNum

# Generate voxel volume with polyvox
from zeeko.voxel.PolyVoxCore import*
region = Region(Vector3Dint32_t(-1,-1,-1), Vector3Dint32_t(xNum+1,yNum+1,zNum+1))
volume = SimpleVolumeuint8(region)

# Generate solid classifier
from OCC.BRepClass3d import*
solidClassifier = BRepClass3d_SolidClassifier(work[0])

# Go through each voxel and check 
from OCC.gp import*
for i in range(xNum):
    for j in range(yNum):
        for k in range(zNum):
            x = xMin + (i*xLen/xNum)
            y = yMin + (j*yLen/yNum)
            z = zMin + (k*zLen/zNum)
            solidClassifier.Perform(gp_Pnt(x,y,z), 0.001)
            if solidClassifier.State()==0:
                volume.setVoxelAt(i,j,k,255)

# Create a mesh, pass it to the extractor and generate the mesh
mesh = SurfaceMeshPositionMaterialNormal()
extractor = CubicSurfaceExtractorWithNormalsSimpleVolumeuint8(volume, region, mesh)
extractor.execute()

# Convert the output to trangles and vertices
triangles = []
ind = mesh.getIndices()
for tri in range(len(ind)/3):
    triangles.append([ind[0+tri*3],ind[1+tri*3],ind[2+tri*3]])
    
vertData = mesh.getVerticesData()
xVox = vertData[0::3]; yVox = vertData[1::3]; zVox = vertData[2::3]
vertices = [xVox*xLen+xMin, yVox*yLen+yMin, zVox*zLen+zMin]
    
# Plot the result
from zeeko.occ.plotting import*
ax = figure(projection = '3d')
trisurf(ax[0][0],vertices,triangles)
labels(ax[0][0], 'X(mm)', 'Y(mm)', 'Z(mm)')

# Export to STL
from stl import*
stlMesh = Mesh(zeros(len(triangles),dtype=Mesh.dtype))
for i in range(len(triangles)):
    for j in range(3):
        vIndex = triangles[i][j]
        stlMesh.vectors[i][j][0] = vertices[0][vIndex]
        stlMesh.vectors[i][j][1] = vertices[1][vIndex]
        stlMesh.vectors[i][j][2] = vertices[2][vIndex]
stlMesh.save('AM_simple.stl')
