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
library(shinychat)
library(purrr)
library(elmer)
library(readr)

board <- pins::board_folder('board')

data <- pins::pin_read(board, 'processed-data')

source('src/utils.R')
source('src/value-boxes.R', local = TRUE)
source('src/mod-network-vis.R')

# source('src/query-gs.R')
# source('src/tbl-probs-repeat-match.R')
# source('src/most-frequent-match-leaderboard.R')
# source('src/sims.R')

tbl_prob_repeat_match <- pins::pin_read(board, 'tbl-prob-repeat-non-repeat')
tbl_repeat_match_leaderboard <- pins::pin_read(board, 'tbl-repeat-match-leaderboard')

card_network <- card(
  card_header('SECRET SANTA CONNECTIONS'),
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
  card_header('SECRET SANTA Déjà VU'),
  full_screen = TRUE,
  tbl_prob_repeat_match,
  card_footer(
    HTML(
      readLines(paste0('src/tbl-probs-repeat-description')) |> paste0(collapse = '<br>')
    ) 
  )
)

card_tbl_repeat_match_leader_board <- card(
  card_header('HALL OF REPEATED MATCHES'),
  full_screen = TRUE,
  tbl_repeat_match_leaderboard,
  card_footer(
    HTML(
      readLines(paste0('src/repeat-match-leaderboard-description')) |> paste0(collapse = '<br>')
    ) 
  )
)

card_intro <- card(
  card_header('FAM BAM SECRET SANTA'),
  HTML(
    readLines(paste0('src/home-page-intro')) |> paste0(collapse = '<br>')
  ))

card_ask_santa <- card(
  card_header('🎄 FAM BAM SECRET SANTA HAM SECRET SANTA ELF! 🎁'),
  full_screen = TRUE,
  chat_ui("chat", messages = "Hello! I'm the knowledgeable FAM BAM SECRET SANTA HAM secret santa elf here to answer your questions!"),
  card_footer(
    HTML(
      readLines(paste0('src/secret-santa-elf-description')) |> paste0(collapse = '<br>')
    ) 
  )
)

ui <- bslib::page_navbar(
  title = 'FAM BAM SECRET SANTA HAM STATS!',
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
    layout_column_wrap(
      card_intro,
      card_ask_santa
    )
  ),
  nav_panel(
    title = 'STATS',
    layout_column_wrap(
      card_tbl_repeat_match_leader_board,
      card_network,
      card_tbl_repeat_matches
    )
  )
)

server <- function(input, output, session) {
  
  mod_server_vis_network('vis_network', data)
  
  chat <- elmer::chat_openai(system_prompt = read_lines('src/ask-santa-system-prompt') |> paste0(collapse = ' '))
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
  
}

shinyApp(ui, server)