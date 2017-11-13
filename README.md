# jnReddit

This is a simple module specifically for grabbing Reddit posts from a Subreddit.

## Getting Started

You can download this module from here, save it to your modules directory, and import the module 
** OR **
You can install it from PSGallery

### Prerequisites

```
PowerShell 5.0 is required for this module.
```

### Installing

*** Option 1 ***

Github


```
Download the jnReddit subdirectory and place it in your modules directory
Import-module .\jnReddit\jnReddit.psm1
```


*** Option 2 ***

PSGallery


```
Install-Package "jnReddit" -Force
```


## Built With

* [PlatyPS](https://github.com/PowerShell/platyPS) - Used to generate doco for this project.
* [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) - Analysis for best-practices.


## Authors

* **Jake Nelson** - *Initial work* - [JakeNelson](http://jake-nelson.com)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments & Notes

* There's already an advanced Reddit module called [PSRAW](https://github.com/markekraus/PSRAW) 
If you require any advanced functionality that my module doesn't offer, use PSRAW instead.

* My module was developed quickly and with simplicity in mind, it uses mostly web requests to the Reddit GET API which is subject to change.
