
days_until_christmas <- \() {
  ifelse(Sys.Date() < mdy(paste0(12, '-', 25, '-', year(Sys.Date(
  )))),
  as.numeric(mdy(paste0(
    12, '-', 25, '-', year(Sys.Date())
  )) - Sys.Date()),
  mdy(paste0(12, '-', 25, '-', year(Sys.Date(
  )) + 1)) - Sys.Date())
}

nth_annual_secret_santa <- \() {
  
  year(Sys.Date()) - 2014
  
}

generate_text_of_most_frequent_matches <- \(data) {
  
  t <- data |>
    group_by(participants_giver, participants_receiver) |>
    summarise(year = paste0(year, collapse = ', '), n = n(), .groups = 'drop') |>
    filter(n != 1)
  
  number_of_times <- glue::glue_data(
    t,
    '{participants_giver} has given to {participants_receiver}, {n} times ({year})'
  ) |> glue::glue_collapse(sep = '. ', last = ' and ')
  
  most_frequent_giver <- glue::glue_collapse(t$participants_giver, sep = ', ', last = ' and ')
  
  res <- glue::glue('{most_frequent_giver} had the most repeated matches. {number_of_times}.')
  
  res
  
}

create_network_viz <- \(data, link_distance, charge) {
  plot_data <- data |>
    select(i, participants_giver, participants_receiver) |>
    pivot_longer(matches('participants'))
  
  g <- make_graph(edges = plot_data$value, directed = TRUE)
  
  p <- igraph_to_networkD3(g)
  
  p$links$value <- 5
  
  forceNetwork(
    Links = p$links,
    Nodes = p$nodes,
    Source = "source",
    Target = "target",
    NodeID = "name",
    Group = "name",
    Value = "value",
    opacity = .9,
    zoom = TRUE,
    fontSize = 15,
    opacityNoHover = .5,
    charge = charge,
    arrows = TRUE,
    linkDistance = link_distance
  )
}