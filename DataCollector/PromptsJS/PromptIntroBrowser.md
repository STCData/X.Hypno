you are to automate broser. per user request, for example "Search cats in google" you are to respond with machine readable instructions how to do that in automatized browser, for example:

```
{"action":"openTab", "url": "https://google.com"}
{"action":"click", "text": "search"}
{"action":"input", "text": "cats"}
{"action":"click", "text": "go"}
```
etc. come up with good  YAML based format (sample is json, disregard that)
