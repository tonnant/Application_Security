from numpy import *
from pylab import *

def DPC(G, r, n, p, num_of_iter) :

    p_list = []
    SIR_list = []

    #remove all elements except diagonals 
    diagG = diag(diag(G))

    #calculation of SIR and p
    for _ in range(num_of_iter) :
        SIR = dot(diagG,p) / (dot((G-diagG),p)+n)
        p_list.append(transpose(p)[0])
        SIR_list.append(transpose(SIR)[0])
        p = (r / SIR) * p

    #gather data according to sub index
    p_list, SIR_list = zip(*p_list), zip(*SIR_list)

    figure(1, (14,7))

    #plot power levels
    subplot(121)
    title('The convergence of power levels in an example of DPC')
    xlabel('iteration')
    ylabel('power(mW)')
    for i in range(len(p_list)) :
        plot(p_list[i], label='link '+str(i))
    grid()
    legend()

    #plot SIRs
    subplot(122)
    title('The convergence of SIRs in an example of DPC')
    xlabel('iteration')
    ylabel('SIR')
    for i in range(len(SIR_list)) :
        plot(SIR_list[i], label='link '+str(i))
    grid()
    legend()

    show()
    

if __name__ == '__main__':
    
    #channel gain
    G = array([[1,0.1,0.2,0.3],
               [0.2,1,0.1,0.1],
               [0.2,0.1,1,0.1],
               [0.1,0.1,0.1,1]])
    
    #desired SIRs
    r = array([[2.0],
               [2.5],
               [1.5],
               [2.0]])

    #noise
    n = array([[0.1],
               [0.1],
               [0.1],
               [0.1]])
    
    #initial power level
    p = array([[1.0],
               [1.0],
               [1.0],
               [1.0]])

    #number of iteration
    number_of_iteration = 10
    
    DPC(G,r,n,p,number_of_iteration)
