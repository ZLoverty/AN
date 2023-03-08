---
date: 2023-03-08
---

### Flow rate selection

We normalize the flow rate using the **smooth max** method. This allow us to superpose data from different experiment (potentially different nominal flow rate) in the same histogram. However, because of the normalization, one important information is hiden -- the magnitude of flow rate. Ideally, we want to display this information on the normalized histogram, by indicating small and large with different colors. However, I don't have a solid idea how to implement it (maybe a scatter plot, but just too many points). So currently, we continue to do single colormap histogram.

![picture 1](/assets/images/2023/03/colored-hist-sketch.png)  

I have an intuition that when flow rate is higher, the polarized state is more stable. Therefore, my first try of flow rate selection is to set a **threshold** to the flow rate data that are used for histogram. The flow rate below this threshold will not be considered. 

##### Do we see an impact?

Yes, but not making the polarized state stand out more. Below is the histogram for fully symmetric straight channel.

![picture 2](/assets/images/2023/03/different-flowrate-selection.png)  
