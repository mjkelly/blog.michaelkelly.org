---
title: 'Some handy jq tricks'
date: 2021-04-29T00:26:00.003-04:00
draft: false
url: /2021/04/some-handy-jq-tricks.html
---

I'm going to assume you already know what [jq](https://stedolan.github.io/jq/) is and you have some surface familiarity with its syntax. It's tremendously useful for ad-hoc interactions with JSON. I'm going to outline a few nifty tricks I've run into. They'll build on each other.

In all these examples, I'm going to assume you have an input file like this:

**datacenters.json**
```json
{
    "dcs": [
        {
            "datacenter": "lax1",
            "region": "west",
            "networks": ["10.4.0.0/16", "10.5.0.0/16"],
            "stage": "production"
        },
        {
            "datacenter": "lax2",
            "region": "west",
            "networks": ["10.6.0.0/16"],
            "stage": "planned"
        },
        {
            "datacenter": "iad1",
            "region": "east",
            "networks": ["10.0.0.0/16", "10.1.0.0/16"],
            "stage": "production"
        }
    ]
}
```

Outputting only some fields
---------------------------

Sometimes you want to output just some fields. '{ ... }' syntax works well for this, for example:

```sh
jq ".dcs[] | {d: .datacenter, r: .region}" < datacenters.json
```

You'll get this:

```json
{
 "d": "lax1",
 "r": "west"
}
{
 "d": "lax2",
 "r": "west"
}
{
 "d": "iad1",
 "r": "east"
}
```

This will iterate over an array of input and include "datacenter" and "region" from each element in the output structure. [Here's a jdplay example of this](https://jqplay.org/s/wKlKGnBGLY).

Outputting CSV and TSV
----------------------

Sometimes you don't want JSON as the output at all -- maybe you're trying to summarize a JSON data structure. In that case, you can use @csv and @tsv to generate comma-separated and tab-separated output.

Command:
```sh
jq -r ".dcs[] | [.datacenter, .region] | @csv" < datacenters.json 
```

Output:
```json
"lax1","west"
"lax2","west"
"iad1","east"
```

Command:
```sh
jq -r ".dcs[] | [.datacenter, .region] | @tsv" < datacenters.json 
```

Output:
```json
lax1 west
lax2 west
iad1 east
```

We use -r so the output isn't JSON-encoded strings. Here are examples using the same data as above: [Using @csv](https://jqplay.org/s/FBGwPoDOgo), and [using @tsv](https://jqplay.org/s/8J6APQ2re9)

Note that in these cases we don't use '{ ... }' to generate JSON dicts, but '\[ ... \]' to generate a list, since neither @csv nor @tsv are a key-value format.

Outputting several fields on one line
-------------------------------------

Like @tsv and @csv, but with total control over the output. You can use string interpolation, "(.field1)", to output more than on field on a line:

Command:
```sh
jq '.dcs[] | "\(.datacenter) is in \(.region)"' < datacenters.json
```

Output:
```json
"lax1 is in west"
"lax2 is in west"
"iad1 is in east"
```

[Here's an example](https://jqplay.org/s/n6epI3wo8H).

Diffs
-----

Say you have two large, complex JSON files to compare. You can use one of the strategies above to cut down on how much you're outputting, and to condense structures into one line if possible. This will help you get sensible diff output.

There are some other tricks as well.

### By sorting keys

`--sort-keys/-S` helps you compare JSON data with different sort order. For example, is this datacenter list any different than the one above?


**datacenters2.json**
```json
{
    "dcs": [
        {
            "datacenter": "lax1",
            "networks": ["10.4.0.0/16", "10.5.0.0/16"],
            "region": "west",
            "stage": "production"
        },
        {
            "datacenter": "lax2",
            "stage": "planned",
            "region": "west",
            "networks": ["10.6.0.0/16"]
        },
        {
            "datacenter": "iad1",
            "region": "east",
            "networks": ["10.0.0.0/16", "10.1.0.0/16"],
            "stage": "production"
        }
    ]
}
```

The next command shows that they contain the same values, even though the keys are in a different order. We also use [process substitution](https://tldp.org/LDP/abs/html/process-sub.html) here:

```sh
diff -u \
  <(jq --sort-keys . < datacenters.json) \
  <(jq --sort-keys . <datacenters2.json)
```

However, this will not correct for datacenters appearing in a different order, or items in "networks" being in a different order.

### By extracting representative lines

You can use any of the output strategies above for diffs as well. @tsv and @csv work particularly well because you can easily assemble a list of fields in each object you care about, then compare just those fields. You can sort those lines, so order changes don't trip up your diff.

Here's an example, using two files like our example file above:

```sh
diff -u \
  <(jq -r '.dcs[] | [.datacenter, .region, .stage] | @tsv' < dc1.json | sort) \
  <(jq -r '.dcs[] | [.datacenter, .region, .stage] | @tsv' < dc2.json | sort)
```

Here are example
[dc1.json](https://gist.github.com/mjkelly/919b1f824b86bf490c8d93953d72555b)
and
[dc2.json](https://gist.github.com/mjkelly/7b9238b5a3135c283bc791f9bd8476c0)
files.

This example summarizes each file, extracting key fields we care about, and keeping order consistent. Then, we compare the resulting summaries.

Try making dc1.json and dc2.json by starting with the example files above, then changing the order of each datacenter block. (E.g., move lax1 to the bottom of the list.) Try different modification to the order of the fields, and the entries, to see what it can detect.

The strength of this approach is that we generate line-oriented output that we can manipulate easily with other unix tools, rather than relying on jq to do all the heavy lifting.
