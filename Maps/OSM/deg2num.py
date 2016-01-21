#!/usr/bin/python

import math, sys
def deg2num(lat_deg, lon_deg, zoom):
  lat_rad = math.radians(lat_deg)
  n = 2.0 ** zoom
  xtile = int((lon_deg + 180.0) / 360.0 * n)
  ytile = int((1.0 - math.log(math.tan(lat_rad) + (1 / math.cos(lat_rad))) / math.pi) / 2.0 * n)
  return (xtile, ytile)

def main(): 
  x=deg2num(float(sys.argv[1]), float(sys.argv[2]), float(sys.argv[3]))
  print x[0], x[1]

if __name__ == '__main__':
  main() 