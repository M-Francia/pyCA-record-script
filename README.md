# pyCA record script

This bash script demonstrates recording multiple sources for audio & video with a single command. It is intended to be used with the pyca capture agent by Lars Kiesow. Based in a script of Jan Koppe <jan.koppe@wwu.de>.

### Prerequisites

pyCA installed.

### How to use

In your pyCA config file, invoque the script through the command value, inside the [capture] section.
```command		= './recordscript.sh /home/ {{name}} {{time}}'
``` 

### About

This scripts was tested in a Debian 8.8.

## Author

* **Mario Francia Rius** - *@mfranciar*

## Acknowledgments

* Jan Koppe <jan.koppe@wwu.de>
* Lars Kiesow 
