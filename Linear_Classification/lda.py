# -*- coding: utf-8 -*-
"""
Bismarck Liu

This is a temporary script file.
"""
from numpy import *
def fda(c1, c2):
    # This is a simple demo of Fisher Discriminant Analysis
    # Input:
    #      c1 : class 1 data
    #      c2 : class 2 data      
    # Output:
    #      W: projection matrix 
    #      y: y = np.dot(np.transpose(W), X)    
    # 'dimension reduced from d to q so d < q'
  
    
    m1 = mean(c1, axis = 0)  # generate average value of c1 
    # result is 
    m2 = mean(c2, axis = 0)
    
    c_total = concatenate([c1,c2],axis = 0)
    m = mean(c_total,axis = 0)
    
    n1 = c1.shape[0]
    n2 = c2.shape[0]
    
    #S1 is the within class 1 covariance matrix
    s1=s2 = zeros((3,3))
    n = len(m1)
    for i in range(n1):
         s1 = s1 + dot(transpose(c1[i,:]-m1).reshape(n,1),(c1[i,:]-m1).reshape(1,n))
    for i in range(n2):
         s2 = s2 + dot(transpose(c2[i,:]-m1).reshape(n,1),(c2[i,:]-m1).reshape(1,n))
    Sw = s1 + s2
    Sb= dot((m2-m1).reshape(n,1), transpose((m2 - m1).reshape(n,1)))
    
    w = dot(linalg.inv(Sb), m2-m1)
    return w


fda(c1,c2)

c1 = np.array([[1,2,7],[4,5.5,6]],dtype = np.float32)
c2 = np.array([[7,2.6,9],[10,11.5,12]],dtype = np.float32)
