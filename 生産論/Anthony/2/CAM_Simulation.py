# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 21:04:38 2017

@author: Administrator
"""

# Import some custom modules
from zeeko.occ.opencascade import*
from zeeko.occ.plotting import*

# Import workpiece from STEP file
occ, start_display = occviewer()
work = occimport("C:\Python27\myBody.step")
occ.Draw(work[0])
occ.FitAll()

# Select some faces
occ.SelectFaces([32])

# Generate shell from the selected faces
faces = occ.GetSelection(work[0])
shell = occshell(faces)

# Convert the shell to a mesh
vertices,triangles = occmesh(shell, quality = 1.)
ax = figure(projection = '3d')
trisurf(ax[0][0],vertices,triangles)
labels(ax[0][0], 'X(mm)', 'Y(mm)', 'Z(mm)')

# Define section plane
from OCC.gp import*
secPoint = gp_Pnt(0,0,0)
secDirection = gp_Dir(1,0,0)
secPlane = gp_Pln(secPoint, secDirection)

# Section workpiece with Plane, and draw result
from OCC.BRepAlgoAPI import*
section = BRepAlgoAPI_Section(shell, secPlane)
occ.Draw(section.Shape())

# Sample points every 0.5mm along the section curve
from zeeko.occ.sectioning import*
points,normals,tangents = occsample(section, secDirection, 1.)

# Compute and offset curve 2mm away
toolRadius = 2.
offsets = points + toolRadius*normals

# Plot the cross section
ax = figure()
plot (ax[0][0],points[1],points[2],color='b')
plot (ax[0][0],offsets[1],offsets[2],color='r')
quiver2d(ax[0][0],points[1],points[2],normals[1],normals[2],color='g')
legend(ax[0][0],labels =['section','offset','normals'],colors=['b','r','g'])
labels(ax[0][0],'X(mm)','Z(mm)')




# Gennerate a milling tools from primitives
from OCC.BRepPrimAPI import*
sphere = BRepPrimAPI_MakeSphere(2.0).Shape()
cylinder = BRepPrimAPI_MakeCylinder(1.5, 20.0).Shape()
tool = BRepAlgoAPI_Fuse(sphere, cylinder).Shape()
drawTool = occ.Draw(tool, selectable = False, color = occ.white)
occ.FitAll()

# Setup collision simulation
from zeeko.occ.colliders import*
from OCC.DYN.Context import*
from ode import collide

# Creat simulation world
world = DynamicSimulationContext()
world.enable_collision_detection()

# Creat colliders for the work and tool
colWork = CreateCollider(work[0],world)
colTool = CreateCollider(tool, world)

# Compute collision state
cols = collide(colWork.geometry, colTool.geometry)
print "Collisions: " + str(len(cols))

# Move the tool into work
from OCC.gp import*
transform = gp_Trsf()
transform.SetTranslationPart(gp_Vec(0,0,-3))
UpdateCollider(colTool, transform)
occ.Update(drawTool, transform, color = occ.red)

# Update collider and check again
cols = collide(colWork.geometry, colTool.geometry)
print "Collision: " + str(len(cols))



# Define a simulation routine
def Simulate(offset, normal):
    fromVector = gp_Vec(0,0,1)
    toVector = gp_Vec(normal[0],normal[1], normal[2])
    quaternion = gp_Quaternion(fromVector, toVector)
    transform.SetRotation(quaternion)
    transform.SetTranslationPart(gp_Vec(offset[0],offset[1],offset[2]))
    UpdateCollider(colTool, transform)
    cols = collide(colWork.geometry, colTool.geometry)
    cols = collide(colWork.geometry, colTool.geometry)
    if len(cols)>0:
        occ.Update(drawTool, transform, color=occ.red)
    else:
        occ.Update(drawTool, transform, color=occ.white)
    return len(cols)
    
# Simulate tool path
from time import*
length = len(offsets[0])
for i in range(0, length):
    normal = normals[:,i]
    offset = offsets[:,i] + 0.1*normal
    nCols = Simulate(offset, normal)
    if nCols > 0:
        print "Index: %i (%i collisions)" % (i, nCols)
    sleep(0.05)

# Export to CNC
f = open('Simulaton.cnc','w')
f.write(unicode('%HEADER\n'))
f.write(unicode('G54 G01 F500\n'))
for i in range(len(offsets[0])):
    line = 'X%0.3f Y%0.3f Z%0.3f\n' %(offsets[0][i], offsets[1][i], offsets[2][i])
    f.write(unicode(line))
f.close()