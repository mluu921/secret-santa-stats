library(shiny)
library(bslib)
library(lubridate)
library(fontawesome)
library(dplyr)
library(networkD3)
library(igraph)
library(tidyr)
library(purrr)
library(gtExtras)

# source('src/query-gs.R')
source('src/utils.R')
# source('app/src/sims.R')
source('src/value-boxes.R')
source('src/mod-network-vis.R')
source('src/tbl-probs-repeat-match.R')

board <- pins::board_folder('board')

data <- pins::pin_read(board, 'processed-data')

tbl_prob_repeat_match <- pins::pin_read(board, 'tbl-prob-repeat-non-repeat')

card_network <- card(
  card_header('WHO MATCHED WITH WHO?'),
  full_screen = TRUE,
  layout_sidebar(
    sidebar = sidebar(
      mod_input_vis_network('vis_network', data),
    ),
    mod_output_vis_network('vis_network')),
  card_footer(
    HTML(
      readLines(paste0('src/network-description')) |> paste0(collapse = '<br>')
    ) 
  )
)

card_tbl_repeat_matches <- card(
  card_header('HOW LIKELY ARE YOU GOING TO HAVE A REPEAT MATCH?'),
  full_screen = TRUE,
  tbl_prob_repeat_match,
  card_footer(
    HTML(
      readLines(paste0('src/tbl-probs-repeat-description')) |> paste0(collapse = '<br>')
    ) 
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
            layout_column_wrap(card_network, card_tbl_repeat_matches))
)

server <- function(input, output, session) {
  
  mod_server_vis_network('vis_network', data)
  
}

shinyApp(ui, server)