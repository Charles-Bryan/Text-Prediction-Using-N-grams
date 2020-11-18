
library(shiny)
library(DT)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(title = "Text Predict-R"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Application", tabName = "application", icon = icon("layer-group")),
            menuItem("Corpus", tabName = "corpus", icon = icon("book")),
            menuItem("Cleaning the Corpus", tabName = "cleaning", icon = icon("broom")),
            menuItem("N-gram Dataframes", tabName = "dataframes", icon = icon("database")),
            menuItem("Lookup Table", tabName = "lookup", icon = icon("table"))
        )
    ),
    
    dashboardBody(
            tags$style(HTML("


                        .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
                          border-left-color:#009E34}"
                            )
                       ),
        tabItems(
            # TAB 1 - APPLICATION ---------------------------------------------
            tabItem(tabName = "application",
                    h2("Application"),
                    fluidRow(
                        column(12,
                               htmlOutput("application_text1")
                        )
                    ),
                    fluidRow(
                        column(3, offset=2, 
                                    div(style = "
                                        height:25px;
                                        width:480px;
                                        background-color: #ECF0F5;", "")),
                                   tags$style(".row{
                                                padding: 0;
                                                margin-left: 0}"),
                                        tags$style(".sidebar-menu>li.active>a{
                                                        border-left-color: #009E34;}"
                                        )
                             ),
                    fluidRow(
                        column(2, 
                               
                               fluidRow(
                                   htmlOutput("instructions"),
                                   tags$head(
                                       tags$style("#instructions{
                                                  text-align: center;
                                                  margin-left: 25px;
                                                  background-color: #eee;
                                                  border: 2px solid #009E34}"
                                       )
                                   )
                               ),
                               fluidRow(
                                   div(style = "
                                        height:25px;", "")
                               ),
                               fluidRow(
                                   textOutput("warning"),
                                   tags$head(
                                       tags$style("#warning{
                                                  text-align: center;
                                                  margin-left: 25px;
                                                  font-weight: bolder;
                                                  background-color: #eee;
                                                  border: 2px solid #009E34}"
                                       )
                                   )
                               )
                        ),
                        column(3, offset=1,
                               div(style = "font-size: 0px; padding: 0px 0px 0px 0px",
                                   fluidRow(
                                       img(src="Phone_Cropped1.png", height='497px',width='320px')
                                       ),
                                   fluidRow(
                                        textOutput("recommended_five"),
                                        tags$head(
                                            tags$style("#recommended_five{
                                                height: 27px;
                                                width: 320px;
                                                font-size: 15px;
                                                background-color: #e5e5e5;
                                                padding-left: 3px;
                                                padding-right: 3px;
                                                padding-top: 3px;
                                                font-family: serif;
                                                font-style: italic;
                                                font-weight: 600;
                                                white-space: pre-wrap;}"
                                                       )
                                            )
                                        ),
                                   fluidRow(
                                           img(src="Phone_Cropped5.png", height='9px', width='320px')
                                       ),
                                   fluidRow(
                                       tags$style(".col-sm-1{
                                                  padding-left: 0px;
                                                  padding-right: 0px;
                                                  width: 50px;
                                                  margin: 0px}"),
                                       tags$style(".col-sm-2{
                                                  padding-left: 0px;
                                                  padding-right: 0px;
                                                  height: 27px;
                                                  width: 187px;
                                                  margin: 0px}"),
                                       tags$style(".form-group.shiny-input-container{
                                                  background-color: #f7f7f8}"),
                                       tags$style(".col-sm-3{
                                                    padding: 0px;
                                                    width: auto;}"),
                                       tags$style(".well{
                                                    width: 83px;
                                                    padding: 0px;
                                                    height: 27px;
                                                    width: 83px;
                                                    margin: 0px;
                                                    border: 0px;
                                                    border-radius: 0px;
                                                    -webkit-box-shadow: none;
                                                    background-color: #f7f7f8}"),
                                       tags$style(".btn-default{
                                                    margin-left: 1px;
                                                    background-color: #f7f7f8;
                                                    border-radius: 10px}"),
                                      tags$style(".control-label{
                                                   margin-bottom: 0px}"),
                                      tags$style(".form-control{
                                                   font-style: normal;
                                                   font-weight: 800;
                                                   border-style: solid;
                                                   border-radius: 5px;
                                                   height: 27px}"),
                                       tags$style(".form-group{
                                                  margin-bottom: 0px}"),
                                       column(1,
                                              img(src="Phone_Cropped2.png", height='27px', width='50px')
                                              ),
                                       column(2,
                                              textInput("input_text", label = "Where Am I?", placeholder="Enter Text Here!", width='187px')
                                              ),
                                       column(3,
                                              wellPanel(actionButton("button", "PREDICT!",
                                                                     style="margin-left: 5px;
                                                                            margin-top: 1px;
                                                                            padding-left: 6px;
                                                                            padding-right: 6px;
                                                                            padding-top: 1px;
                                                                            padding-bottom: 2px;
                                                                            font-weight: bolder")
                                                        )
                                              )
                                       ),
                                   fluidRow(
                                       img(src="Phone_Cropped4.png", height='9px', width='320px')
                                       )
                                   )
                               ),
                        column(3,
                               tableOutput("table"),
                               tags$head(
                                   tags$style("#table{
                                                background-color: #3c8dbc;
                                                margin-left: 80px;
                                                margin-right: 0px;
                                                margin-top: 0px;
                                                margin-bottom: 0px;}"
                                   ),
                                   tags$style(".table.table.shiny-table.table-striped.table-bordered.spacing-xs{
                                                margin-left: 0px;
                                                margin-right: 0px;
                                                margin-top: 0px;
                                                margin-bottom: 0px;}"
                                              )
                               )
                               )
                    )
            ),

            # TAB 2 - CORPUS --------------------------------------------------
            tabItem(tabName = "corpus",
                    h2("Corpus"),
                    fluidRow(
                        column(12,
                               htmlOutput("corpus_text1")
                            )
                        ),
                    fluidRow(
                        column(12,
                               tableOutput("review_dt_kable")
                               )
                        ),
                    fluidRow(
                        column(12,
                               htmlOutput("corpus_text2")
                            )
                        ),
                    fluidRow(
                        column(12,
                               tableOutput("text_tbl_kable")
                            )
                        )
                    ),

            # TAB 3 - Cleaning Data -------------------------------------------
            tabItem(tabName = "cleaning",
                    h2("Cleaning the Corpus"),
                    fluidRow(
                        column(12,
                               htmlOutput("cleaned_text1")
                        )
                    ),
                    fluidRow(
                        column(5,
                               htmlOutput("skipped_line1"), 
                               tags$ol(
                                       tags$li("Split text into sentences"), 
                                       tags$li("Lower case all text (Ex. CaMeLs -> camels)"), 
                                       tags$li("Replace Unicode issues"),
                                       tags$li("Replace common twitter notation (Ex. RT -> retweet)"),
                                       tags$li("Replace contractions with their elongated form (Ex. won't -> will not)"),
                                       tags$li("Replace character elongation (Ex. whyyyyyyy -> why)"),
                                       tags$li("Replace ordinal numbers (Ex. 1st -> first)"),
                                       tags$li("Replace the numbers 0 through 10 with word equivalent (Ex. 0 -> zero)"),
                                       tags$li("Remove possessive 's (Ex. child's -> child)"),
                                       tags$li("Fix specific common issues"),
                                       tags$li("Remove urls"),
                                       tags$li("Remove remaining punctuation and numbers"),
                                       tags$li("Remove any remaining non ASCII characters"),
                                       tags$li("Remove common ambiguous characters (Ex. letters like d or m)"),
                                       tags$li("Add a token to the start of each sentence"),
                                       tags$li("Remove profanity")
                               )
                        ),
                        column(7,
                               tableOutput("cleaned_text_tbl_kable")
                        )
                    )
            ),
            
            # TAB 4 - N-gram Dataframes ----------------------------------------
            tabItem(tabName = "dataframes",
                    h2("N-gram Dataframes"),
                    fluidRow(
                        column(12,
                               htmlOutput("dataframes1")
                        )
                    ),
                    fluidRow(
                        column(12,
                               box(
                                       title = 'Raw N-Gram Dataframes', width = NULL, status = 'primary',
                                       tableOutput("basic_stats_df_kable")  
                               )
                               
                        )
                    ),
                    fluidRow(
                        column(12,
                               htmlOutput("dataframes2")
                        )
                    ),
                    fluidRow(
                        column(12,
                               box(
                                       title = 'Reduced N-Gram Dataframes', width = NULL, status = 'primary',
                                       tableOutput("basic_stats_df_reduced_kable")  
                               )
                        )
                    )
            ),
            
            # TAB 5 - Lookup Table ---------------------------------------------
            tabItem(tabName = "lookup",
                    h2("Lookup Table"),
                    fluidRow(
                        column(12,
                               htmlOutput("lookup1")
                        )
                    ),
                    fluidRow(
                        column(12,
                               tags$style(".box.box-primary{
                                        border-top-color: #B9BDC2;
                                        background-color: #B9BDC2;}"),
                               
                               tags$style(HTML('table.dataTable tr:nth-child(even) {background-color: #6EB5D2 !important;}')),
                               tags$style(HTML('table.dataTable tr:nth-child(odd) {background-color: #C3C3B9 !important;}')),
                               tags$style(HTML('table.dataTable th {background-color: white !important;}')),
                               box(
                                       title = '', width = NULL, status = 'primary',
                                       DT::dataTableOutput("lookup_table_kable")  
                               )
                               # DTOutput("lookup_table_kable")
                        )
                    )
                )
            
            
            
              
        )
    )
)
