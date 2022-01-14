---
layout: post
title: "Playing Evil Wordle With Unix"
date: 2022-01-14 13:48:20 -0800
categories:
- Unix
excerpt_separator: <!-- more -->
---

It seems that nowadays everyone is playing [Wordle](https://www.powerlanguage.co.uk/wordle/). And for good reason. It is a lot of fun! There is an evil variant, [Evil Wordle](https://swag.github.io/evil-wordle/) that is, well, evil:

> There's no word set by default. Every time you guess, I look at all possible 5-letter words that would fit all your guesses, and choose the match pattern that results in the most possible words. My goal is to maximize the amount of guesses it takes to find the word.

Let's play with unix tools at our disposal. To be on the same playing field, I took a peek at the source in the browser, and downloaded the list of words that are part of the game dictionary:

<!-- more -->

```
$ head evil_wordle_words.txt
aahed
aalii
aargh
aaron
abaca
abaci
aback
abada
abaff
abaft

$ wc -l evil_wordle_words.txt
   15915 evil_wordle_words.txt
```

To start the game, I need to pick a word. Might as well get the word that will uses the most frequent letters:

```
$ grep -o . evil_wordle_words.txt | sort | uniq -c | sort
 139 q
 361 x
 376 j
 474 z
 878 v
1171 w
1237 f
1741 k
1969 g
2089 b
2284 h
2299 p
2494 m
2520 y
2744 c
2811 d
3361 u
4043 n
4189 t
4246 l
5066 i
5143 r
5219 o
6536 s
7799 e
8391 a
```

The most common letters are `a`, `e`, `s`, `o` and `r`. Let's find words with those letters:

```
$ cat evil_wordle_words.txt | \
  egrep 'a' \|
  egrep 'e' \|
  egrep 's' \|
  egrep 'o' \|
  egrep 'r'
arose
oreas
seora
```

Let's use `arose` as our starting word:

![Evil Wordle - First Iteration](/assets/images/evil_wordle_1.png)

With that information, let's discard some words:

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aor]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '...[^s][^e]' |\
  wc -l
      701
```

- I am using `egrep` to use extended regular expression.
- `-v` or `--invert-match` finds words that don't have any of the characters `a`, `o` or `r`
- `'...[^s][^e]'` finds words with any character in the first three positions, any character except `s` in the fourth, and so on.

We are still left with 701 possible words. so we pick one at random:

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aor]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '...[^s][^e]' |\
  shuf | head -n1
fezes
```

![Evil Wordle - Second Iteration](/assets/images/evil_wordle_2.png)

Lets narrow down some more:

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aorfz]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '[^e][^e][^e]es' |\
  wc -l
      150
```

Note the `'[^e][^e][^e]es'` dictates that while the words ends with `es`, `e` can't be any other character.

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aorfz]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '[^e][^e][^e]es' |\
  shuf | head -n1
dives
```

![Evil Wordle - Third Iteration](/assets/images/evil_wordle_3.png)

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aorfzdv]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '[^e]i[^e]es' |\
  shuf | head -n1
kibes
```

![Evil Wordle - Fourth Iteration](/assets/images/evil_wordle_4.png)

```
$ cat evil_wordle_words.txt |\
  egrep -v '[aorfzdvkb]' |\
  egrep 's' |\
  egrep 'e' |\
  egrep '[^e]i[^e]es' |\
  shuf | head -n1
nixes
```

On and on until we beat the game:

![Evil Wordle - Last Iteration](/assets/images/evil_wordle_5.png)

## Conclusion

Brute-forcing a game is not everyone's cup of tea, but it seemed appropriate for an evil one :).

Along the way, I re-learned some regular expressions. I am sure that I could write the solution in a more efficient manner, with less `grep` invocations, but I will leave that for another time.
