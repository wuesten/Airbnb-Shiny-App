
function(request) {
navbarPage("Airbnb Barcelona",
           theme = shinytheme("cerulean"), #https://rstudio.github.io/shinythemes
           
           
           
           ##### Overview ##########        
           tabPanel("Overview",
                    #img(src = "airbnb_overview.jpg", height = 600, weight =700, align="center")
                    #use Shiny’s HTML tag functions to center the image
                    #https://stackoverflow.com/questions/34663099/how-to-center-an-image-in-a-shiny-app
                    HTML('<center><img src="airbnb.jpg", height = 100%, weight =100% ></center>')
           ),
           tabPanel("Map",
                    bookmarkButton(id = "bookmark1"),
                    sidebarLayout(
                        sidebarPanel(
                          numericInput(
                            inputId =   "Id090",
                            label = "Guests",
                            value = 1,
                            min = 1,
                            max = 16,
                            step = 1,
                            width = NULL
                          ),

                          
                          prettyCheckboxGroup(
                            inputId = "airbnb_type",
                            label = "Type of Airbnb", 
                            choices = c("Entire home/apt", "Private room", "Shared room"),
                            status =  'success',
                            animation = "tada", 
                            selected = c("Entire home/apt", "Private room", "Shared room")
                          ),
                            pickerInput(
                                inputId = "Id094",
                                label = "Select neighborhood", 
                                choices = df_listings_neighborhoods,
                                options = list(
                                `actions-box` = TRUE), 
                                multiple = TRUE
                            ),

                            sliderTextInput(
                                inputId = "Id096",
                                label = "Price Range in $:", 
                                choices = seq(0, max_price$`max(price)`, by=1),
                                grid = TRUE,
                                selected = max_price$`max(price)`
                                
                            ),
                            sliderTextInput(
                                inputId = "Id097",
                                label = "Review rating:", 
                                choices = seq(0, 5, by=0.1),
                                grid = TRUE,
                            ),
                          sliderTextInput(
                            inputId = "Id098",
                            label = "Number of ratings:", 
                            choices = seq(0, 100, by=1),
                            grid = TRUE,
                            selected = 10,
                          ),

                        ),
                        mainPanel(
                            leafletOutput('map', height = "90vh")
                        )
                    )
           ),
           tabPanel("Price",
                    bookmarkButton(id = "bookmark2"),
                    sidebarLayout(
                      sidebarPanel(
                        numericInput(
                          inputId =   "Id190",
                          label = "Guests",
                          value = 1,
                          min = 1,
                          max = 16,
                          step = 1,
                          width = NULL
                        ),

                        prettyCheckboxGroup(
                          inputId = "airbnb_type_1",
                          label = "Type of Airbnb", 
                          choices = c("Entire home/apt", "Private room", "Shared room"),
                          status =  'success',
                          animation = "tada", 
                          selected = c("Entire home/apt", "Private room", "Shared room")
                        ),
                        pickerInput(
                          inputId = "Id194",
                          label = "Select neighborhood", 
                          choices = df_listings_neighborhoods,
                          selected = default_neighborhood,
                          options = list(
                            `actions-box` = TRUE), 
                          multiple = TRUE
                        ),

                        sliderTextInput(
                          inputId = "Id197",
                          label = "Review rating:", 
                          choices = seq(0, 5, by=0.1),
                          grid = TRUE
                        ),
                        sliderTextInput(
                          inputId = "Id198",
                          label = "Number of ratings:", 
                          choices = seq(0, 100, by=1),
                          grid = TRUE,
                          selected = 10),
                          
                        dateInput("date1", 
                            label = "Start date",
                            value = "2021-10-11",
                            min = '2021-10-11',
                            max = '2022-10-10'
                          ),
                        dateInput("date2", 
                                  label = "End date",
                                  value = "2022-10-10",
                                  min = '2021-10-11',
                                  max = '2022-10-10'
                        ),

                        ),
                        mainPanel(
                          plotlyOutput('plot_price'),
                          plotlyOutput('bar_plot')
                        )
                      )
                    
           )
)
}
