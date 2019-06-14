# nodeLocalization
This project seeks to localize nodes in a Wireless Network using only range measurements and a small subset of referece locations.
* Reference nodes are called Anchors and have known locations.
* We call non-anchor nodes, Unknowns.
* Nodes lie in **n-dimensional Euclidean space**. While we usually have n = 2 or n = 3 in current applications; our implementation, with exception of plot functions, is able to deal with any possible number of dimensions.
* We utilize the minimum number of anchors, which is n + 1.
* **Anchors and Unknows may lie arbitrarily**, i.e. there is no assumption on how the anchors in the network are placed.

## Requirements for utilization
* A running Matlab environment. Tested with Matlab R2018b - academic use.
* The Parallel Computing Toolbox is called when doing RMSE simulation via batch processing. But, it is not required to run the standard single network case.

## How to use


## Credits
This implementation was coded by myself, Pedro Paulo Ventura Tecchio, while pursuing a Ph.D. degree at University of Pennsylvania. Related paper:

```latex
@inproceedings{tecchio2019NodeLocalization,
  author={Tecchio, Pedro Paulo Ventura and Atanasov, Nikolay and Shahrampour, Shahin and Pappas, George J.},
  booktitle={2019 American Control Conference (ACC2019)},
  title={N-Dimensional Distributed Network Localization With Noisy Range Measurements and Arbitrary Anchor Placement},
  year={2019}
}
```

## License
This project is distributed under GNU GPLv3 license.

