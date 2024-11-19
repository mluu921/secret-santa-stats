
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