---
date: 2025-01-22
title: Use Q-tensor to calculate bending energy
---

# Use Q-tensor to calculate bending energy

When using the director field to calculate bending energy, according to the formula

$$
e = \frac{1}{2} K \left[ \left( \nabla\cdot \mathrm{n} \right)^2 + \left( \nabla\times \mathrm{n} \right)^2 \right],
$$

I get some results that seem to make sense. When examining the energy field closely, I notice that at some point, adjacent director can point to almost opposite directions, as illustrated below. In the nematic point of view, these directors are perfectly aligned and should not induce any energy penalty. However, this director field has a non-trivial $\nabla\cdot \mathrm{n}$, giving rise to bending energy penalty. 

![picture 0](/assets/images/2025/01/opposite-pointing-director.png)  

For nematic alignment, we need to impose head-tail invariance to the director field. The solution is to use Q-tensor to describe the director field,

$$
Q = S \left( n_in_j - \frac{1}{2} \delta_{ij} \right),
$$

where $S$ is a scalar alignment magnitude. $Q$, as a tensor, describes the filament alignment direction of at a point. No matter the orientation of $\mathrm{n}$ is positive or negative, $Q$ remains the same. 

## Bending energy from Q-tensor

We then need to evaluate the bending energy based on the $Q$ tensor. <font color="red"> I don't find an expression for the bending energy, but intuitively, it should be related to the gradient of all the components of the gradient of the Q-tensor.</font> Here, I choose to express the energy as the sum of all unique Q-tensor gradient components:

$$
e = (\partial_x Q_{xx})^2 + (\partial_y Q_{xx})^2 + (\partial_x Q_{xy})^2 + (\partial_y Q_{xy})^2 + (\partial_x Q_{yy})^2 + (\partial_y Q_{yy})^2.
$$

We could also do the square of $\nabla Q$. I expect the result to be similar.

$$
e = \nabla Q (\nabla Q)^T
$$

The following figure shows the director field, as well as the energy distribution calculated from the Q-tensor. Focus at the bottom part of the image, we notice that the directors are pointing opposite in the middle, but the energy is low (not red). This result shows that the Q-tensor energy calculation is better than the director one. At least, it integrates the head-tail symmetry to the calculation. 

<img src="/assets/images/2025/01/director-and-q-tensor-overlay.png" width=700px>

## Bending energy vs. flow rate

As in [the previous note](2025-01-20_bending-energy.md), we look at the correlation between bending energy and the flow rate difference. This seems closer to a power 2 relationship. We will need more data at other flow rates to verify this scaling. The only available data now is that at $1-\phi/\phi_0=0.5$. I will get that shortly.

<img src="/assets/images/2025/01/bending-energy-flowrate-qtensor.png" width=400px>
