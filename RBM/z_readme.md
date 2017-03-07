### This file holders contains several matlab codes about RBM. And a review of RBM

# Restricted Boltzmann

This algorithm is a typical energy based algorithm.

![Image of Energy function]
(https://wikimedia.org/api/rest_v1/media/math/render/svg/2596eb7f60f387129fd3bbc075f37898eded353b)

![Image of another Energy function]
(https://wikimedia.org/api/rest_v1/media/math/render/svg/ef4edf17279787e29bb1a581316d17d70de2072e)

In the energy equation, vector **v** and **h** are visible layer and hidden layer as shown in following picture. Use the following picture as example, **v** is a 4 x 1 vector, **h** is a 3 x 1 vector and omega or W is a 4 x 3 matrix.

![Image of RBM]
(https://github.com/brucebismarck/algorithms-review/blob/master/RBM/rbm.png)

In addition, the joint probability of **v** and **h** could be expressed as a function of energy as following.

![Image for energy to probability]
(https://github.com/brucebismarck/algorithms-review/blob/master/RBM/Energy%20to%20P.png)

After a complicated math derivation (basically bayes conversion, calculate conditional and joint probability). We can express the conditional probability via a sigmoid method. 

![Image of sigmoid function]
(https://github.com/brucebismarck/algorithms-review/blob/master/RBM/Screen%20Shot%202017-03-06%20at%2018.55.15.png)

![Image of sigmoid function]
(https://github.com/brucebismarck/algorithms-review/blob/master/RBM/Screen%20Shot%202017-03-06%20at%2019.06.51.png)

From these two picture, we think about to use gibbs sampling method to iteratively achieve the goal: estimate the true omega matrix which can maxmize the likelihood of P(**v**)

### From here, we connect RBM with deep learning!
To use the gibbs sampling method to estimate the true model. Wikipedia has a great pseudo-code on the training process contrastive divergence.

* Take a training sample **v**, compute the probabilities of the hidden units and sample a hidden activation vector **h** from this probability distribution.
* Compute the outer product of **v** and **h** and call this the positive gradient.
* From **h**, sample a reconstruction **v'** of the visible units, then resample the hidden activations **h'** from this. (Gibbs sampling step)
* Compute the outer product of **v'** and **h'** and call this the negative gradient.
* Let the update to the weight matrix **W** be the positive gradient minus the negative gradient, times some learning rate: ![Image of W improvement](https://wikimedia.org/api/rest_v1/media/math/render/svg/4af2af0b8f0522006fef96b3d8a79b007decbf44)
* Update the biases a and b analogously ![Image of a improvement](https://wikimedia.org/api/rest_v1/media/math/render/svg/841914c5dd339996ac500e060c847b40bdb7941f)![Image of b improvement](https://wikimedia.org/api/rest_v1/media/math/render/svg/d0255b0f687bbb0214b4dc97835b187fa69d43ad)
At this point, we can find via gibbs sampling, we improve the **W** matrix iteratively to approach the global minimum. (max the product of P(v)).


Because the observation V for example have 1000 observation and each observation have 3 values, we can paralize the 1000 observation in this algorithm. 



In this file, we used MNIST to test the efficiency of 2 layer RBM. It does work, but the effect is not really cool. The video can be checkd in 
