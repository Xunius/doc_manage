# doc_manage

Some bash shell scripts helping managing documents and research references on local disk


## Overview

I'm trying to do some management work on my collection of research papers, current
model I'm using:

* Create a folder at `~/Papers`, everything happens inside this.
* Save all the PDF files or doc files in one sub-folder: `~/Papers/collection`.
* Create a number of sub-folders under `~/Papers`, using topic names as folder
names, e.g. `~/Papers/global_warming`.
* Create **relative symlinks** from the document files into topic subfolders, e.g.
`ln -sr ~/Papers/collection/file1.pdf ../global_warming/`. This way, a paper
can appear in multiple topic folder without taking up multiples of disk space,
and any changes (highlights, notes) made to it applies to all symlinks.



## Scripts


### 1. find_links.sh

Given an input document file, find all topic folder names by following symlinks
E.g.

```
./find_links.sh ~/Papers/collection/file1.pdf
```

outputs

```
global_warming
global_warming_too_fast
global_warming_too_fast_too_bad
```

### 2. find_orphans.sh

Scan through the collection folder and list all files with no symlinks, i.e.
papers you haven't assign any topics to.

E.g.

```
./find_orphans.sh
```


### 3. add_links.sh

Given an input document file and a topic name, search (case insensitively)
folders with name of the topic within the library folder (`~/Papers`). If none exists, ask to
create a new folder under the library folder. Then (ask to) copy
the file to the collection folder, and (ask to) create a symlink(s) from the
new location iside collection folder to all subfolders with name "topic".

Use this to add new paper to the collection and assign topic tags.


### 4. add_links_folder.sh


Call `add_links.sh` on each doc in a folder, using the folder name as tag.

Use this to batch-add a folder of new documents.


### 5. getBib.sh

Search string in a `.bib` file containing multiple entries, and return all
entries containing the search string.

E.g.

```
./getBib.sh 'Osborn2000' ./my_bib.bib
```

It will first call `grep -i 'Osborn2000' ./my_bib.bib` to get all matching line
numbers, and from each matching, look up and down to get the whole bib entry
(enclosed by `@article{` and `}`). After remoivng duplicates, it returns all
entries.


### 6. recoll_query.sh

This is me playing around with the [rofi launcher](https://github.com/DaveDavenport/rofi)
with the [recoll search engine](http://www.lesbonscomptes.com/recoll/).

After launching `./recoll_query.sh`, rofi pops up an input box for you to
type in the search string. After pressing enter, _recoll_ does a **full text**
search (according to your setup of indexing), and return returns via rofi
again. Select (by moving up/down) and hit enter on one or more than one entries,
PDFs (or docs or whatever) opens in external programs.

`config_oneliner`, `config_recoll`, `Arc-Dark.rasi`, `arthur_modified.rasi`
are the relevant rofi config files used in this. Typically you put them
in `~/.config/rofi/`.



## Notices

I learned quite some bash scripting when making these, and they certainly contain
some issues/bugs. If you found any please don't hesitate to fire up an issue.
And new ideas are welcome too.

When packing up the library folder (e.g. do a back up or transfer to another
machine), in order to preserve the relative symlinks, the easiest way is to tar up
the entire folder and unpack in the new location.



