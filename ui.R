############################################################### 
# Course10_Data Science Capstone_Final_Project_ShinyApp
############################################################### 

# Author: Jingchen Huyan
# Date: May, 25, 2020
# Description: Shiny ui.R, Coursera Data Science Capstone Final Project

        library(shiny)
        library(shinythemes)
        library(markdown)
        library(dplyr)
        library(tm)
shinyUI(
        navbarPage("Data Science Capstone",
                   theme = shinytheme("spacelab"),
                   tabPanel("Prediction App",
                            fluidPage(
                                    titlePanel("Next Word Prediction"),
                                    sidebarLayout(
                                            sidebarPanel(
                                                    em("(You can type in a word/phrase you like, or try to type: also, couple, new, let us, new york, I want to go, etc.)"),
                                                    br(),
                                                    textInput("userInput",
                                                              "Enter a word or phrase:",
                                                              value =  "",
                                                              placeholder = "Enter text here"),
                                                    br(),
                                                    radioButtons("rd","Number of Predictions:",c("1"="1",  
                                                                              "2"="2",
                                                                              "3"="3"))
                                            ),
                                            mainPanel(
                                                    h4("This application takes your input and predict the next word:"),
                                                    br(),
                                                    h4("Input text: "),
                                                    verbatimTextOutput("userSentence"),
                                                    br(),
                                                    h4("Prediction: "),
                                                    verbatimTextOutput("prediction1"),
                                                    verbatimTextOutput("prediction2"),
                                                    verbatimTextOutput("prediction3")
                                            )
                                    )
                            )
                   ),
                   tabPanel("About",
                            h3("About This Shiny App"),
                            br(),
                            p(h4("Data Sampling and Cleaning"),
                              h5("Consider the run time, a sample was created (sample size = 0.03, set.seed(22))."),
                              h5("The texts were then cleaned and normalized by converting all letters to lowercase, removing punctuation and numbers, remove bad words, and stripping whitespace, etc."),
                              h5("The application uses given dataset to generate n-grams (groups of two, three, and four words), which are then used to suggest the next most probable word."),
                              sep="\n"),
                            br(),
                            p(h4("Algorithm"),
                            h5("1. Read the input text "),
                            h5("2. Tokenize and clean the input"),
                            h5("3. Predict using quadgrams"),
                            h5("4. If no prediction, back-off to trigrams"),
                            h5("5. If no prediction, back-off to bigrams"),
                            h5("6. Else return NA"),
                              sep="\n"),
                            br(),
                                br(),
                                p(h5("For source code please visit:"),
                                  h5("(ui.R, server.R)"),
                                  h5("", a("Link", href="https://github.com/krstl-316/Course-9-Developing-Data-Analysis-Course-Project")),
                                  sep="\n"),
                                p(h5("For R presentation document please visit:"),
                                  h5("(Published on RPubs)"),
                                  h5("", a("Link", href="https://github.com/krstl-316/Course-9-Developing-Data-Analysis-Course-Project")),
                                  sep="\n")
                            
                   )
        )
)


###############################################################
# The End
###############################################################

