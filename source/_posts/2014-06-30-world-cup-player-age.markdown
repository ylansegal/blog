---
layout: post
title: "World Cup Player Age, Unix Style"
date: 2014-06-30 08:41
comments: true
categories:
- unix
---

I love watching the World Cup: It's more soccer than you could hope for, mixed with national rivalries. What could be better. Now that I am older than most of the players, it dawned on me the intense pressure that they are under, to perform for their country and a question came to me: Just how old are this kids? Let's find out.

## Source Data

With a quick google search, I came up with what seemed like a good [source of data][data_source] for the task at hand. I simply copy and pasted the data from my browser into a text editor to get [a file][gist_source_data] that looks like this:

```
Alan PULIDO	Mexico	08/03/1991	5	4
Adam TAGGART	Australia	02/06/1993	4	3
Reza GHOOCHANNEJAD	Iran	20/09/1987	13	9
NEYMAR	Brazil	05/02/1992	48	31
Didier DROGBA	Ivory Coast	11/03/1978	100	61
David VILLA	Spain	03/12/1981	95	56
Abel HERNANDEZ	Uruguay	08/08/1990	12	7
Javier HERNANDEZ	Mexico	01/06/1988	61	35
Islam SLIMANI	Algeria	18/06/1988	19	10
Shinji OKAZAKI	Japan	16/04/1986	75	38
...
```

## Cutting and Slicing

Using the power of unix pipes, we can easily extract the data we want from the data. Let's start by getting all birthdates:

``` bash
$ cat players.txt | cut -f3
08/03/1991
02/06/1993
20/09/1987
05/02/1992
11/03/1978
03/12/1981
08/08/1990
01/06/1988
18/06/1988
16/04/1986
...
```

As the man pages say: `cut` _cut out selected portions of each line of a file_. In our case, we want the 3rd field in the database.

Now, we can cut again to get the birth year of each player:

``` bash
$ cat players.txt | cut -f3 | cut -d '/' -f3
1991
1993
1987
1992
1978
1981
1990
1988
1988
1986
...
```

In this case, we are cutting again, this time using `/` as a delimiter. Now we have a list of all the players' birth years.

### Histogram

I searched around for some quick utilities that would generate a histogram and the most promising seemed a python utility called [data hacks][data_hacks]. Unfortunetly, I did not install for me and I didn't have the inclination to mess with my python installation. I did however, find something similar to what I needed in a blog post about [visualizing your shell history][shell_history]. After adapting it a bit to my purposes, I created a small bash function that now lives in my profile:

``` bash
function histogram() {
  sort | uniq -c| sort -rn | awk '!max{max=$1;}{r="";i=s=60*$1/max;while(i-->0)r=r"#";printf "%15s %5d %s %s",$2,$1,r,"\n";}'
}
```

This function leverages `awk` very heavily. `awk` is a _pattern-directed scanning and processing language_. I am not very familiar with it, but after seeing how powerful it is, I am definitely want to get acquainted with it.

With this function, we can now get a full histogram:

``` bash
$ cat players.txt | cut -f3 | cut -d '/' -f3 | histogram | sort
   1971     1 #
   1976     1 #
   1977     2 ##
   1978     5 ####
   1979    15 ############
   1980    19 ###############
   1981    32 #########################
   1982    33 ##########################
   1983    46 ####################################
   1984    58 ##############################################
   1985    66 ####################################################
   1986    77 ############################################################
   1987    70 #######################################################
   1988    65 ###################################################
   1989    62 #################################################
   1990    63 ##################################################
   1991    38 ##############################
   1992    47 #####################################
   1993    22 ##################
   1994     7 ######
   1995     6 #####
   1996     1 #
```

Notice that the final sort is needed, because `histogram` returns the values ordered by the number of times it appeared in the data, but since we are talking about birth years, I believe the graph is more telling if it is in ascending order.

## Other Findings

With all that in place, it is relatively easy to make a histogram of other data. I remember Malcom Gladwell's theory in his book [Outliers][outliers] about how most professional hockey players are born in the first part of the year, because of how the developmental leagues work in Canada. With a database of 735 professional soccer players, chosen to be then best 23 of each country, I would expect 61.25 players to be born on each month. Let's find out how many really are:


``` bash
$ cat players.txt | cut -f3 | cut -d '/' -f2 | histogram | sort
   01    73 #########################################################
   02    77 ############################################################
   03    66 ####################################################
   04    63 ##################################################
   05    73 #########################################################
   06    59 ##############################################
   07    57 #############################################
   08    57 #############################################
   09    66 ####################################################
   10    46 ####################################
   11    48 ######################################
   12    51 ########################################
```

Notice that to arrive at this graph, the only thing we changed was the field we extracted from the data, in this case the month of the birthday. Is there a trend here? It does suggest that players born in the first part of the year are favored, but I do not know if it's statistically significant.

## Conclusion

Quick and dirty data analysis on the command line is pretty easy if you know a bit of unix and some awk!

[source_data]: http://worldcup2014-mjozwiak.rhcloud.com/
[gist_source_data]: https://gist.github.com/ylansegal/2d5a0ff0c87653b06c9f
[data_hacks]: https://github.com/bitly/data_hacks
[shell_history]: http://www.smallmeans.com/notes/shell-history/
[outliers]: https://en.wikipedia.org/wiki/Outliers_(book)
