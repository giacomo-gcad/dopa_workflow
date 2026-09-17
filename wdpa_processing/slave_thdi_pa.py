#!/usr/bin/python  
# Code by Javier Martinez-Lopez (utf-8)
# Reviewed and developed by Giacomo Delli (JRC)

from datetime import datetime
import numpy as np
import os
import sys
import csv
sys.path.append(os.getcwd()+'/lib/')
from lib.tqdm import *

# SET VARIABLES
GISBASE = os.environ['GISBASE'] = "/home/delligi/grass_ehab/dist.x86_64-unknown-linux-gnu"
GRASSDBASE = sys.argv[6]
MYLOC = sys.argv[7]
mapset = 'map' + sys.argv[3]
col= 'cat'
#olayer=sys.argv[4] + '/parks_segmented' + sys.argv[3]
shp_path = sys.argv[4] + '/'
olayer='parks_segmented' + sys.argv[3]
#olayer='parks_segmented0'
initpa=int(sys.argv[1])
finpa=int(sys.argv[2])
pa_tc_list=sys.argv[5]
csvname1=sys.argv[4] + '/pas_segm_done_'  + sys.argv[3] + '.csv'

#CHECK VARIABLES
# print mapset
# print "*** Beginning at " + sys.argv[1]
# print "*** Ending at    " + sys.argv[2]
# print GRASSDBASE
# print MYLOC
# print olayer
# print pa_tc_list
# print csvname1
# print '**********************************************************'


#RUN SEGMENTATION
sys.path.append(os.path.join(os.environ['GISBASE'], "etc", "python"))
import grass.script as grass
import grass.script.setup as gsetup

gsetup.init(GISBASE, GRASSDBASE, MYLOC, mapset)
grass. message ("Extracting list of PAs")
pa_list2 = np.genfromtxt(pa_tc_list,dtype='string')
pa_list = pa_list2[initpa:finpa] # testing 5 first!

# print '**********************************************************'
# print mapset
# print pa_list
# print '**********************************************************'


#csvname1 = 'pas_segm_done_m1.csv'
if os.path.isfile(csvname1) == False:
 wb = open(csvname1,'a')
 wb.write('None')
 wb.write('\n')
 wb.close()

pa_list_done = np.genfromtxt(csvname1,dtype='string')

n2 = len(pa_list)
#print pa_list[1]

#switch to shape file folder path to run grass commands
os.chdir(shp_path)

#for px in tqdm(range(0,n2-1)):
for px in tqdm(range(0,n2)):
 aleat = np.random.random_integers(1000)
#for pa in pa_list:
 pa = pa_list[px]
 if pa not in pa_list_done:
  print pa
  # START COMPUTATION
  pa44 = 'pax_'+str(pa)
  #pa0 = 'v0_'+pa
  #opt1 = col+'='+pa
  #grass.run_command('v.extract', input=source, out=pa0, where = opt1,overwrite=True) # check inital region from which to copy from!
  pa0 = str(pa)
  pa2 = pa+'v2'
  pa3 = pa+'v3'
  pa4 = 'paa_pca_'+pa
  pa5 = pa4+'.txt'
  same = pa2+'= const'
  #grass. message ("setting up the working region")
  grass.run_command('g.region',vect=pa0,res=1000)
  grass.run_command('r.mapcalc',expression='const = if(gcmask>=0,1,null())',overwrite=True)
  grass.run_command('r.mapcalc',expression=same,overwrite=True)
  a = grass.read_command('r.stats',input='const',flags='nc',separator='\n').splitlines()
  if len(a)==0: a = [1, 625]
  #print a
  minarea = np.sqrt(int(a[1]))#/1000
  minaream = minarea*1000
  #print minarea
  #grass. message ("segmenting the park")
  grass.run_command('i.segment', group='segm', output=pa2, threshold='0.5', method='region_growing', similarity='euclidean', memory='100000', minsize=minarea, iterations='20',overwrite=True) # 
  #grass. message ("cropping the segments")
  grass.run_command('r.mask', vector=pa0,overwrite=True)#source, where=opt1)
  opt2 = pa3+'='+pa2
  grass.run_command('r.mapcalc',expression=opt2,overwrite=True) # usar const como mapa para crear plantilla de PA con unos y ceros
  grass.run_command('g.remove', rast='MASK')
  print minarea

  b = grass.read_command('r.stats',input=pa3,flags='nc',separator='\n').splitlines()
  print b
  clean = None
  c = pa3
  for g in np.arange(1,len(b),2):
   if np.int(b[g]) < minarea/2:
    print 'Cleaning small segments I...'
    print 'cleaning cat '+ str(b[g-1])
    c2 = 'old'+ str(b[g-1])
    c22 = c2+'b10km'
    c3 = 'new'+ str(b[g-1])
    oper1 = c2+'='+'if('+pa3+'=='+str(b[g-1])+',1,null())'
    grass.run_command('r.mapcalc',expression=oper1,overwrite=True)
    grass.run_command('r.buffer',input=c2,output=c22,distances=3,units='kilometers',overwrite=True)
    grass.run_command('r.mask', raster=c22,maskc=2,overwrite=True)
    buff = grass.read_command('r.stats',input=pa3,flags='nc',sort='desc',separator='\n').splitlines()
    grass.run_command('g.remove', rast='MASK')
    if len(buff) > 0:
     clean = 'T'
     print 'New: '+str(buff[0])
     oper1 = c3+'='+'if('+c2+'==1,'+str(buff[0])+',null())'
     c = c3 + ',' + c
     grass.run_command('r.mapcalc',expression=oper1,overwrite=True)
  if clean=='T':
   print c
   grass.run_command('r.patch',input=c,out=pa3,overwrite=True)
   bv = grass.read_command('r.stats',input=pa3,flags='nc',separator='\n').splitlines()
   print bv

  b = grass.read_command('r.stats',input=pa3,flags='nc',separator='\n').splitlines()
  print b
  clean = None
  c = pa3
  for g in np.arange(1,len(b),2):
   if np.int(b[g]) < minarea/2:
    print 'Cleaning small segments II...'
    print 'cleaning cat '+ str(b[g-1])
    c2 = 'old'+ str(b[g-1])
    c22 = c2+'b10km'
    c3 = 'new'+ str(b[g-1])
    oper1 = c2+'='+'if('+pa3+'=='+str(b[g-1])+',1,null())'
    grass.run_command('r.mapcalc',expression=oper1,overwrite=True)
    grass.run_command('r.buffer',input=c2,output=c22,distances=10,units='kilometers',overwrite=True)
    grass.run_command('r.mask', raster=c22,maskc=2,overwrite=True)
    buff = grass.read_command('r.stats',input=pa3,flags='nc',sort='desc',separator='\n').splitlines()
    grass.run_command('g.remove', rast='MASK')
    if len(buff) > 0:
     clean = 'T'
     print 'New: '+str(buff[0])
     oper1 = c3+'='+'if('+c2+'==1,'+str(buff[0])+',null())'
     c = c3 + ',' + c
     grass.run_command('r.mapcalc',expression=oper1,overwrite=True)
  if clean=='T':
   print c
   grass.run_command('r.patch',input=c,out=pa3,overwrite=True)
   bv = grass.read_command('r.stats',input=pa3,flags='nc',separator='\n').splitlines()
   print bv

  b = grass.read_command('r.stats',input=pa3,flags='nc',sort='desc',separator='\n').splitlines()
  print b
  for g in np.arange(1,len(b),2):
   if np.int(b[g]) < minarea/2:
    print 'Cleaning small segments III...'
    print 'cleaning cat '+ str(b[g-1])
    oper1 = pa3+'='+'if('+pa3+'=='+str(b[g-1])+','+str(b[0])+','+pa3+')'
    grass.run_command('r.mapcalc',expression=oper1,overwrite=True)
    bv = grass.read_command('r.stats',input=pa3,flags='nc',separator='\n').splitlines()
    print bv

  #grass. message ("Number of cells per segment")
  #grass.run_command('r.stats',input=pa3,out=pa5,overwrite=True) # flags='nc'
  #grass. message ("converting to vector")
  grass.run_command('r.to.vect', input=pa3,out=pa4,type ='area',flags='v',overwrite=True)
  #grass. message ("adding labels to segments")
  grass.run_command('v.db.addcolumn', map=pa4,col='wdpaid_pa VARCHAR')
  grass.run_command('v.db.update', map=pa4,col='wdpaid_pa',value=pa)
  grass.run_command('v.db.addcolumn', map=pa4,col='aleat VARCHAR')
  grass.run_command('v.db.update', map=pa4,col='aleat',value=aleat)
  #grass. message ("Checking shapefile")
  pa44 = pa4
  #grass.run_command('v.clean', input=pa4,out=pa44,tool='rmarea',thres=minaream,overwrite=True)
  grass.run_command('v.db.addcolumn', map=pa44,col='segm_id VARCHAR')
  grass.run_command('v.db.update', map=pa44,col='segm_id',qcol='wdpaid_pa || cat || aleat')
  #grass. message ("Exporting shapefile")
  if os.path.isfile(olayer+'.shp') == False:
   grass.run_command('v.out.ogr',input=pa44,ola=olayer,type='area',dsn='.') 
  else:
   grass.run_command('v.out.ogr',flags='a',input=pa44,ola=olayer,type='area',dsn='.')
  grass. message ("Deleting tmp layers")
  grass.run_command('g.mremove',typ='rast',patt='old*',flags='f')
  grass.run_command('g.mremove',typ='rast',patt='new*',flags='f') 
  grass.run_command('g.mremove',typ='rast',patt='*b10km',flags='f') 
  grass.run_command('g.mremove',typ='rast',patt='*v3',flags='f') 
  grass.run_command('g.mremove',typ='rast',patt='*v2',flags='f') 
  grass.run_command('g.mremove',typ='rast',patt='v0_*',flags='f') 
  grass.run_command('g.mremove',typ='rast',patt='pa_*',flags='f') 
  grass.run_command('g.mremove',typ='vect',patt='v0_*',flags='f') 
  grass.run_command('g.mremove',typ='vect',patt='pa_*',flags='f') 
  grass.run_command('g.mremove',typ='vect',patt='paa_*',flags='f') 
  grass.run_command('g.mremove',typ='vect',patt='paa_pca*',flags='f')
  grass. message ("Done")
  print "Done PA:"+pa 
  wb = open(csvname1,'a')
  var = str(pa)
  wb.write(var)
  wb.write('\n')
  wb.close() 

print str(datetime.now())
print 'END'
