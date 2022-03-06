# Chapter 2: UNIX Commands



## 10. Line count

```r
length(lines)
```

```
## [1] 2780
```

```bash
wc ../data/popular-names.txt
```

```
##  2780 11120 55026 ../data/popular-names.txt
```

## 11. Replace tabs into spaces

```r
lines %>%
  str_replace_all("\t", " ") %>%
  head(3)
```

```
## [1] "Mary F 7065 1880" "Anna F 2604 1880" "Emma F 2003 1880"
```

```bash
cat ../data/popular-names.txt | tr "\t" " " | head -3
```

```
## Mary F 7065 1880
## Anna F 2604 1880
## Emma F 2003 1880
```

## 12. col1.txt from the first column, col2.txt from the second column

```r
data$name %>%
  paste(collapse = "\n") %>%
  write(here("result/col1.txt"))

data$gender %>%
  paste(collapse = "\n") %>%
  write(here("result/col2.txt"))
```


```bash
cut -f 1 ../data/popular-names.txt > ../result/col1_shell.txt
cut -f 2 ../data/popular-names.txt > ../result/col2_shell.txt
```


```bash
diff ../result/col1.txt ../result/col1_shell.txt
diff ../result/col2.txt ../result/col2_shell.txt
# NO differences detected
```

## 13. Merging col1.txt and col2.txt

```r
col1 <- readLines(here("result/col1.txt"))
col2 <- readLines(here("result/col2.txt"))

paste(col1, col2, sep = "\t") %>% head(3)
```

```
## [1] "Mary\tF" "Anna\tF" "Emma\tF"
```

```bash
paste -d "\t" ../result/col1.txt ../result/col2.txt | head -3
```

```
## Mary	F
## Anna	F
## Emma	F
```

## 14. First N lines

```r
head(lines, 3)
```

```
## [1] "Mary\tF\t7065\t1880" "Anna\tF\t2604\t1880" "Emma\tF\t2003\t1880"
```

```bash
head -3 ../data/popular-names.txt
```

```
## Mary	F	7065	1880
## Anna	F	2604	1880
## Emma	F	2003	1880
```

## 15. Last N lines

```r
tail(lines, 3)
```

```
## [1] "Lucas\tM\t12585\t2018" "Mason\tM\t12435\t2018" "Logan\tM\t12352\t2018"
```

```bash
tail -3 ../data/popular-names.txt
```

```
## Lucas	M	12585	2018
## Mason	M	12435	2018
## Logan	M	12352	2018
```

## 16. Split a file into N pieces

```r
split_lines <- function(lines, n){
  split(lines, sort(rep_len(1:n, length(lines)))) %>%
    setNames(NULL)
}

split_lines(lines, 3) %>%
  lapply(head, 3)
```

```
## [[1]]
## [1] "Mary\tF\t7065\t1880" "Anna\tF\t2604\t1880" "Emma\tF\t2003\t1880"
## 
## [[2]]
## [1] "Virginia\tF\t16162\t1926" "Mildred\tF\t13551\t1926" 
## [3] "Frances\tF\t13355\t1926" 
## 
## [[3]]
## [1] "John\tM\t43181\t1972"   "Robert\tM\t43037\t1972" "Jason\tM\t37446\t1972"
```


```bash
split -l 1000 ../data/popular-names.txt ../result/popular-names-
```


## 17. Distinct strings in the first column

```r
data$name %>% levels() %>% sort() %>% head(5)
```

```
## [1] "Abigail"   "Aiden"     "Alexander" "Alexis"    "Alice"
```

```bash
cut -f 1 ../data/popular-names.txt | sort -s | uniq | head -5
```

```
## Abigail
## Aiden
## Alexander
## Alexis
## Alice
```
## 18. Sort lines in descending order of the third column


```r
data %>%
  arrange(desc(num)) %>%
  head(5)
```

```
## # A tibble: 5 × 4
##   name    gender   num  year
##   <fct>   <fct>  <dbl> <dbl>
## 1 Linda   F      99689  1947
## 2 Linda   F      96211  1948
## 3 James   M      94757  1947
## 4 Michael M      92704  1957
## 5 Robert  M      91640  1947
```

```bash
sort -n -r -k 3 ../data/popular-names.txt | head -5
```

```
## Linda	F	99689	1947
## Linda	F	96211	1948
## James	M	94757	1947
## Michael	M	92704	1957
## Robert	M	91640	1947
```

## 19. Frequency of a string in the first column in descending order

```r
data %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(5)
```

```
## # A tibble: 5 × 2
## # Groups:   name [5]
##   name        n
##   <fct>   <int>
## 1 James     118
## 2 William   111
## 3 John      108
## 4 Robert    108
## 5 Mary       92
```


```bash
cut -f 1 ../data/popular-names.txt | sort | uniq -c | sort -n -r -k 1 | head -5
```

```
##     118 James
##     111 William
##     108 Robert
##     108 John
##      92 Mary
```

