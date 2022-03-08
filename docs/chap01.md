# Chapter 1: Warm-up



## 00. Reversed string

```r
stringi::stri_reverse("stressed")
```

```
## [1] "desserts"
```
## 01. "schooled"

```r
str_split("schhooled", "") %>%
  unlist() %>%
  .[c(TRUE, FALSE)]
```

```
## [1] "s" "h" "o" "l" "d"
```

## 02. "shoe" + "cold" = "schooled"

```r
c(unlist(str_split("shoe", "")), unlist(str_split("cold", ""))) %>%
  .[c(1, 5, 2, 6, 3, 7, 4, 8)] %>%
  paste0(collapse = "")
```

```
## [1] "schooled"
```

## 03. Pi

```r
s <- "Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics"

s %>%
  str_replace_all(",|\\.", "") %>%
  str_split(" ") %>%
  unlist() %>%
  str_length()
```

```
##  [1] 3 1 4 1 5 9 2 6 5 3 5 8 9 7 9
```

## 04. Atomic symbols

```r
s <- "Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can"

indices <- c(1, 5, 6, 7, 8, 9, 15, 16, 19)

ss <- s %>%
  str_split(" ") %>%
  unlist()

map(1:length(ss), function(i){
  setNames(i, str_sub(ss[i], 1, if_else(i %in% indices, 1, 2)))
}) %>%
  unlist()
```

```
##  H He Li Be  B  C  N  O  F Ne Na Mi Al Si  P  S Cl Ar  K Ca 
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
```

## 05. n-gram

```r
n_gram_word <- function(s, n = 2){
  str_split(s, " ") %>% 
    unlist() %>%
    embed(n) %>%
    .[, n:1] %>%
    asplit(1)
}

n_gram_letter <- function(s, n = 2){
  str_split(s, "") %>% 
    unlist() %>%
    embed(n) %>%
    .[, n:1] %>%
    apply(1, paste, collapse = "")
}


s <- "I am an NLPer"
n_gram_word(s)
```

```
## [[1]]
## [1] "I"  "am"
## 
## [[2]]
## [1] "am" "an"
## 
## [[3]]
## [1] "an"    "NLPer"
```

```r
n_gram_letter(s)
```

```
##  [1] "I " " a" "am" "m " " a" "an" "n " " N" "NL" "LP" "Pe" "er"
```

## 06. Set

```r
x <- n_gram_letter("paraparaparadise")
y <- n_gram_letter("paragraph")

union(x, y)
```

```
##  [1] "pa" "ar" "ra" "ap" "ad" "di" "is" "se" "ag" "gr" "ph"
```

```r
intersect(x, y)
```

```
## [1] "pa" "ar" "ra" "ap"
```

```r
setdiff(x, y)
```

```
## [1] "ad" "di" "is" "se"
```

```r
"se" %in% x
```

```
## [1] TRUE
```

```r
"se" %in% y
```

```
## [1] FALSE
```

## 07. Template-based sentence generation

```r
template_sentence <- function(x, y, z){
  sprintf("%s is %s at %s", y, x, z)
}

template_sentence(12, "temperature", 22.4)
```

```
## [1] "temperature is 12 at 22.4"
```

## 08. Cipher text

```r
asc <- function(x) { strtoi(charToRaw(x), 16L) }
chr <- function(n) { rawToChar(as.raw(n)) }
cipher <- function(s){
  s %>%
    str_split("") %>%
    unlist() %>%
    map(function(l){
      num_l <- asc(l)
      if_else(num_l %in% asc("a"):asc("z"), chr(219 - num_l), l)
    }) %>%
    unlist() %>%
    paste(collapse = "")
}

s <- "The quick brown fox jumps over the lazy dog."

paste0("Plain text: ", s)
```

```
## [1] "Plain text: The quick brown fox jumps over the lazy dog."
```

```r
paste0("Cipher text: ", cipher(s))
```

```
## [1] "Cipher text: Tsv jfrxp yildm ulc qfnkh levi gsv ozab wlt."
```

```r
paste0("Decrypted text: ", cipher(cipher(s)))
```

```
## [1] "Decrypted text: The quick brown fox jumps over the lazy dog."
```

## 09. Typoglycemia

```r
word_mixed <- function(w){
  len_w <- str_length(w)
  if(len_w > 4){
    ls <- w %>% str_split("") %>% unlist()
    c(ls[1], sample(ls[2:(len_w-1)], size = len_w-2, replace = FALSE), ls[len_w]) %>%
      paste(collapse = "")
  } else {
    return(w)
  }
}

typoglycemia <- function(s){
  s %>% str_split(" ") %>% unlist() %>%
    lapply(word_mixed) %>%
    unlist() %>%
    paste(collapse = " ")
}

s <- "I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind ."

typoglycemia(s)
```

```
## [1] "I cduno'lt bleevie that I colud alltuacy untdnesard what I was raidneg : the panmnheeol power of the hmuan mind ."
```
























