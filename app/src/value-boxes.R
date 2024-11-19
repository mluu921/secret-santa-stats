vb_days_till_christmas <- bslib::value_box(
  title = 'DAYS UNTIL CHRISTMAS',
  value = days_until_christmas(),
  theme = value_box_theme(bg = '#D50032'),
  showcase = fa('sleigh', height = '50px')
)

vb_nth_annual <- bslib::value_box(
  title = 'NTH ANNUAL SECRET SANTA',
  value = nth_annual_secret_santa(),
  theme = value_box_theme(bg = '#1B5E20'),
  showcase = fa('gifts', height = '50px')
)

vb_ss_since <- bslib::value_box(
  title = 'SECRET SANTA SINCE',
  value = 2014,
  theme = value_box_theme(bg = '#FFFFFF'),
  showcase = fa('candy-cane', height = '50px')
)

vb_gifts_exchanged <- bslib::value_box(
  title = 'GIFTS EXCHANGED TO DATE',
  value = 50,
  theme = value_box_theme(bg = '#FFD700'),
  showcase = fa('champagne-glasses', height = '50px')
)