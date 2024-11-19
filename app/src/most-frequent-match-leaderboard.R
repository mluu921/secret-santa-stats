board <- pins::board_folder('app/board')

data <- pins::pin_read(board, 'processed-data')

t <- data |>
  group_by(participants_giver, participants_receiver) |>
  reframe(year = year, n = n()) |>
  filter(n != 1) |> 
  group_by(participants_giver, participants_receiver, n) |> 
  summarise(year = glue::glue_collapse(year, sep = ', ', last = ' and ' ), .groups = 'drop')

generate_match_stories_with_emojis <- function(data) {
  # Ensure the data has the required columns
  if (!all(c("participants_giver", "participants_receiver", "year", "n") %in% colnames(data))) {
    stop("Data must contain 'participants_giver', 'participants_receiver', 'year', and 'n' columns.")
  }
  
  # Define random connectors with emojis for variety
  connectors <- c(
    "🎁 spread holiday cheer to 🎄", 
    "✨ thoughtfully picked gifts for 🎅", 
    "🎉 was the Secret Santa for 🎁", 
    "💫 brightened the holidays of ✨", 
    "🛷 delivered surprises to 🎁"
  )
  
  # Generate a story for each row
  stories <- data %>%
    dplyr::mutate(
      story = purrr::map_chr(1:nrow(data), function(i) {
        connector <- sample(connectors, 1)
        paste0(
          "✨ ", participants_giver[i], " ", connector, " ", participants_receiver[i], 
          " in ", year[i], " (🎄 ", n[i], " matches)!"
        )
      })
    ) %>%
    dplyr::pull(story)
  
  return(stories)
}

set.seed(123)  # For reproducibility
results <- generate_match_stories_with_emojis(t)

out <- results |> 
  as_tibble() |> 
  gt() |> 
  cols_label(value = 'LEADER BOARD')

pins::pin_write(board, out, 'tbl-repeat-match-leaderboard', type = 'rds')