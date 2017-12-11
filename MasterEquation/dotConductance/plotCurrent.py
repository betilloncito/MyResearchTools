import numpy as np
import sys, getopt
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from pylab import *
from matplotlib.font_manager import FontProperties

def main(argv):
    # Defaults
    plotdIdV = 0
    try:
        opts, args = getopt.getopt(argv,"dhi:o:s:",["dIdV","infile=","ofile=","settings="])
    except getopt.GetoptError:
        print 'test.py -o <outputfile> [-d]'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'test.py -o <outputfile> [-d]'
            sys.exit()
        elif opt in ("-d","--debug"):
            plotdIdV = 1
        elif opt in ("-i","--infile"):
            infile = arg
        elif opt in ("-o","--ofile"):
            outputfile = arg
        elif opt in ("-s","--settings"):
            settingFile = arg
    
    # Load the current data
    current = np.loadtxt(infile)
    
    # Load the settings
    inputs = open(settingFile)
    line = inputs.readline()
    while line: # Will loop until empty line is hit
        exec(line)
        line = inputs.readline()
    
    # Calculate the bias and gate that were used
    bias = np.linspace(biasMin,biasMax,num=biasRes)
    gate = np.linspace(gateMin,gateMax,num=gateRes)
    
    if plotdIdV:
        # calculate dIdV
        dIdV = np.diff(current) / (bias[1]-bias[0])
        #plot it
        fig, ax = plt.subplots()
        imgplot = plt.imshow(dIdV,extent=[min(gate),max(gate),min(bias),max(bias)], aspect='auto')
        plt.colorbar(imgplot)
        plt.show()
    else:
        # Plot current
        fig, ax = plt.subplots()
        imgplot = plt.imshow(current,extent=[min(gate),max(gate),min(bias),max(bias)], aspect='auto')
        plt.colorbar(imgplot)
        plt.show()

if __name__ == "__main__":
    main(sys.argv[1:])