---
date: 2023-07-11
title: bifurcation energy model
---

### Bifurcation energy model

We seek a pseudo-equilibrium model to describe the flow behavior of active nematics in bifurcation channels. The model considers 3 components: straight channel, continuity and diode channel. Each component contributes to the final flow configuration in the form of energy penalty. Their coupling (relative importance) is specified by a set of coupling coefficients.

#### The components

##### Straight channel: double well potential

$$
H_s = \sum_{e\in E} V(\phi_e)
$$

Either order 6 or order 4.

$$
V_6(\phi_e) = - \frac{1}{4}\phi_e^4 + \frac{1}{6}\phi_e^6 
$$

$$
V_4(\phi_e) = - \frac{1}{2}\phi_e^2 + \frac{1}{4}\phi_e^4
$$

##### Continuity

$N$ denotes the collection of all nodes and $n$ represents single element in $N$. In the bifurcation network specifically, only one node exists. 

$$
H_c = \sum_{n\in N} (\mathbf{D}\cdot\mathbf{\Phi})_n^2
$$

where $\mathbf{D}$ is the sign vector of each node and $\mathbf{\Phi}$ is the flow rates in all the channels connected to the node. 

##### Diode channel: hard or soft

Hard diode:

$$
H_+ = \begin{cases}
+\infty,& \text{if } \phi_e\cdot\phi_d<0\\
0,& \text{if } \phi_e\cdot\phi_d\ge 0
\end{cases}
$$

where $\phi_d$ is the favored flow direction (the diode + direction).

Soft diode:

$$
H_+ = \gamma (\phi_e - \phi_d)^2
$$

where $\phi_d$ is the favored flow rate. If $\phi_e$ deviate from $\phi_d$, energy penalty shoots up. $\gamma$ is a channel specific coefficient, which is introduced to account for the possibility that longer channel may have bigger impact to the total energy.

$$
H_+(\phi) = (\phi - \phi_0)^2
$$

#### Coupling

We use coupling coefficients $a$, $b$ and $c$ to couple the effects from straight channel, continuity and diode channel:

$$
H = aH_s + bH_c + cH_+
$$

#### Model versions

We vary the coupling coefficients, straight channel models as well as the diode channel models. There are infinite possibilities, but we try to keep our trials clean.

- v0: $a=10,b=1000,c=100$, order 6, hard diode
- v1: $a=10,b=1000,c=100$, order 6, soft diode ($\phi_d=1, \gamma=1$)
- v2: $a=10,b=1000,c=100$, order 4, soft diode ($\phi_d=1, \gamma=1$)
- v3: $a=10,b=1000,c=100$, order 6, soft diode length ($\phi_d\propto L, \gamma\propto L$)
- v4: $a=10,b=1000,c=100$, order 4, soft diode length ($\phi_d\propto L, \gamma\propto L$)
- v5: $a=10,b=1000,c=100$, order 6, soft diode length ($\phi_d\propto 1, \gamma\propto L$)
- v6: $a=10,b=1000,c=100$, order 4, soft diode length ($\phi_d\propto 1, \gamma\propto L$)
- v7: $a=10,b=1000,c=100$, order 6, soft diode length ($\phi_d\propto L, \gamma\propto 1$)
- v8: $a=10,b=1000,c=100$, order 4, soft diode length ($\phi_d\propto L, \gamma\propto 1$)

from v9, input flow potential is imposed, and is denoted as "I". For convenience, the coefficient of input flow potential is set to $b$.

- v9: $a=10,b=1000,c=100$, soft | 4 | 1 | L | I
- 
#### Known issues

- Ratchet length is not considered
- angle is not considered
- in ratchet-rich models (e.g. model_13), all the three flow rates are not 1