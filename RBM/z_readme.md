### This file holders contains several matlab codes about RBM. And a review of RBM

# Restricted Boltzmann

This algorithm is a typical energy based algorithm.

![Image of Energy function]
(https://wikimedia.org/api/rest_v1/media/math/render/svg/2596eb7f60f387129fd3bbc075f37898eded353b)

![Image of another Energy function]
(https://wikimedia.org/api/rest_v1/media/math/render/svg/ef4edf17279787e29bb1a581316d17d70de2072e)

In the energy equation, vector **v** and **h** are visible layer and hidden layer as shown in following picture. Use the following picture as example, **v** is a 6 x 1 vector, **h** is a 2 x 1 vector and omega or W is a 6 x 2 matrix.

![Image of RBM]
(https://camo.githubusercontent.com/56d9d59e5758cbe781881771441fc68ff7e68a86/687474703a2f2f646c2e64726f70626f782e636f6d2f752f31303530362f626c6f672f72626d732f72626d2d6578616d706c652e706e67)

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
To use the gibbs sampling method to estimate the true model. Wikipedia has a great pseudo-code.

* Take a training sample **v**, compute the probabilities of the hidden units and sample a hidden activation vector **h** from this probability distribution.
* Compute the outer product of **v** and **h** and call this the positive gradient.
* From **h**, sample a reconstruction **v'** of the visible units, then resample the hidden activations **h'** from this. (Gibbs sampling step)
* Compute the outer product of **v'** and **h'** and call this the negative gradient.
* Let the update to the weight matrix **W** be the positive gradient minus the negative gradient, times some learning rate: 
* 
