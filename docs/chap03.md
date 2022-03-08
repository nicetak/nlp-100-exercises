# Chapter 3: Regular Expression





## 20. Rea JSON documents
>Read the JSON documents and output the body of the article about the United Kingdom. Reuse the output in problems 21-29.


```r
data <- readLines(here("data/enwiki-country.json"))
article_UK <- grep("^\\{\"title\": \"United Kingdom\"", data, value = T)
lines_UK <- fromJSON(article_UK)$text %>% str_split("\\n") %>% unlist()

lines_UK[1:5]
```

```
## [1] "{{About-distinguish2|the country|[[Great Britain]], its largest island whose name is also loosely applied to the whole country}}"
## [2] "{{Redirect|UK|other uses of \"UK\"|UK (disambiguation)|other uses of \"United Kingdom\"|United Kingdom (disambiguation)}}"       
## [3] "{{pp-semi-indef}}"                                                                                                               
## [4] "{{pp-move-indef}}"                                                                                                               
## [5] "{{short description|Country in Western Europe}}"
```

## 21. Lines with category names
>Extract lines that define the categories of the article.


```r
lines_cat <- grep("\\[\\[Category:.*\\]\\]", lines_UK, value = T)
lines_cat %>%
  head()
```

```
## [1] "[[Category:United Kingdom| ]]"                          
## [2] "[[Category:British Islands]]"                           
## [3] "[[Category:Countries in Europe]]"                       
## [4] "[[Category:English-speaking countries and territories]]"
## [5] "[[Category:G7 nations]]"                                
## [6] "[[Category:Group of Eight nations]]"
```

## 22. Category names
>Extract the category names of the article.


```r
lines_cat %>%
  lapply(function(x) str_replace_all(x, "^\\[\\[Category:|\\| |\\]\\]$", "")) %>%
  unlist() %>%
  head()
```

```
## [1] "United Kingdom"                            
## [2] "British Islands"                           
## [3] "Countries in Europe"                       
## [4] "English-speaking countries and territories"
## [5] "G7 nations"                                
## [6] "Group of Eight nations"
```

## 23. Section structure
>Extract section names in the article with their levels. For example, the level of the section is 1 for the MediaWiki markup "== Section name ==".


```r
sections <- lines_UK %>%
  str_extract_all("==.*==") %>%
  unlist()

for(i in 1:6){
  s <- sections[i]
  level <- str_count(s, "=") / 2 - 1
  section <- str_replace_all(s, "\\s*={2,4}\\s*", "")
  print(paste0(level, " ", section))
}
```

```
## [1] "1 Etymology and terminology"
## [1] "1 History"
## [1] "2 Background"
## [1] "2 Treaty of Union"
## [1] "2 From the union with Ireland to the end of the First World War"
## [1] "2 Between the World Wars"
```

## 24. Media references
>Extract references to media files linked from the article.


```r
lines_UK %>%
  str_extract_all("\\[\\[File:.*?(\\||\\]\\])") %>%
  unlist() %>%
  str_replace_all("^\\[\\[File:|\\|$|\\]\\]$", "") %>%
  head()
```

```
## [1] "Royal Coat of Arms of the United Kingdom.svg"                                                       
## [2] "Royal Coat of Arms of the United Kingdom (Scotland).svg"                                            
## [3] "United States Navy Band - God Save the Queen.ogg"                                                   
## [4] "Europe-UK (orthographic projection).svg"                                                            
## [5] "Europe-UK.svg"                                                                                      
## [6] "United Kingdom (+overseas territories and crown dependencies) in the World (+Antarctica claims).svg"
```

## 25. Infobox
>Extract field names and their values in the Infobox “country”, and store them in a dictionary object.


```r
tmp <- article_UK %>%
  str_extract_all("\\{\\{Infobox country.*?(\\{\\{.*?\\}\\}.*?)*?\\}\\}") %>%
  unlist() %>%
  str_replace_all("^\\{\\{Infobox country\\\\n\\| |\\}\\}", "") %>%
  unlist() %>%
  str_split("\\\\n\\| ") %>%
  unlist() %>%
  str_replace_all(" += ", "===") %>%
  unlist()

infobox <- tibble(key = character(), value = character())

for(s in tmp){
  x <- str_split(s, "===") %>% unlist()
  infobox <- infobox %>% bind_rows(tibble(key = x[1], value = x[2]))
}

infobox
```

```
## # A tibble: 8 × 2
##   key                    value                                                  
##   <chr>                  <chr>                                                  
## 1 common_name            "United Kingdom"                                       
## 2 linking_name           "the United Kingdom<!--Note: \\\"the\\\" required here…
## 3 conventional_long_name "United Kingdom of Great Britain and Northern Ireland" 
## 4 image_flag             "Flag of the United Kingdom.svg"                       
## 5 alt_flag               "A flag featuring both cross and saltire in red, white…
## 6 other_symbol           "[[File:Royal Coat of Arms of the United Kingdom.svg|x…
## 7 other_symbol_type      "[[Royal coat of arms of the United Kingdom|Royal coat…
## 8 national_anthem        "\\\"[[God Save the Queen]]\\\"{{#tag:ref |There is no…
```


## 26. Remove emphasis markups
>In addition to the process of the problem 25, remove emphasis MediaWiki markups from the values.


```r
infobox <- infobox %>%
  mutate(value = str_replace_all(value, "''|'''", ""))

infobox
```

```
## # A tibble: 8 × 2
##   key                    value                                                  
##   <chr>                  <chr>                                                  
## 1 common_name            "United Kingdom"                                       
## 2 linking_name           "the United Kingdom<!--Note: \\\"the\\\" required here…
## 3 conventional_long_name "United Kingdom of Great Britain and Northern Ireland" 
## 4 image_flag             "Flag of the United Kingdom.svg"                       
## 5 alt_flag               "A flag featuring both cross and saltire in red, white…
## 6 other_symbol           "[[File:Royal Coat of Arms of the United Kingdom.svg|x…
## 7 other_symbol_type      "[[Royal coat of arms of the United Kingdom|Royal coat…
## 8 national_anthem        "\\\"[[God Save the Queen]]\\\"{{#tag:ref |There is no…
```


## 27. Remove internal links
>In addition to the process of the problem 26, remove internal links from the values.




## 28. Remove MediaWiki markups
>In addition to the process of the problem 27, remove MediaWiki markups from the values as much as you can, and obtain the basic information of the country in plain text format.

## 29. Country flag
>Obtain the URL of the country flag by using the analysis result of Infobox.


```r
file <- infobox$value[infobox$key == "image_flag"]
url <- "https://en.wikipedia.org/w/api.php"
query <- list(
  action = "query",
  format = "json",
  prop = "imageinfo",
  titles = paste0("File:", file),
  iiprop = "url"
)

res <- GET(url=url, query=query)
image_info <- res %>%
  content("text") %>%
  fromJSON()

url_image <- image_info$query$pages[[1]]$imageinfo$url
```

![Obtained image](https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg)














