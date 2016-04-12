library(dplyr)

.lut = rainbow(100, start=rgb2hsv(col2rgb('red'))[1], end=rgb2hsv(col2rgb('yellow'))[1])
.col =
      .lut %>%
      col2rgb %>% t %>% as.data.frame %>%
      mutate(rank = as.integer(1:n())) %>%
      bind_rows(data.frame(red=0, green=0, blue=0, rank=0))

#########
lut = heat.colors(100)
color.bar(lut, 0, 4, title='-log(p)', nticks=5, cex=4)
