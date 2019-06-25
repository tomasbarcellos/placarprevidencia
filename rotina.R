library(tidyverse)
library(httr)
library(rvest)

link <- "https://www.valor.com.br/especial/placar-previdencia"
resp <- GET(link)

nos <- resp %>% 
  read_html %>% 
  html_nodes(xpath = "//div[contains(@id,'pl-numero')]") 


num_votos <-  nos %>% 
  html_attr("data-value") %>% 
  as.integer()
  
tipos_votos <- nos %>% 
  html_attr("class") %>% 
  str_remove("^.+ ") %>% 
  str_remove("num-")

tibble(
  data = Sys.Date(),
  voto = tipos_votos,
  quantidade = num_votos
) %>% 
  write_csv("votos.csv", append = TRUE)

votos_datalhados <- resp %>% 
  read_html() %>% 
  html_table() %>% 
  magrittr::extract2(1) %>% 
  magrittr::extract(1:513, -1) %>% 
  mutate(data = Sys.Date())

votos_datalhados %>% 
  write_csv("votos_detalhados.csv", append = TRUE)

