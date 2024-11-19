library(shiny)
library(bslib)
library(lubridate)
library(fontawesome)
library(dplyr)
library(networkD3)
library(igraph)
library(tidyr)

# source('src/query-gs.R')
source('src/utils.R')
# source('app/src/sims.R')
source('src/value-boxes.R')
source('src/mod-network-vis.R')

board <- pins::board_folder('board')

data <- pins::pin_read(board, 'processed-data')

card_network <- card(
  card_header('WHO MATCHED WITH WHO?'),
  full_screen = TRUE,
  layout_sidebar(
    sidebar = sidebar(
      mod_input_vis_network('vis_network', data),
    ),
    mod_output_vis_network('vis_network')
  )
)

ui <- bslib::page_navbar(
  title = 'FAM BAM SECRET SANTA STATS!',
  padding = 10,
  nav_panel(
    title = 'HOME',
    layout_columns(
      height = 200,
      fill = FALSE,
      gap = 10,
      vb_days_till_christmas,
      vb_nth_annual,
      vb_ss_since,
      vb_gifts_exchanged,
    ),
    card_intro <- card(
      card_header('FAM BAM SECRET SANTA'),
      HTML(
        readLines(paste0('src/home-page-intro')) |> paste0(collapse = '<br>')
      ))
  ),
  nav_panel(title = 'STATS',
            layout_column_wrap(card_network))
)

server <- function(input, output, session) {
  
  mod_server_vis_network('vis_network', data)
  
}

shinyApp(ui, server)