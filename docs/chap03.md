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
lines_cat
```

```
##  [1] "[[Category:United Kingdom| ]]"                                
##  [2] "[[Category:British Islands]]"                                 
##  [3] "[[Category:Countries in Europe]]"                             
##  [4] "[[Category:English-speaking countries and territories]]"      
##  [5] "[[Category:G7 nations]]"                                      
##  [6] "[[Category:Group of Eight nations]]"                          
##  [7] "[[Category:G20 nations]]"                                     
##  [8] "[[Category:Island countries]]"                                
##  [9] "[[Category:Northern European countries]]"                     
## [10] "[[Category:Former member states of the European Union]]"      
## [11] "[[Category:Member states of NATO]]"                           
## [12] "[[Category:Member states of the Commonwealth of Nations]]"    
## [13] "[[Category:Member states of the Council of Europe]]"          
## [14] "[[Category:Member states of the Union for the Mediterranean]]"
## [15] "[[Category:Member states of the United Nations]]"             
## [16] "[[Category:Priority articles for attention after Brexit]]"    
## [17] "[[Category:Western European countries]]"
```

## 22. Category names
>Extract the category names of the article.


```r
lines_cat %>%
  lapply(function(x) str_replace_all(x, "^\\[\\[Category:|\\| |\\]\\]$", "")) %>%
  unlist()
```

```
##  [1] "United Kingdom"                                  
##  [2] "British Islands"                                 
##  [3] "Countries in Europe"                             
##  [4] "English-speaking countries and territories"      
##  [5] "G7 nations"                                      
##  [6] "Group of Eight nations"                          
##  [7] "G20 nations"                                     
##  [8] "Island countries"                                
##  [9] "Northern European countries"                     
## [10] "Former member states of the European Union"      
## [11] "Member states of NATO"                           
## [12] "Member states of the Commonwealth of Nations"    
## [13] "Member states of the Council of Europe"          
## [14] "Member states of the Union for the Mediterranean"
## [15] "Member states of the United Nations"             
## [16] "Priority articles for attention after Brexit"    
## [17] "Western European countries"
```

## 23. Section structure
>Extract section names in the article with their levels. For example, the level of the section is 1 for the MediaWiki markup "== Section name ==".


```r
sections <- lines_UK %>%
  str_extract_all("==.*==") %>%
  unlist()

for(s in sections){
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
## [1] "2 Since the Second World War"
## [1] "1 Geography"
## [1] "2 Climate"
## [1] "2 Administrative divisions"
## [1] "1 Dependencies"
## [1] "1 Politics"
## [1] "2 Government"
## [1] "2 Devolved administrations"
## [1] "2 Law and criminal justice"
## [1] "2 Foreign relations"
## [1] "2 Military"
## [1] "1 Economy"
## [1] "2 Overview"
## [1] "2 Science and technology"
## [1] "2 Transport"
## [1] "2 Energy"
## [1] "2 Water supply and sanitation"
## [1] "1 Demographics"
## [1] "2 Ethnic groups"
## [1] "2 Languages"
## [1] "2 Religion"
## [1] "2 Migration"
## [1] "2 Education"
## [1] "2 Health"
## [1] "1 Culture"
## [1] "2 Literature"
## [1] "2 Music"
## [1] "2 Visual art"
## [1] "2 Cinema"
## [1] "2 Cuisine"
## [1] "2 Media"
## [1] "2 Philosophy"
## [1] "2 Sport"
## [1] "2 Symbols"
## [1] "2 Stereotypes"
## [1] "1 Historiography"
## [1] "1 See also"
## [1] "1 Notes"
## [1] "1 References"
## [1] "1 External links"
```

## 24. Media references
>Extract references to media files linked from the article.


```r
lines_UK %>%
  str_extract_all("\\[\\[File:.*?(\\||\\]\\])") %>%
  unlist() %>%
  str_replace_all("^\\[\\[File:|\\|$|\\]\\]$", "")
```

```
##  [1] "Royal Coat of Arms of the United Kingdom.svg"                                                                                                                                                        
##  [2] "Royal Coat of Arms of the United Kingdom (Scotland).svg"                                                                                                                                             
##  [3] "United States Navy Band - God Save the Queen.ogg"                                                                                                                                                    
##  [4] "Europe-UK (orthographic projection).svg"                                                                                                                                                             
##  [5] "Europe-UK.svg"                                                                                                                                                                                       
##  [6] "United Kingdom (+overseas territories and crown dependencies) in the World (+Antarctica claims).svg"                                                                                                 
##  [7] "Stonehenge, Condado de Wiltshire, Inglaterra, 2014-08-12, DD 18.JPG"                                                                                                                                 
##  [8] "Bayeux Tapestry WillelmDux.jpg"                                                                                                                                                                      
##  [9] "State House- 1620 - St Geo - Bermuda.jpg"                                                                                                                                                            
## [10] "Treaty of Union.jpg"                                                                                                                                                                                 
## [11] "Royal Irish Rifles ration party Somme July 1916.jpg"                                                                                                                                                 
## [12] "The British Empire.png"                                                                                                                                                                              
## [13] "Tratado de Lisboa 13 12 2007 (081).jpg"                                                                                                                                                              
## [14] "Uk topo en.jpg"                                                                                                                                                                                      
## [15] "Inside the Reef Cayman.jpg"                                                                                                                                                                          
## [16] "Cap Juluca - Anguilla.jpg"                                                                                                                                                                           
## [17] "Bermuda-Harbour and Town of St George.jpg"                                                                                                                                                           
## [18] "Rothera from reptile.jpg"                                                                                                                                                                            
## [19] "Roadtown, Tortola.jpg"                                                                                                                                                                               
## [20] "Upland.jpg"                                                                                                                                                                                          
## [21] "Catalan Bay from The Rock.JPG"                                                                                                                                                                       
## [22] "Soufriere Hills.jpg"                                                                                                                                                                                 
## [23] "Bounty_bay.jpg"                                                                                                                                                                                      
## [24] "St-Helena-Jamestown-from-above.jpg"                                                                                                                                                                  
## [25] "Grytviken_church.jpg"                                                                                                                                                                                
## [26] "Cockburn Town.jpg"                                                                                                                                                                                   
## [27] "Mont Orgueil and Gorey harbour, Jersey.jpg"                                                                                                                                                          
## [28] "St Peter Port Guernsey.jpg"                                                                                                                                                                          
## [29] "The_View_From_Douglas_Head,_Isle_Of_Man..jpg"                                                                                                                                                        
## [30] "London Parliament 2007-1.jpg"                                                                                                                                                                        
## [31] "UK Political System.png"                                                                                                                                                                             
## [32] "Scottish Parliament, Main Debating Chamber - geograph.org.uk - 1650829.jpg"                                                                                                                          
## [33] "Royal Courts of Justice 2019.jpg"                                                                                                                                                                    
## [34] "High Court of Justiciary.jpg"                                                                                                                                                                        
## [35] "Gibraltar National Day 027 (9719742224) (2).jpg"                                                                                                                                                     
## [36] "HMS Queen Elizabeth (R08) underway during trials with HMS Sutherland (F81) and HMS Iron Duke (F234) on 28 June 2017 (45162784).jpg"                                                                  
## [37] "Banco de Inglaterra, Londres, Inglaterra, 2014-08-11, DD 141.JPG"                                                                                                                                    
## [38] "2017 Jaguar XE Portfolio Diesel Automatic 2.0 Front.jpg"                                                                                                                                             
## [39] "British Airways A380-841 G-XLEA (16948377692).jpg"                                                                                                                                                   
## [40] "Darwin restored2.jpg"                                                                                                                                                                                
## [41] "Heathrow T5.jpg"                                                                                                                                                                                     
## [42] "St Pancras Railway Station 2012-06-23.jpg"                                                                                                                                                           
## [43] "Oil platform in the North SeaPros.jpg"                                                                                                                                                               
## [44] "Population density UK 2011 census.png"                                                                                                                                                               
## [45] "Non-white in the 2011 census.png"                                                                                                                                                                    
## [46] "Anglospeak.png"                                                                                                                                                                                      
## [47] "West Side of Westminster Abbey, London - geograph.org.uk - 1406999.jpg"                                                                                                                              
## [48] "Neasden Temple - Shree Swaminarayan Hindu Mandir - Gate.jpg"                                                                                                                                         
## [49] "United Kingdom foreign born population by country of birth.png"                                                                                                                                      
## [50] "The Prime Minister, Shri Narendra Modi and the Prime Minister of United Kingdom (UK), Mr. David Cameron interacting with the school children, at Wembley Stadium, in London on November 13, 2015.jpg"
## [51] "British expats countrymap.svg"                                                                                                                                                                       
## [52] "Tom Quad, Christ Church 2004-01-21.jpg"                                                                                                                                                              
## [53] "KingsCollegeChapelWest.jpg"                                                                                                                                                                          
## [54] "Edinburgh New College (8594473141).jpg"                                                                                                                                                              
## [55] "15th Sep 2012-Abdn Children's Hosp & Emergency Care Centre 10.JPG"                                                                                                                                   
## [56] "Shakespeare.jpg"                                                                                                                                                                                     
## [57] "Dickens by Watkins 1858.png"                                                                                                                                                                         
## [58] "The Fabs.JPG"                                                                                                                                                                                        
## [59] "Turner selfportrait.jpg"                                                                                                                                                                             
## [60] "Hitchcock, Alfred 02.jpg"                                                                                                                                                                            
## [61] "Chicken tikka masala.jpg"                                                                                                                                                                            
## [62] "Bbc broadcasting house front.jpg"                                                                                                                                                                    
## [63] "Wembley-STadion 2013.JPG"                                                                                                                                                                            
## [64] "Inside the Millennium Stadium, Cardiff.jpg"                                                                                                                                                          
## [65] "Saville vs Broady – Wimbledon Boys Singles Final 2011.jpg"                                                                                                                                           
## [66] "R&A Clubhouse, Old Course, Swilcan Burn bridge.jpg"                                                                                                                                                  
## [67] "Britannia-Statue.jpg"
```

## 25. Infobox
>Extract field names and their values in the Infobox “country”, and store them in a dictionary object.



## 26. Remove emphasis markups
>In addition to the process of the problem 25, remove emphasis MediaWiki markups from the values. See Help:Cheatsheet.

## 27. Remove internal links
>In addition to the process of the problem 26, remove internal links from the values.

## 28. Remove MediaWiki markups
>In addition to the process of the problem 27, remove MediaWiki markups from the values as much as you can, and obtain the basic information of the country in plain text format.

## 29. Country flag
>Obtain the URL of the country flag by using the analysis result of Infobox.
