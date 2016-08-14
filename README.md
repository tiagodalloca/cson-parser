# CSON <=> JSON
====

[Atom](http://atom.io/) plugin. Convert JSON to CSON, and vice versa.

![Demo](http://i.imgur.com/iXbypux.gif)

Just select the text to convert and select the convert to CSON/JSON command. In a JSON or CSON file, it converts the whole file.

This uses the [CSON](https://www.npmjs.com/package/cson) and [json-beautify](https://www.npmjs.com/package/json-beautify) npm package.

## Diffs from forked package

- Convertion based on grammar selection wasn't working - fixed
- json-beautify dependency used for better formatting
