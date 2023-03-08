---
date: 2023-03-08
---

### Flow rate normalization of 05_july_2022 data

We notice that the rescaled flow rate histogram I made look quite different from the ones shown in Claire's thesis. I did an investigation on this matter and found it was cause by a **data selection**, which I shall explain more. Below is a comparison between the two histograms.

![picture 1](/assets/images/2023/03/compare-hist.png)  

They indeed look very different, not only because of the bin size, but also the overall shape. I first notice that the axes are different: one is $\phi_C$-$\phi_A$, while the other is $\phi_A$-$\phi_C$. Let transform the second one.

![picture 2](/assets/images/2023/03/compare-hist-transformed.png)  

Already look more similar, but in the read circle, some data is missing. So I went back to my code and found the following line:

```python
# only use flow rate data where the normalizer > 100
flowrate = flowrate.loc[flowrate.normalizer>100]
```

If I remove this line, the resulting histograms are the following, the left being real flow rate and the right being the normalized flow rate.

![picture 3](/assets/images/2023/03/disable-flowrate-selection.png)  

It is interesting to look at larger bin size:

![picture 4](/assets/images/2023/03/bigger-bin-size.png)  
