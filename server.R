############################################################### 
# Course10_Data Science Capstone_Final_Project_ShinyApp
############################################################### 

# Author: Jingchen Huyan
# Date: May, 25, 2020
# Description: Shiny ui.R, Coursera Data Science Capstone Final Project

suppressPackageStartupMessages({
        library(tidyverse)
        library(stringr)
        library(dplyr)
        library(tidytext)
}
)
suppressWarnings(library(shiny))
setwd("~/R/Data-Science-Specialization-JH/Course10_Data Science Capstone/NextWordPrediction")
bigram <- readRDS("data/bigramcorpus.rds")
trigram <- readRDS("data/trigramcorpus.rds")
quadgram <- readRDS("data/quadgramcorpus.rds")


googlebadwords <- read.table("data/google_bad_words.txt",sep = ";",header = FALSE)
swearwords <- read.table("data/swear_words.txt",sep="\n", header  = FALSE)
googlebadwords<- data.frame(googlebadwords, stringsAsFactors = FALSE)
swearwords <- data.frame(swearwords, stringsAsFactors = FALSE)
swearwords <- unnest_tokens(swearwords, word, V1)
googlebadwords <- unnest_tokens(googlebadwords, word, V1)


predictionMatch <- function(userInput, ngrams) {
        if (ngrams > 3) {
                dataTokens <- filter(quadgram,word1==userInput[length(userInput)-2],
                                                  word2==userInput[length(userInput)-1],
                                                  word3==userInput[length(userInput)])
                if (nrow(dataTokens) >= 1) {
                        return(dataTokens$word4[1:3])
                }
                return(predictionMatch(userInput, ngrams - 1))
        }
        if (ngrams == 3) {
                dataTokens <- filter(trigram,word1==userInput[length(userInput)-1],
                                                 word2==userInput[length(userInput)])
                dataTokens2 <- filter(quadgram,word1==userInput[length(userInput)-1],
                                     word2==userInput[length(userInput)])
                if (nrow(dataTokens) >= 1) {
                        return(dataTokens$word3[1:3])
                }
                else if(nrow(dataTokens2) >= 1){
                        return(dataTokens2$word3[1:3])
                }
                return(predictionMatch(userInput, ngrams - 1))
        }
        if (ngrams < 3) {
                dataTokens <- filter(bigram,word1==userInput[length(userInput)])
                dataTokens2 <- filter(trigram,word1==userInput[length(userInput)])
                dataTokens3 <- filter(quadgram,word1==userInput[length(userInput)])
                if (nrow(dataTokens) >= 1) {
                        return(dataTokens$word2[1:3])
                }
                else if(nrow(dataTokens2) >= 1){
                        return(dataTokens2$word3[1:3])
                }
                else if(nrow(dataTokens3) >= 1){
                        return(dataTokens2$word3[1:3])
                }
        }
        return(NA)
}

cleanInput <- function(input) {
        if (input == "" | is.na(input)) {
                return("")
        }
        input <- tolower(input)
        input <- removeWords(input, googlebadwords$word)
        input <- removeWords(input, swearwords$word)
        input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
        input <- gsub("^\\s+|\\s+$", "", input)
        input <- stripWhitespace(input)
        
        if (input == "" | is.na(input)) {
                return("")
        }
        input <- unlist(strsplit(input, " "))
        return(input)
        
}

predictNextWord <- function(input, word = 0) {
        
        input <- cleanInput(input)
        if (input[1] == "") {
                output <- c("I","the","We")
        } else if (length(input) == 1) {
                output <- predictionMatch(input, ngrams = 2)
        } else if (length(input) == 2) {
                output <- predictionMatch(input, ngrams = 3)
        } else if (length(input) > 2) {
                output <- predictionMatch(input, ngrams = 4)
        }
        if (word == 0) {
                return(output)
        } else if (word == 1) {
                return(output[1])
        } else if (word == 2) {
                return(output[2])
        } else if (word == 3) {
                return(output[3])
        }
        
}

shinyServer(function(input, output) {
        output$userSentence <- renderText({input$userInput});
        observe({
                rd <- input$rd
                if (rd == "1") {
                        output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
                        output$prediction2 <- NULL
                        output$prediction3 <- NULL
                } else if (rd == "2") {
                        output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
                        output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
                        output$prediction3 <- NULL
                } else if (rd == "3") {
                        output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
                        output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
                        output$prediction3 <- reactive({predictNextWord(input$userInput, 3)})
                }
        })
        
})

###############################################################
# The End
###############################################################

