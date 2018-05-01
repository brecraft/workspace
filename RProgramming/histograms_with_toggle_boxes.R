ebq <- read.csv("ebq200.csv")

#Histogram of conversion values with toggle box for device
device <- as.vector(unique(ebq$user_device_clean))

ebq %>%
  ggvis(~conversion_value) %>% 
    filter(user_device_clean == eval(input_select(
    choices = device,
    selected = "Desktop",
    label = "Device"))) %>%
  layer_histograms(fill := "purple", width =500) %>%
    add_axis("x", grid = FALSE) %>%
    add_axis("x", orient = "top", ticks = 0, title_offset = 20, grid = FALSE,
         title = "Conversion Value by Device",
         properties = axis_props(
           majorTicks = list(strokeWidth = 0),
           axis = list(stroke = "white"),
           title = list(fontSize = 20, fill = '#515151'),
           labels = list(fontSize = 0)
         ))


##Histogram of conversion values with toggle box for device
device <- as.vector(unique(ebq$user_device_clean))

ebq %>%
  ggvis(~conversion_value) %>% 
  filter(user_device_clean == eval(input_select(
    choices = device,
    selected = "Desktop",
    label = "Device"))) %>%
  layer_histograms(fill := "purple", width =500) %>%
  add_axis("x", grid = FALSE) %>%
  add_axis("x", orient = "top", ticks = 0, title_offset = 20, grid = FALSE,
           title = "Conversion Value by Device",
           properties = axis_props(
             majorTicks = list(strokeWidth = 0),
             axis = list(stroke = "white"),
             title = list(fontSize = 20, fill = '#515151'),
             labels = list(fontSize = 0)
           ))





