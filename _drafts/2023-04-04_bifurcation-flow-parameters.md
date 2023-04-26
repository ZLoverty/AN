---
date: 2023-04-04
title: Bifurcation flow parameters
---

### Bifurcation flow parameters

Average flow rate, continuity and polarization are the most important parameters we are concerned about a bifurcation flow. The average flow rate gives a measure of the experimental system activity, and is the key to ensure reproducibility of data. Continuity is one of the ways to identify problems in experiment (e.g. out of focus) and analysis (e.g. wrong mask, different crop length).  Polarization is the theoretical predication we want to check in experiment. 

In this note, we describe the definition and interpretation of each parameter. All of these parameters can be derived from the flow rate data we measured using PIV (described [here](2022-12-13_batch-bifurcation-analysis.md)). Typically, flow rate data comprise 4 columns "A", "B", "C" and "t". 

![picture 1](/assets/images/2023/04/flow-rate-data.png)  

##### Normalization

Before the parameters, let's discuss the normalization of the flow rate data. Why do we need to normalize the flow rate data? There are 3 main reasons:

- to compare experimental data with the theory, which states that {-1, 0, 1} are the most probable flow rates in each channel;
- long-time fluctuations in flow rate is the nature of active nematics, as evidenced in the plot below:

![picture 2](/assets/images/2023/04/flow-rate-fluctuation.png)  

- to combine experiments from different experiments in the same histogram. This point is quite similar to the previous one, but on an even longer time scale and involves the subtle variabilities in the samples. The flow rate data plotted below contain two samples prepared in exactly the same way on the same day. (0-2: sample 1, 3-6: sample 2)

![picture 3](/assets/images/2023/04/sample-variation.png)  

Due to these considerations, we want to normalize the data. The idea is to make the flow rates fall in the range (-1, 1), and to make samples with different overall activity more comparable. 

We have tried several different implementations for the normalization. At the moment of writing, I'm using a constant to rescale all the (3) flow rates in one video. For example, the flow rate data above will be normalized by the normalizer (indicated by the red line). It is almost a constant within each sample (e.g. video 0,1,2). As we change to a different sample with lower activity, the normalizer takes a smaller value. At the end of this experiment, the second sample slows down, leading to a even lower value. 

![picture 4](/assets/images/2023/04/flow-rate-with-normalizer.png)  

The following python code defines the normalizer in a more quantitative manner as shown below. The large sigma (3000) ensures that the normalizer is a constant. 

```python
flowrate["normalizer"] = \
    gaussian_filter1d(flowrate[["A", "B", "C"]].abs().max(axis=1), \
    sigma=3000, axis=0)
```

##### Average flow rate

The average flow rate gives a measure of how active a system is. Such information is already in the normalizer, so we are just averaging the normalizer over time:

```python
average_flow_rate = flowrate["normalizer"].mean()
```

##### Continuity parameter $\in [-1, 1]$

This parameter checks if the flow rate adds up to 0, which is require by the continuity at the junction. The summation will be rescaled by the average flow rate.

```python
continuity_parameter = (flowrate[["A", "B", "C"]].sum(axis=1) / average_flow_rate
```

##### Polarization parameter $\in [0,1]$

How different are the two smaller flow rates, compared to the normalizer? For totally polarized flow state, this ratio is 1. For evenly distributed flow state, this value is 0. 

```python
a = flowrate[["A", "B", "C"]].abs().values
ind = np.argsort(a, axis=1) # sort values in columns
b = np.take_along_axis(a, ind, axis=1) # sorted array
polarization_parameter = (b[:, 1] - b[:, 0]).mean() / average_flow_rate
```

These parameters will be calculated and saved in the shared spreadsheet [List of experiments of Bifurcations](https://docs.google.com/spreadsheets/d/1KEaa-VgyC1NET2K7HZfIa7Qk1tyNr5EN32Wwv2pCiNc/edit#gid=0).

**2023-04-26 edit: polarization from smoothed flow rate**

The polarization parameter does not reflect the polarization state very well. For example, the flow rate data of Feb 28, 2023 consist of two samples. Sample 1 shows equal split in B and C, and sample 2 shows a larger flow rate in C and smaller in B. This observation should be reflected in the polarization parameter, if we compute the parameter for the flow rate corresponding to the two samples. 

With the current method, which computes the difference between the two smaller flow rate at each instance, we get 0.298 for sample 1 and 0.353 for sample 2. They are close and does not reflect the difference between the two samples well. 

By smoothing the flow rate, the difference between the polarization parameters gets larger. For example, we smooth the flow rates with Gaussian filter ($\sigma=25$ s), the polarization parameters become 0.194 and 0.331. 

Therefore, we modify the definition of the polarization parameter, by introducing a Gaussian smoothing to the flow rate data. In the code, the following line is added:

```python
flowrate[["A", "B", "C"]] = gaussian_filter1d(flowrate[["A", "B", "C"]], sigma=50, axis=0)
```

