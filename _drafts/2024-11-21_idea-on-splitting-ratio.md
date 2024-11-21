---
date: 2024-11-21
title: an idea on splitting ratio
---

# An idea on splitting ratio

Today, we reviewing the bifurcation video, I realized that the microtubule filament organization in the slow channel was quite different from the fast channel. An example is shown in the picture below. This is the fully ratchet channel with 4, 13, 4 teeth in channel A, B and C, B being the longer and faster outlet channel. I observe that in faster channels the filaments are more aligned, while in the slower channel the bendings are more pronounced. 

<img src="/assets/images/2024/11/filament-organization-frustrated.png" width=700px> 

I can understand this by hypothesizing that given activity and channel geometry, the active nematics have an intrinsic velocity $V_0$. Due to mass conservation, the outlet channels cannot reach $V_0$ at the same time, so frustration has to occur. We can use an energy penalty, $E_p$ to describe this frustration. Apparently, the energy penalty depends on the difference between the intrinsic velocity $V_0$ and the actual velocity $V$. It should also depend on the length of the channel, because I assume that it is the extra bending that causes the energy penalty. So taken together, we have a scaling of $E_p$:

$$
E_p \propto (V_0 - V)^\alpha L.
$$

Note that the dependence on the velocity is not necessarily linear. In fact, I found that when $\alpha=2$, this scaling gave the splitting ratio identical to the number of ratchet ratio. Here's a brief derivation. Say the velocity in channel A is $V_0$, the intrinsic velocity. The velocity in channels B and C are $V_B$ and $V_C$. The velocities satisfy

$$
V_0 = V_B + V_C.
$$

The total energy penalty in the two outlet channels are 

$$
E_{p,T} = E_{p,B} + E_{p,C} = (V_0 - V_B)^2 L_B + (V_0 - V_C)^2 L_C,
$$

where

$$
L_B = 3L_C.
$$

We can simplify $E_{p,T}$ as

$$
E_{p,T} = \left[ 3V_C^2 + (V_0 - V_C)^2 \right]L_C.
$$

The goal is to minimize $E_{p,T}$, which is very simple:

$$
E_{p,T} = 4\left( V_C - \frac{1}{4}V_0 \right)^2 + \frac{15}{16}V_0^2,
$$

which is minimal when $V_C=V_0/4$. This means $V_B = 3V_0/4$, which gives exactly the splitting ratio we observed.

The only missing piece in this picture is $\alpha=2$ is not well justified. One way to do it is to think of the energy penalty as caused by the additional bending. When looking at the formula for the free energy associated with distortion in free energy, I found this promising because all the terms has a square of director field. But I haven't figured out how to set up the connection between the velocity difference and the bending. This is likely the last missin piece of this paper. 