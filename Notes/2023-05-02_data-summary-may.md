---
date: 2023-05-02
title: Data summary May
---

### Data summary (May)

- Overview: How many experiments do we have? What are they (proportions, e.g. symmetric, asymmetric)? 
- Key messages and supporting evidence

##### Overview

We have in total 33 days of experiments, 20 days being symmetric and 13 days being asymmetric. In terms of the length of videos, symmetric experiments count up to 51.29 hours and asymmetric experiments count up to 38.08 hours. 

13 models of bifurcation channel designs have been tested and the time distribution is shown below.

![duration distribution](/assets/images/2023/05/duration-distribution.png)

Among the 13 models, `model_11_S` has the longest experiment duration of 16 hours. The channel design is exactly the same as `model_01_S`, except that `model_11_S` is a minimal version where the supporting disk is removed. Combining the two designs together, we have 18 hours of flow data. 

![model 01 and 11](/assets/images/2023/05/model-01-and-11.png)

Other extensively tested designs include `model_10_S` and `model_03_S`, about 10 hours and 4 hours respectively. The two designs are very similar in spirit: one of the three channels is modified with ratchet to serve as the input. However, they have subtle difference in the channel width, one being 100 $\mu$m and the other being 150 $\mu$m.

![model 10 and 03](/assets/images/2023/05/model-10-and-03.png)

Asymmetric designs are tested relatively less, with the longest one `model_07_A` being about 7 hours. 

![model 07](/assets/images/2023/05/model-07.png)

#### Key messages

##### 1. Straight channel bifurcation does not favor polarized states. 

We have 6 days of valid experiments for `model_01` and `model_11`, in total 18.56 hours of observation. The table below shows the detailed breakdown of each experiment, as well as the concise flowrate/continuity/polarization (FCP) description. 

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 19 January 2023  | model_01_S | 371.1     | 0.192      | 0.386        | 3.50     |
| 14 December 2022 | model_11_S | 220.3     | 0.211      | 0.353        | 1.00     |
| 15 December 2022 | model_11_S | 494.4     | 0.182      | 0.405        | 2.00     |
| 12 April 2023    | model_11_S | 512.0     | 0.186      | 0.408        | 3.00     |
| 13 April 2023    | model_11_S | 780.2     | 0.121      | 0.455        | 4.50     |
| 14 April 2023    | model_11_S | 469.4     | 0.081      | 0.432        | 4.56     |

The average flow rate $F=474\pm 185$ $\mu$m$^2$/s shows big variations across different experiments. Such variation could be reduced by using freshly prepared ingredients, as evidenced by the most recent experiments. The continuity parameter $C=0.16\pm 0.05$ is unexpectedly large and is quite uniform across different experiments. The underlying reason is _not clear_. The polarization parameter $P=0.41\pm 0.04$ has some interesting implication: _neither polarized state nor equally split state is favored_. Imagine that we have a symmetric bifurcation system where $\phi_A$ is fixed at -1. Then $\phi_B+\phi_C=1$. Recall the definition of $P$ is just $|(\phi_B-\phi_C)/\phi_A|$. If the flow is always in the polarized state, $P=1$. If the flow is always splitted equally, i.e. $\phi_B-\phi_C=0$, $P=0$. Interestingly, if neither of them are favored, but splits in all ratios are equally probable, we expect $P\approx 0.5$, in good agreement with the measurement. 

The superposition of normalized flow rate histograms confirms that all the flow configurations are accessed with approximately equal frequency, as long as the continuity condition is satisfied (the elliptical contour). 

![01 11 histogram superposition](/assets/images/2023/05/model-01-11-hist-super.png)

In all the 6 days of experiment, we observe a biase: the channel farthest from the square base is always an input channel. This biase is highly reproducible: in the 18-hour experiment, we observe this biase in more than 15 hours, with the only exception happening in the sample revived with PEP (13 apr 2023: 4-8). The asymmetric design is likely the cause of the biase, but the mechanism is _not clear_.

![model 11 3d](/assets/images/2023/05/model-11-3d.png)

##### 2. Input ratchet does not favor polarized states

Another channel design that has been tested extensively is `model_03` and `model_10`. The table below summarizes the FCP results. 

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 01 February 2023 | model_03_S | 857       | -0.18      | 0.343        | 4.08     |
| 22 January 2022  | model_10_S | 229.6     | -0.031     | 0.468        | 0.92     |
| 26 July 2022     | model_10_S | 533.9     | -0.19      | 0.261        | 1.25     |
| 28 February 2023 | model_10_S | 1309.5    | 0.039      | 0.246        | 4.37     |
| 08 March 2023    | model_10_S | 848.2     | 0.059      | 0.263        | 4.5      |

With ratchet, the average flow rate is enhanced to $F=755\pm 403$ $\mu$m$^2$/s, the variation is still big. The continuity $C=-0.06\pm 0.12$ is satisfied better compared to no-ratchet cases. The polarization parameter $P=0.32\pm 0.09$ is lower than the no-ratchet cases, and is significantly lower than 0.5, the totally random expectation. 

The combined histogram provides more details. Channel A is always set to the ratchet channel. We can look at the third panel ($\phi_B$-$\phi_C$) for an example: instead of a uniform line between (1, 0) and (0, 1), the histogram looks more like a peak at (0.5, 0.5), which gradually fades out towards more polarized configurations. 

![model 03 10 hist superposition](/assets/images/2023/05/model-03-10-hist-super.png)

<style>
.hlbox {
  border: 2px dotted black;
  background-color: lightblue;
  padding: 5px 5px 5px 5px;
  margin: 10px 0px 10px 0px;
}
.note {
  border: 2px dotted black;
  background-color: gray;
  padding: 5px 5px 5px 5px;
  margin: 10px 0px 10px 0px;  
}
</style>

<div class="hlbox">
I can postulate a few <b>"laws"</b> that can explain the two datasets above:

- ratchet channels produce directed flow at large magnitude;
- outside factors, e.g. tiltedness and square base, introduces biase at intermediate magnitude;
- straight channels are dominated by active noise, at small magnitude.
</div>

In full straight channels, the flow configurations show no preference, a signature of noisy process. The presence of the square base introduce a biase beyond the magnitude of the noise, so that the farthes channel from the base is always the input. The splitted flow is on the same order of the noise, so noise can make the flow rate configuration change very frequently, resulting in the "equally probable" signature. 

In ratchet channels, the input has a large magnitude, compared to the input induced by the square base. As a result, the contribution of the noise is overwhelmed by the large flow, so that change of flow configurations becomes difficult. 

To make the picture more concrete, let's say noise is 1, square base is 2, and ratchet is 4. In square base case, 2 splits into (1, 1) and each is about the same magnitude as the noise, resulting in frequent change. In the ratchet case, however, 4 is splitted into (2, 2), each is way larger than the noise. So the noise can only vary the flow rate slightly, but flow configuration is rather difficult to change. 

_It's possible to make these numbers more specific by analyzing the data. For example, in the ratchet case, the spreading about (0.5, 0.5) suggests the magnitude of the noise, in terms of flow rate._

It is interesting to see how far these "laws" extend. 

##### 3. Length of straight channels does not matter

Longer length of a straight channel does not make it a more favorable path. To show this, let's look at `model_05` and `model_12`. Both designs consist a short ratchet channel as the input, and two output channels where one is much longer than the other. The detailed dimensions are annotated in the picture below. 

![model 05 and 12](/assets/images/2023/05/model-05-and-12.png)

The experiments of these two designs are summarized in the table below.

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 03 March 2023    | model_05_L |    1263.9 |      0.013 |        0.472 | 6        |
| 23 February 2023 | model_12_L |     145.3 |     -0.166 |        0.449 |      2.7 |
| 24 February 2023 | model_12_L |     994.1 |     -0.139 |        0.255 |     3.31 |

The flow rate $F=801\pm 584$ $\mu$m$^2$/s show large fluctuations. The outlier (23 feb 2023) looks different from other samples, characterized by many fluorescent aggregates. So many aggregates indicate the poor quality of active solution. The other two experiments show consistent flow rate. The continuity $C=-0.10\pm 0.10$ is acceptable. The polarization $P=0.39\pm 0.12$ is close to the no-ratchet cases, and is expected because we postulate that the length of straight channels does not introduce biase.

On top of these parameters, we are also interested to see if the flow has a preferred direction. We can look at the superposed histogram below. B is the longer output and C is the shorter output. From the histogram, we may conclude that the input flow bifurcates into non-equal ratios, and that the shorter channel is slightly more favored. We shall see, however, that the biase into shorter channel is more likely to be a result of the tilted grids, and is very fragile. 

![model 05 12 hist super](/assets/images/2023/05/model-05-12-hist-super.png)

The figure below shows the $\phi_B$-$\phi_C$ histograms of 4 independent experiments. The insets are the whole grid images corresponding to the data. The superposition of the 4 histograms is the last panel of the above figure. While the superposition feels like a simple split, the independent histograms suggests that multiple splitting ratios are possible. From left to right, top to bottom, we have equal-split, polarization-to-short, polarization-to-long and biased-split. In the same design, we get very diverse flow configurations. What does this imply? The channel length does NOT govern how the microtubules flow! Rather, it is the outside factor, i.e. the tilted grid, that is introducing the biase. For example, the grids in experiment 2 and 3 are obviously tilted, and the resulting flows are polarized. On the contrary, the grids in experiment 1 and 4 are less tilted, and the resulting flows are splitted, a consequence of noise.  

![model 05 12 hist super](/assets/images/2023/05/model-05-12-hist-independent.png)

##### 4. How to control the flow by channel design? More ratchet!

At this point, I'm convinced that straight channels cannot do much about the flow. Can we control the flow by other designs? The answer is probably using more ratchets. We shall use some experimental evidence to support the following statements:

- ratchet induces stronger flow, making noise less important
- more ratchet teeth makes one channel more favored

The experiments we are going to look at are `model_02`, `model_13` and `model_14`. In all these designs, all the three channels are modified with ratchet. Details can be found in the following picture. Note that the only difference between `model_13` and `model_14` is the number of teeth in the long channel.

![model 02 13 14](/assets/images/2023/05/model-02-13-14.png)

The experiments with these models are summarized in the table below. 

| Date            | Model      | Flow rate | Continuity | Polarization | Duration |
|-----------------|------------|-----------|------------|--------------|----------|
| 31 January 2023 | model_02_S |    1085.1 |      0.072 |        0.342 | 3        |
| 01 March 2023   | model_13_L |    1039.5 |       0.02 |        0.375 |      1.5 |
| 02 March 2023   | model_14_L |    1348.6 |     -0.071 |        0.128 |      5.5 |

The flow rate $F=1158\pm 167$ $\mu$m$^2$/s, large and uniform. The continuity $C=0.01\pm 0.07$ is also satisfied very well. The polarization $P=0.28\pm 0.13$, much lower than the cases dominated by noise. This is because two of the three designs, namely `model_02` and `model_14`, according to our postulates, should exhibit equal-split, which corresponds to $P=0$. The other model -- `model_13` -- has 13 pairs of teeth on the longer output channel and 4 pairs of teeth on the shorter output channel. We expect the longer channel with more ratchet teeth to be more favorable. Assume that the split ratio is the same as the number of teeth ratio, the expected polarization parameter for `model_13` is $P=0.53$. The measured $P$ for `model_13` is 0.375, which is fairly different from the hypothetical value. Nevertheless, it is the largest among the three models, in qualitative agreement with the "laws". 

Next, let's dive deeper into the flow rate data for these three models. The model sketches, flow rate histogram and flow rate time series are shown in the figure below for `model_02`, `model_13` and `model_14`. In the sketches, the channels are represented by gray bars and the ratchet teeth are represented by black triangles. The numbers of triangles are the exact numbers of ratchet teeth in the actual models. The flow rate histograms for all the three cases exhibit single sharp peaks, with little spreading, suggesting that the flow configurations are stable and less susceptible to noise compared to models with straight channels. Indeed, in the flow rate time series plots, we can see that a single flow configuration can last for hours. 

![model 02 13 14 flow rate details](/assets/images/2023/05/model-02-13-14-flowrate-details.png)

The correlation between the number of ratchet teeth and bifurcation flow rate ratio is remarkable. In `model_13`, we have unequal number of ratchet teeth in the output channels, and they expectedly lead to a stable unequal bifuration.

<div class="note">
I only use one experiment of `model_02` data in the plot above. The other experiment shows unequal bifurcation, which I don't have an explanation for yet. See the <a href="https://docs.google.com/presentation/d/1j-PBB2hR4IiOxcsvatSWNzkbBw6STsOTA_C9Ib6zlqM/edit?usp=sharing">bifurcation summary slides</a> for more details.
</div>

##### 5. Angle matters

So far, all the bifurcations we have tested involve 3 channels, spaced evenly in the angular direction by 120 degrees. What happens if we introduce some asymmetry in the angles? We did some preliminary test and found that _angle matters_.

The two models that concern angle, `model_07` and `model_09`, are shown below. Both models have a full ratchet channel as input. In `model_07`, the two output channels B and C are of the same length. B turns 90 degrees to the left while C continues the input channel in a straight line. In `model_09`, the two output channels B and C are different in both length and angle. B is short but straight, while C is longer and with a 90-degree angle. According to the theory of Woodhouse and Dunkel, longer channels are more favorable. On the other hand, the 90-degree angle is no t favorable. The purpose of `model_09` is to create a competition between length and angle, to see the relative importance. 

![model 07 09](/assets/images/2023/05/model-07-09.png)

The FCP descriptions of the two experiments are summarized in the table below. 

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 08 February 2023 | model_07_A |     505.7 |     -0.157 |        0.647 |      4.5 |
| 10 February 2023 | model_09_A |     394.5 |     -0.114 |        0.256 |      2.5 |

The average flow rate is $F=450\pm 79$ $\mu$m$^2$/s. The continuity $C=-0.14\pm 0.03$ is acceptable. The polarization parameters are quite different between the two experiments. `model_07` exhibits strong polarization where $P=0.647$, while `model_09` exhibits weak polarization where $P=0.256$. 

Now we dive into the detailed flow rate data: the histograms and time series, as shown in the figure below. In `model_07`, the ratchet channel A is always the input, while B and C are output channel, as expected. Most output flow goes in channel C, which is the straight extension of the input channel. Channel B, which a 90-degree channel is introduced, barely gets any output flow. This unambiguous experiment suggests that turning an angle is unfavorable for the active nematics channel flows. In `model_09`, both angle and channel length are asymmetric, and we plan to test the competition between the two effects. The experiment shows: at the beginning, flow goes into the system from both A and B, and output in C, seemingly suggests that the length effect wins. However, as the system evolves, it finally enters a stable configuration, where flow goes in from A and C, and output in B. Why does flow come in C, the supposed output channel? We already postulate before that straight channels does not matter much compared to external factors. As such, a slightly tilted grid may contribute to the unexpected coming in flow from C.  

![model 07 09 flow rate details](/assets/images/2023/05/model-07-09-flowrate-details.png)

Due to the change of overall activity, the $\phi_B$-$\phi_C$ histograms look diffuse and are not very informative. We can improve the histogram by normalizing the flow rate using instantaneous maximal flow rate. The histograms for normalized flow rates $\hat\phi_B$-$\hat\phi_C$ are shown below. Again, `model_07` suggests that going straight (channel C) is more favorable than turning an angle (channel B). `model_09` confirms that straight channels does not have much effect on the flow configuration. The unexpected inward flow from channel C is probably a result from external factors, likely the tilted grid.

![model 07 09 normalized hist](/assets/images/2023/05/model-07-09-normalized-hist.png)

##### 6. `model_04`, another evidence that length does not matter

The design of `model_04` is shown in the following picture. It has a partial ratchet channel as input, and two output channels with different lengths. In principle, this model falls into the category of "ratchet input, different output lengths", which has been discussed already in Section 3. However, since we have many independent experiments for this model (all done by Claire), I summarize the results in a separate section. As we shall see, the extensive experiments support the postulate that straight channel length does not matter.

![model 04](/assets/images/2023/05/model-04.png)

The FCP descriptions of `model_04` are summarized in the table below.

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 22 January 2022  | model_04_L |     564.2 |      0.029 |        0.282 |     0.83 |
| 10 July 2022 E1  | model_04_L |     308.1 |     -0.022 |        0.331 |      0.8 |
| 10 July 2022 E2  | model_04_L |     382.1 |     -0.105 |         0.22 |     1.03 |
| 20 July 2022     | model_04_L |     374.7 |      -0.17 |        0.494 |     2.08 |
| 28 December 2022 | model_04_L |     232.9 |      0.064 |        0.356 |     0.67 |

The average flow rate is $F=372\pm 123$ $\mu$m$^2$/s. The continuity $C=-0.04\pm 0.10$ is acceptable. The polarization $P=0.34\pm 0.10$ is in between of typical highly polarized ($>0.6$) and highly equal split ($<0.3$). If we look closer at the $P$ for each individual experiment, we notice that they are diverse, ranging from 0.22 to 0.49. 

If a bifurcation system exhibits diverse behavior, noise is likely to be the dominating factor. In such case, the system is characterized by frequently changing flow configurations. Next, we shall dive into the detailed flow rate data to see if this is the case. 

The channel design sketch, flow rate histogram and flow rate time series are shown in the figure below. If I only see the flow rate histogram, I might convince myself that channel B is the favored output. However, after looking at the time series, I start to doubt this conlusion. The high frequency region in the histogram, where $\phi_C\approx 0$, is a result of the experiment where $t<3000$ s and the experiment where $t>9000$ s. In the [3000, 9000] regime, however, the flow configuration is obviously very different from the definite polarized state! 

![model 04 flow rate details](/assets/images/2023/05/model-04-flowrate-details.png)

From the coarse time series, I can identify **6** changes in the flow configuration, marked by reversals between channel the change of sign of the relative flow rate between B and C. See the zoom-in below where I mark those reversals. I will not be surprised if I find more such reversals in a more time-resolved plot.

![reversals](/assets/images/2023/05/reversals.png)

How can we understand the two drastically different flow behaviors in the same channel design? The answer has to be that the channel design is not the governing factor of the flow configurations. The flows, no matter steady polarized flows or oscillating flows, must result from outside factors or noise (respectively, if outside factor, e.g. the tiltedness of grid, is weak, the flow is noisy and reversals will result). In other words, length of straight channels does not matter (relative to noise and outside factors).

##### 7. What's left?

I did not expect to have gone this far, but it seems that most of the experimental results (with a few exceptions, e.g. part of `model_02` show polarized state) can be understood with the "laws" we postulated. The only experiment I have not discussed yet, is with `model_06`, which are all straight channels, but with one channel longer than the other two. The design is shown in the picture below. 

![model 06](/assets/images/2023/05/model-06.png)

There is only one day of experiment for this model, but to be consistent in format, I still show the FCP description in a table. 

| Date             | Model      | Flow rate | Continuity | Polarization | Duration |
|------------------|------------|-----------|------------|--------------|----------|
| 07 February 2023 | model_06_A |       624 |        0.1 |        0.385 |     4.17 |

The polarization parameter looks like a noisy configuration, but detailed flow rate data is again needed to verify. The channel design sketch, flow rate histogram and flow rate time series are shown in the figure below. Note that there are two independent experiments in this dataset, the first experiment being $t<6000$ s and the second being $t>6000$ s. I was once confused when I saw this strange histogram. But now, with plenty of analysis on straight channel data, I am confident to say that this is just another supporting evidence for the postulate that "length of straight channel does not matter". The very different flow behaviors between the two experiments suggest that the channel design is not the governing factor of the flow configuration. Instead, noise and outside factors take over. In the first experiment, inward flow comes exclusively in channel B, suggesting that the channel might be tilted. Also, the square base could lead to similar consequence, as we see many times in the experiments with `model_11`. In the second experiment, channel B is alternating between input and output, which is just a signature of a process dominated by noise.

![model 06 flow rate details](/assets/images/2023/05/model-06-flowrate-details.png)


#### Concluding remarks

With a few postulates derived from the first two sections, we are able to explain all the experimental observations so far. In short, we have identified three important factors that contribute to the result of a bifurcation. They are ratchet, outside factors and noise, importance from high to low. 

Interestingly, that active flow favors longer channel, the underlying assumption of active matter logic, is proved to be false in our experimental system (microtubule+kinesin, nanoscribe IPS resin boundary).