---
date: 2025-01-24
title: inconsistent energy results
---

# Inconsistent energy results

[The previous note](2025-01-22_use-q-tensor-to-calculate-bending-energy.md) shows pretty good excess energy relation with flow rate, for the 4-14-4 channels. I was expecting good result from the 4-4-4 channels, but the results were inconsistent.

I did not finish up this note on the day I started, but I kept changing the smoothing parameters, namely the two sigmas in the director field calcualtion and the smoothing size in the Q-tensor to bending energy step. As a result, I lost the original inconsistent energy results.

Currently, I have qualitatively consistent excess energy data: higher flow rate corresponds to lower energy. See the figure below. This correspondence is now pretty consistent over long time. We can also check the validity of the energy-flowrate relationship by plotting them together.

<img src="/assets/images/2025/02/bending-energy-and-flow-rate.png" width=700px> 
