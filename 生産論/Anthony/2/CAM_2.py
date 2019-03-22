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
from OCC.gp import*
from OCC.TopLoc import*
transform = gp_Trsf()
angle = deg2rad(90)
axis = gp_Ax1(gp_Pnt(0,0,0),gp_Dir(0,1,0))
transform.SetRotation(axis, angle)
transform.SetTranslationPart(gp_Vec(10,0,0))
location = TopLoc_Location(transform)
work[0].Location(location)
occ.Draw(work[0])
occ.FitAll()

# Select some faces
occ.SelectFaces([1,4,7,10])

# Generate shell from the selected faces
faces = occ.GetSelection(work[0])
shell = occshell(faces)

# Gennerate a milling tools from primitives
from OCC.gp import*
from OCC.BRepAlgoAPI import*
from zeeko.occ.sectioning import*
from OCC.BRepPrimAPI import*
sphere = BRepPrimAPI_MakeSphere(2.0).Shape()
cylinder = BRepPrimAPI_MakeCylinder(1.5, 20.0).Shape()
tool = BRepAlgoAPI_Fuse(sphere, cylinder).Shape()
drawTool = occ.Draw(tool, selectable = False, color = occ.white)
occ.FitAll()

# Define section plane
sectionList = []
for i in linspace(-100,100,101):
    secPlane = gp_Pln(gp_Pnt(0,i,0),gp_Dir(0,1,0))
    section = BRepAlgoAPI_Section(shell, secPlane)
    points, normals, tangents = occsample(section, gp_Dir(1,0,0), 0.5)
    sectionList.append([points, normals])
    occ.Draw(section.Shape())
    
# Compute and offset curve 2mm away
    toolRadius = 2.
    offsets = points + toolRadius*normals

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
    f = open('Path3.cnc','a')
    f.write(unicode('%HEADER\n'))
    f.write(unicode('G54 G01 F500\n'))
    for i in range(len(offsets[0])):
        line = 'X%0.3f Y%0.3f Z%0.3f\n' %(offsets[0][i], offsets[1][i], offsets[2][i])
        f.write(unicode(line))
    f.close()
