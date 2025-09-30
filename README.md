![UMass Lowell Logo - Dark](/assets/uml_logo.png)

Computer Science Advising Page - Miner School of Computer and Information
Sciences at University of Massachusetts Lowell
=

This website is intended as a guide for Computer Science students at UMass
Lowell. It provides students with information regarding the various degree
pathways and options available to Computer Science majors, dual majors, and
minors. It also includes resources for determining academic standing as well as
graduation eligibility. It is important to note however, that this is **NOT**
an official UMass Lowell website but is instead hosted and maintained by the
Miner School at UMass Lowell. The information on official UMass Lowell
(www.uml.edu) websites takes precedence in the event that there is a conflict
with the corresponding information on this website.

## Build Instructions

This website is written primarily in Markdown in order to maintain readability
of code. It is for this reason that all webpages are required to be "built"
using the Makefile located in the main directory. Any changes in the `md/`
directory only require a `make build` while changes to any assets, stylesheets,
or template files **require** a `make rebuild`. The `website/` directory is the
output location for the Makefile.

## Markdown

Using a python script, the build procedure now has a "pre-processing" step.
Because this is an advising site for a university, there are many references to
available courses. While writing Markdown, the developer can simply write a
university course as `\SUBJ.xxxx` and the python script will automatically
convert the text into a hyperlink, pointing back to the course as it is listed
on the official university catalog. For example: 
```
=>    \COMP.1010

=>    [COMP.1010](https://www.uml.edu/catalog/courses/COMP/1010) {target="_blank"}
```

## External Tools

[Pandoc](https://pandoc.org/) is used to convert the Markdown files to HTML.
<br>[Rsync]
(https://linuxize.com/post/how-to-use-rsync-for-local-and-remote-data-transfer-and-synchronization/)
is used within the Makefile to copy directory structures. It comes
automatically installed on most Linux distributions. <br>[Makefile]
(https://www.gnu.org/software/make/manual/make.html) is used with Pandoc to
systematically target and convert the webpages to HTML format. 