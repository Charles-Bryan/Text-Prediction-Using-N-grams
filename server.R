require(knitr) # For prettier output tables
require(kableExtra)
require(rlist) # Used for saving and loading lists
require(tidyverse) # Used extensively
require(data.table) # Better alternative to Data.Frames
require(tm) # Text Cleaning and Processing
require(corpus)
require(textclean)
require(quanteda)
require(future.apply) # Parallel Processing to significantly speed up large operations
require(parallel)
require(readtext) # Used for reading in profanity text
require(reshape) # Used for colsplit function
require(rbenchmark) # For Measuring the Model's Speed
require(grid) # Plotting images in specified layouts
require(gridExtra)

library(shiny)
source("./functions/helpers.R")
library(shinydashboard)

ui <- dashboardPage(
        dashboardHeader(),
        dashboardSidebar(),
        dashboardBody()
)
fast_dt <- as.data.table(read.csv(file = './data/fast_dt.csv', stringsAsFactors=FALSE))
review_dt <- as.data.table(read.csv(file = './data/review_dt.csv', stringsAsFactors=FALSE))
text_tbl <- as.data.table(read.csv(file = './data/text_tbl.csv', stringsAsFactors=FALSE))
cleaned_text_tbl <- as.data.table(read.csv(file = './data/cleaned_text_tbl.csv', stringsAsFactors=FALSE))
basic_stats_df <- as.data.table(read.csv(file = './data/basic_stats_df.csv', stringsAsFactors=FALSE))
basic_stats_df_reduced <- as.data.table(read.csv(file = './data/basic_stats_df_reduced.csv', stringsAsFactors=FALSE))


server <- function(input, output) {
        
        ## Application ---------------------------------------------------------
        
        # Application Text
        output$application_text1 <- renderUI({
                HTML("Natural Language Processing (NLP) is a field of study that uses computers to process and analyze large sets of language data. 
                This field began seeing serious research interests as far back as 1954 with the Georgetown-IBM experiment where more than sixty 
                Russian sentences were automatically translated to English. Until the 1980s NLP systems generally followed manual rules for 
                automated processing. However, at this point machine learning algorithms and statistical modeling approaches began seeing successes 
                in this field. Common tasks handled today using these methods include automatic speech recognition, part-of-speech tagging, and machine 
                translation to predict a source language. In this project, we use a modified Katz's back-off statistical model with various lengthed 
                n-grams to predict the next word in a string of text.")
        })
        
        # Instruction text
        output$instructions <- renderUI({
                HTML("To use the Text Predict-R App, simply type some text 
                     into the phone where it currently says <b>Enter Text Here</b>, 
                     and then click <b>PREDICT!</b>")
        })
        
        # Slow speed warning text
        output$warning <- renderText({
                '*The first time running may be a little slow due to loading 
                times, but subsequent runs will be fast!'
        })
        
        # Read in text from user
        user_input <- eventReactive(input$button, {
                input$input_text
                })
        # Run text through model
        prediction_output <- reactive({
                Predict_ngram_fast(user_input(), fast_dt)
        })
        
        # Output table
        output$table <- renderTable({ head( prediction_output(), n = 6 )},  
                                                  striped = TRUE,  
                                                  spacing = 'xs',  
                                                  digits = 2) 
        # Phone app display
        output$recommended_five <- renderText({
                as.character(prediction_output()$Top_Choices)[1:5] %>%
                        str_pad(width=12, side="both") %>% paste(collapse="|")
        })

        ## Corpus --------------------------------------------------------------
        
        # Top text
        output$corpus_text1 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })
        
        
        
        output$review_dt_kable <- function(){
                review_dt %>% select(File:File_Size_in_Mb) %>% 
                knitr::kable("html") %>%
                kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
                column_spec(1, width = "15em", bold = T, border_right = T, background = "#C3C3B9") %>%
                column_spec(2, width = "15em", border_right = T, background = "SkyBlue") %>%
                column_spec(3, width = "15em", border_right = T, background = "#C3C3B9") %>%
                column_spec(4, width = "15em", border_right = T, background = "SkyBlue") %>%
                column_spec(5, width = "15em", border_right = T, background = "#C3C3B9")
        }
        
        # Second text
        output$corpus_text2 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })
        
        output$text_tbl_kable <- function(){
                text_tbl %>% select(Lines:Raw_Text) %>% 
                knitr::kable("html") %>%
                kable_styling(full_width = F) %>%
                column_spec(1, width = "5em", bold = T, border_right = T, background = "#C3C3B9") %>%
                column_spec(2, width = "60em", background = "SkyBlue")
        }
        
        ## Cleaning Data  ----------------------------------------------------
        
        output$cleaned_text1 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })
        
        output$cleaned_text_tbl_kable <- function(){
                cleaned_text_tbl %>% select(Lines:Cleaned_Text) %>%
                knitr::kable("html") %>%
                kable_styling(full_width = F, position = "float_right") %>%
                column_spec(1, width = "5em", bold = T, border_right = T, background = "#C3C3B9") %>%
                column_spec(2, width = "30em", background = "SkyBlue") %>%
                column_spec(3, width = "30em", background = "#1AD167")
        }
        ## N-Gram Dataframe ----------------------------------------------------
        
        output$dataframes1 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })
        
        # Raw ---------------------------
        # basic stats
        output$basic_stats_df_kable <- function(){
                basic_stats_df %>% 
                dplyr::rename(one_gram = X1.gram, two_gram = X2.gram, three_gram = X3.gram, 
                       four_gram = X4.gram, five_gram = X5.gram) %>%
                select(Basic_Stats:five_gram) %>%
                knitr::kable("html") %>%
                kable_styling(full_width = F, position = "float_right") %>%
                column_spec(1, width = "25em", bold = T, border_right = T, background = "#C3C3B9") %>%
                column_spec(2, width = "30em", background = "SkyBlue") %>%
                column_spec(3, width = "30em", background = "#C3C3B9")%>%
                column_spec(4, width = "30em", background = "SkyBlue") %>%
                column_spec(5, width = "30em", background = "#C3C3B9")%>%
                column_spec(6, width = "30em", background = "SkyBlue")
        }
        
        output$dataframes2 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })

        # Reduced ---------------------------
        # basic stats reduced
        output$basic_stats_df_reduced_kable <- function(){
                basic_stats_df_reduced %>% 
                dplyr::rename(one_gram = X1.gram, two_gram = X2.gram, three_gram = X3.gram, 
                              four_gram = X4.gram, five_gram = X5.gram) %>%
                select(Basic_Stats:five_gram) %>%
                knitr::kable("html") %>%
                kable_styling(full_width = F, position = "float_right") %>%
                column_spec(1, width = "25em", bold = T, border_right = T, background = "#C3C3B9") %>%
                column_spec(2, width = "30em", background = "SkyBlue") %>%
                column_spec(3, width = "30em", background = "#C3C3B9")%>%
                column_spec(4, width = "30em", background = "SkyBlue") %>%
                column_spec(5, width = "30em", background = "#C3C3B9")%>%
                column_spec(6, width = "30em", background = "SkyBlue")
        }
        
        ## Lookup Table  ----------------------------------------------------
        
        output$lookup1 <- renderUI({
                HTML("ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE 
                     ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ADD WORDS HERE ")
        })
        
        output$lookup_table_kable <- function(){
                browser()
                fast_dt %>% select(Preceding:score5) %>%
                        knitr::kable("html") %>%
                        kable_styling(full_width = F, position = "float_right")
                # %>%
                #         column_spec(1, width = "25em", bold = T, border_right = T, background = "#C3C3B9") %>%
                #         column_spec(2, width = "15em", background = "SkyBlue") %>%
                #         column_spec(3, width = "15em", background = "#C3C3B9")%>%
                #         column_spec(4, width = "15em", background = "SkyBlue") %>%
                #         column_spec(5, width = "15em", background = "#C3C3B9")%>%
                #         column_spec(6, width = "15em", background = "SkyBlue") %>%
                #         column_spec(7, width = "15em", background = "#C3C3B9")%>%
                #         column_spec(8, width = "15em", background = "SkyBlue") %>%
                #         column_spec(9, width = "15em", background = "#C3C3B9")%>%
                #         column_spec(10, width = "15em", background = "SkyBlue") %>%
                #         column_spec(11, width = "15em", background = "#C3C3B9")
        }
}
