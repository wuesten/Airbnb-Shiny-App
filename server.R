#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

function(input, output, session) {
    
    

    # Need to exclude the buttons from themselves being bookmarked
    setBookmarkExclude(c("bookmark1", "bookmark2"))
    
    # Trigger bookmarking with either button
    observeEvent(input$bookmark1, {
        session$doBookmark()
    })
    observeEvent(input$bookmark2, {
        session$doBookmark()
    })
    
    
    ##################
    ### Leaflet Plot ####
    ##################
    

    
    # filter input parameter leaflet plot
    filtered <- reactive({
        df_listings %>% filter(neighbourhood_cleansed %in% input$Id094) %>% filter(room_type %in% input$airbnb_type) %>%
            filter(price <=  input$Id096) %>% filter(review_scores_rating >= input$Id097) %>% filter(number_of_reviews >= input$Id098) %>%
            filter(accommodates >= input$Id090)
    })
    #filter neighborhoods for polygon
    filtered_polygon <- reactive({
        df_geojson_bcn %>% subset(cor_neighborhood %in% input$Id094)
    })
    pal <- colorFactor(c("navy", "red","orange"), domain = c("Entire home/apt", "Private room", "Shared room"))
    
    #Plot 1
    output$map <- renderLeaflet({
        leaflet(data = filtered()) %>%
            setView(lat = 41.3983991, lng =  2.121622, zoom = 12, options = 
                        leafletOptions(minZoom = 14, dragging = FALSE)) %>%
            addTiles() %>% 
                    addCircleMarkers(
                            popup =~paste('<b><font color="Black">','Listing Information','</font></b><br/>',
                                            'Room Type:', room_type,'<br/>',
                                            'Price:', price,'$','<br/>',
                                            'Rating Score:', review_scores_rating, '<br/>',
                                            'Number of Reviews:', number_of_reviews,'<br/>', 
                                            "<a href='", listing_url , "' target='_blank'>","Book this airbnb</a>"),
                             lng = ~ longitude,
                             lat = ~  latitude,
                             radius = 10,
                             color = ~pal(room_type),
                            clusterOptions = markerClusterOptions()) %>%
                            #labelOptions = labelOptions(noHide = TRUE, offset=c(0,-12), textOnly = TRUE) )
        addLegend(pal = pal,
                  values = c("Entire home/apt", "Private room", "Shared room"),
                  opacity = 1.0,
                  title = "Airbnb type",
                  position = "bottomright") %>%
            addPolygons(data =filtered_polygon())
    })

    ##################
    ### Plotly Price Plot ####
    ##################
    
    # Plot 2
    plot2 <- reactive({
        
        shiny::validate(
            need(input$Id194, 'Please choose at least one neighborhood.'),
            need(!is.null(input$airbnb_type_1), 'Please choose at least one type of airbnb')
        )
        
        df_listings_bcn_calender %>%
            select(neighbourhood_cleansed,room_type,price.y,review_scores_rating, number_of_reviews, accommodates, date) %>% 
            filter(neighbourhood_cleansed %in% input$Id194 &
                       room_type %in% input$airbnb_type_1 &
                       review_scores_rating >= input$Id197 &
                       number_of_reviews >= input$Id198 &
                       accommodates >= input$Id190 &
                       date>= input$date1 & date<= input$date2) %>% 
            group_by(neighbourhood_cleansed,date) %>% 
            summarise(avg_price = round(mean(price.y, na.rm = TRUE),1))
        
    })

    output$plot_price <- renderPlotly({

        validate(
            need(nrow(plot2()) > 0, "No data for this selection.")
        )
        
                p <- ggplot(data = plot2(), aes(x = date, y = avg_price, color = neighbourhood_cleansed)) +
                    geom_line() + theme_bw() + labs(y = "Average price in $", x = "Date", color = "Neighborhood")+
                    ggtitle("Average price of airbnb's per neighborhood and time period") 
                
                ggplotly(p)

    
})

    #bar plot
    bar_plot <- reactive({
        
        shiny::validate(
            need(input$Id194, 'Please choose at least one neighborhood.'),
            need(!is.null(input$airbnb_type_1), 'Please choose at least one type of airbnb')
        )

        
        df_listings_bcn_calender %>%
            select(neighbourhood_cleansed,room_type,price.y,review_scores_rating, number_of_reviews, accommodates, date) %>% 
            filter(neighbourhood_cleansed %in% input$Id194 &
                       room_type %in% input$airbnb_type_1 &
                       review_scores_rating >= input$Id197 &
                       number_of_reviews >= input$Id198 &
                       accommodates >= input$Id190 &
                       date>= input$date1 & date<= input$date2) %>% 
            group_by(neighbourhood_cleansed, room_type) %>% 
            summarise(avg_price = round(mean(price.y, na.rm = TRUE),1))
        
    })
    
    
    output$bar_plot <- renderPlotly({
        validate(
            need(nrow(bar_plot()) > 0, "No data for this selection.")
        )

        s<-ggplot(data=bar_plot(), aes(x=room_type, y=avg_price ,fill = neighbourhood_cleansed )) +
            geom_bar(stat = "identity", position = "dodge") +
            coord_flip() + theme_bw()+ labs(y = "Average price in $", x = "Room type", fill = "Neighborhood")+
            ggtitle("Average price of airbnb's per neighborhood and room type") 
        ggplotly(s)
    })
    

}
