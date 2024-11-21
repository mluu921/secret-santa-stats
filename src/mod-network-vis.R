mod_input_vis_network <- function(id, data) {
  ns <- NS(id)
  
  available_years <- unique(data$year)
  tagList(
    shiny::selectInput(NS(id, "year"), 'Select Year', choice = available_years)
  )
}

mod_output_vis_network <- function(id) {
  ns <- NS(id)
  tagList(
    networkD3::forceNetworkOutput(NS(id, "n"))
  )
}

mod_server_vis_network <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      
      filtered <- reactive({
        
        data |> 
          filter(year == input$year)
        
      })
      
      output$n <- networkD3::renderForceNetwork({
        create_network_viz(filtered(), 100, -100)
      })
      
    }
  )
}
