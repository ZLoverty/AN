---
date: 2023-09-20
title: logical gate summary
---

# Logical gate summary

We try to implement the active matter logic proposed by Woodhouse and Dunkel with active nematics and channel confinement. The theoretical model is based on two key assumptions: (i) active flow prefers the longer path, (ii) there exists a diode channel, which only permits flows in a certain direction but prohibits those in the opposite direction. Therefore, the key of our experimental work is to validate these assumptions, or find a way to realize these assumptions. 

The first trial was promising. In our implementation, we use a combination of straight and ratchet channels to realize paths of various lengths and the "diode" channels, respectively. 

![picture 0](/assets/images/2023/09/LG-1.1.png)  

The only slight problem lies in the X=0, Y=1 case, where **a tiny fraction of the output flow goes into the AND gate**. Can we make it perfect? We've tried two approaches: (i) further increasing the OR gate length, (ii) removing the bottom-left tooth in Y. None worked, see section 1.

In addition, another unexpected phenomenon arises: the **back flow** in the (X=0,Y=0) case. It is puzzling that in Claire's original experiment back floww was not observed. But in Antonio's later experiment, back flow was observed in exactly the same channel geometry, suggesting that the flow configuration was not 100% determined by the geometry. Instead, noise might lead to various transient flow configurations. 

Back flow and fractional split are the main obstacles to obtain perfect logical operations in active nematics. 

To suppress back flow, we **vary the number of ratchet teeth** in the output channels. By increasing the number of ratchets from 5 to 10 in both AND and OR channels, we successfully suppressed the back flow (see section 2.1). We also tried to make the numbers of ratchets unequal between AND and OR gates, which brought back the back flow, as expected (see section 2.2).

Based on the bifurcation experiments, I once claimed that **the length of straight channels is not relevant**, or at least, of less importance compared to the ratchet. This claim entails that if we remove the straight parts from the original design, we can get the same results. We did one such test (see section 3) which supported the claim.

To what extent can we **understand the logical gate data using the laws we learned in bifurcation**? Bifurcation experiments indicates that

- straight channel length is irrelevant
- split ratio is proportional to the ratio of the numbers of ratchets
- bending angle is unfavorable (90-degree angle is about -3 ratchets)

Since all the (1,1) cases give expected results, and that (0,0) cases do not involve bifurcations, I will only consider (1,0) and (0,1) cases.


## 1. Improve (X=0,Y=1)

### 1.1. Increase OR gate length

Increasing the OR gate length does not direct more flow to the OR gate. On the contrary, it changes the original 9:1 split to 7:3 split, a more even split. Moreover, back flow from AND gate to OR gate is observed in (X=0,Y=0) case.

### 1.2. Remove bottom-left tooth in Y

(0, 0) -> (0.5, -0.5) back flow persists
(0, 1) -> (0.6, 0.4) the even split is not improved

## 2. Suppress back flow

### 2.1. Symmetric AND / OR

![picture 2](/assets/images/2023/09/symmetric-10.png)

### 2.2. Asymmetric AND / OR

![picture 3](/assets/images/2023/09/assymetric-15.png)  

![picture 4](/assets/images/2023/09/asymmetric-20.png)  

## 3. Remove straight part

![picture 5](/assets/images/2023/09/remove-straight.png)  
