library(arcadiathemeR)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(reshape2)
library(cowplot)

prepare_summary <-
  function(df, remove_na_arch = c("Unknown", "NA"),
           exclude_year = 2022, architectures_levels) {
    summary_base <- df %>%
      mutate(`Neural Network` =
               str_replace_all(`Neural Network`, "-", ", ")) %>%
      separate_rows(`Neural Network`, sep = ",\\s*") %>%
      mutate(`Neural Network` =
               str_trim(`Neural Network`),
             `Neural Network` = if_else(`Neural Network` == "" |
                                          is.na(`Neural Network`),
                                        "NA", `Neural Network`)) %>%
      count(Year, `Neural Network`, name = "nn_count") %>%
      pivot_wider(names_from  = `Neural Network`,
                  values_from = nn_count, values_fill = 0) %>%
      mutate(Total = rowSums(select(., -Year))) %>%
      relocate(Total, .after = Year) %>%
      arrange(Year)

    summary_breakdown <-
      melt(na.omit(summary_base[, -2]), id.vars = "Year",
           variable.name = "Architecture", value.name = "Count")

    summary_breakdown <- summary_breakdown %>%
      filter(!Architecture %in% remove_na_arch, Year != exclude_year) %>%
      mutate(Architecture = factor(Architecture,
                                   levels = architectures_levels)) %>%
      droplevels()

    all_years <- seq(min(summary_breakdown$Year), max(summary_breakdown$Year))

    summary_breakdown %>%
      complete(Year = all_years, Architecture, fill = list(Count = 0)) %>%
      mutate(Year = factor(Year, levels = all_years))
  }

plot_pub <- function(data) {
  plot_a <-
    ggplot(data, aes(x = Year, y = Count, fill = Architecture)) +
    geom_col(width = 0.85) +
    scale_x_discrete(breaks = c(1992, 2000, 2010, 2020)) +
    scale_fill_arcadia(palette_name = "primary") +
    theme_arcadia(background = TRUE) +
    labs(y = "Count of Publications", x = "Year") +
    theme(legend.position = "none")

  plot_b <-
    ggplot(data, aes(x = Year, y = Count, color = Architecture,
                     group = Architecture)) +
    geom_line(linewidth = 2) +
    scale_x_discrete(breaks = c(1992, 2000, 2010, 2020)) +
    scale_color_arcadia(palette_name = "primary") +
    theme_arcadia() +
    labs(y = "Count of Publications", x = "Year")

  combined_plot <- plot_grid(plot_a, plot_b + theme(legend.position = "none"))
  plot_grid(combined_plot, get_legend(plot_b), rel_widths = c(1, 0.1))
}

###############################################################################
# Now, read in the lit review from Borowiec et al., 2022 and plot.            #
# https://doi.org/10.1111/2041-210X.13901                                     #
###############################################################################
lit <-
  read_tsv("mee313901-sup-0001-supinfo.txt", col_select = 1:13)

pub_plot <- lit %>%
  prepare_summary(architectures_levels = c("DNN", "CNN", "RNN", "VAE",
                                           "GAN", "Other", "NA",
                                           "Unknown")) %>%
  plot_pub()

molec_pub_plot <- lit %>%
  filter(`Data Collected` == "Molecular") %>%
  prepare_summary(remove_na_arch = c("Unknown", "NA"),
                  architectures_levels = c("DNN", "CNN", "RNN",
                                           "VAE", "GAN", "Other",
                                           "Unknown")) %>%
  plot_pub()

comb_pub_plot <-
  plot_grid(pub_plot, molec_pub_plot, align = "v",
            rel_heights = c(1, 1), ncol = 1)

ggsave(comb_pub_plot, height = 20, width = 18,
       file = "neural_network_evo_all_molec_pub_counts.pdf")
