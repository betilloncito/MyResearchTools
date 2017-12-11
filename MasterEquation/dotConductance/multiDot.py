import numpy as np
import sys, getopt
import kouwenhoven
import matplotlib.pyplot as plt

def main(argv):
    # Defaults (I should remove these)
    biasMin = -0.02
    biasMax = 0.02
    biasRes = 1
    gateMin = 0.3
    gateMax = 0.5
    gateRes = 1
    temperature = 0.1
    infile = ''
    outputfile = ''
    DEBUG = 0
    plotDebug = 0
    try:
        opts, args = getopt.getopt(argv,"dhi:o:p",["debug","infile=","ofile=","plotDebug"])
    except getopt.GetoptError:
        print 'test.py -o <outputfile> [-d]'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'test.py -o <outputfile> [-d]'
            sys.exit()
        elif opt in ("-d","--debug"):
            DEBUG = 1
        elif opt in ("-i","--infile"):
            infile = arg
        elif opt in ("-o","--ofile"):
            outputfile = arg
        elif opt in ("-p","--plotDebug"):
            plotDebug = 1
    
    # Read all input parameters from the input file
    inputs = open(infile)
    line = inputs.readline()
    while line: # Will loop until empty line is hit
        exec(line)
        line = inputs.readline()
    
    bias = np.linspace(biasMin,biasMax,num=biasRes)
    gate = np.linspace(gateMin,gateMax,num=gateRes)
    current = np.zeros((len(bias),(len(gate))))
    
    for k in range(len(bias)):
        for j in range(len(gate)):
            [ current[k,j], debug1 ] = kouwenhoven.tunnelling(DEBUG,bias[k],0,gate[j],gate[j],temperature, c1L, c1R, c1G, c2L, c2R, c2G, cM, g1L, g1R, g2L, g2R, gM )
            sys.stdout.write("\r Calculating gate " + str(j) + " of " + str(len(gate)) + " and bias "+str(k)+" of "+str(len(bias)))
            sys.stdout.flush()
            
    np.savetxt(outputfile,current)
    
    if plotDebug:
        #imgplot = plt.plot(debug1[:,3])
        fig, ax = plt.subplots()
        imgplot = plt.imshow(debug1)
        ax.set_aspect(debug1.shape[1]*1.0/debug1.shape[0])
        plt.colorbar(imgplot)
        plt.show()
    
if __name__ == "__main__":
    main(sys.argv[1:])