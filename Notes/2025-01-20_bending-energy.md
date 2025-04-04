---
date: 2025-01-20
title: bending energy
---

# Bending energy

In [a previous note](2024-11-21_idea-on-splitting-ratio.md), I found that a notion of penalty energy $E_p$ can be used to understand the splitting behavior of active nematics at bifurcations. There, I hypothesized that the penalty energy depends on the difference between the flow rate $\phi$ and the preferred flow rate $\phi_0$:

$$
E_p \propto (\phi - \phi_0)^\alpha.
$$

This relation is likely, because it agrees with the qualitative observation that the flow rate in each channel tends to approach $\phi_0$, which minimize the energy penalty. However, the value of $\alpha$ is not readily determined. 

One possible way to determine $\alpha$ is by looking at the flow splitting ratio, as I did in the previous note. In there, I notice that when setting $\alpha=2$, I can get the splitting ratio identical to the channel length ratio, in quantitative agreement with experiment. 

## Measure $\alpha$ experimentally

To justify this scaling exponent $\alpha$, we ideally want to have some experimental evidence of the energy penalty. An intuitive thinking is to measure the bending energy $E_b$ based on the nematic configuration, and see how it depends on the flow rate. We also notice that even in the idea flowing state, there is still some bending in the system, so we decompose $E_b$ into a constant part and an excess part caused by the difference from $\phi_0$. This results in the following expression of $E_b$:

$$
E_b = E_0 + E_p = \left[ F_0 + a(\phi-\phi_0)^\alpha \right] L,
$$

where $E_0=e_0L$ is the constant bending energy when $\phi=\phi_0$, $e_0$ is the energy per length, $a$ is a coupling factor and $L$ is the length of the channels. 

Experimentally, we can measure the director field $\mathbf{n}$ of the active nematics in a channel, and use it to compute an energy density 

$$
e = \frac{1}{2} K \left[ \left( \nabla\cdot \mathrm{n} \right)^2 + \left( \nabla\times \mathrm{n} \right)^2 \right].
$$

The following picture shows an example of detected director field using the gradient structure tensor scheme. As one can see, the arrows follows nicely with the underlying nematic directions. 

![picture 0](/assets/images/2025/01/director-field.png)  

We can then apply a mask to get only the in-channel part, and compute the energy density, as shown below. The high energy regions coincide with the topological defects, validifying the director field.

![picture 1](/assets/images/2025/01/bending-energy-overlay.png)  

The $F$ here is the mean energy density in the ROI. It corresponds to the energy density term $e_0 + a(\phi-\phi_0)^\alpha$. To see the scaling between the penalty energy $e_p$ and the difference in flow rate $\phi-\phi_0$, we want to plot them together directly.

$e_0$ in this problem is unknown. We make a first approximation that the inlet flow rate in channel A is $\phi_0$. So the energy density in channel A is $e_0$. Using this, we can compute $e_p$ as 

$$
e_p = e - e_0,
$$

In the figure below, we plot the flow rate $\phi/\phi_0$ and excess bending energy $e_p$ for a 30-minute video.

<img src="/assets/images/2025/01/flowrate-and-bending-energy.png" width=700px>

Flow rate wise, $\phi_A>\phi_B>\phi_C$. Energy wise, $e_A<e_B<e_C$. This is expected qualitatively. To obtain $\alpha$, we take the mean of excess energy and plot against $|\phi-\phi_0|/\phi_0$. The scaling of these data would be $\alpha$. The result is shown in the figure below.

<img src="/assets/images/2025/01/energy-vs-flowrate.png" width=400px> 

With limited flow rate configurations, it is challenging to measure $\alpha$ definitely. 

