# Frameworks för examensarbete
In this repo we have stored everything that is needed to run our experiment. 

## Repo Contents
**Serverfiles**: Contains the repository implementations, system_d services and nginx configurations. Also contains the serverManager script that is used to switch between frameworks, but can also be used over SSH from the client. 
**ClientFiles**: Contains the client script and Jmeter test configuration. 
## How to use?
Clone this repository and place it in ```/var/www```, resulting in ```/var/www/examensarb```.
Then launch the serverManager.sh script and run **5** to install all dependencies. Then run **6** to setup configuration for nginx & systemd services. Once that is done, it is possible to start and stop the frameworks using serverManager.sh.

```sh
sh ./zosh
################################
#                              #
#  ERMA testing tool           #
#                              #
################################


What test would you like to do?

## Tests ##
1. Express
2. ASP.NET
3. Flask

## Functions ##
4. Kill all
5. Install dependencies
6. Setup konfigurations
```
