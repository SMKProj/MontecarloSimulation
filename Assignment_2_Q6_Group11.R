library(quantmod)
library(stringr)
library(corrplot)
library(PerformanceAnalytics)
library(ggplot2)
library(tidyverse)

getSymbols("MSFT",from="2009-10-01",to="2021-09-30",src="yahoo") # Microsoft 
MSFT_log_returns<-dailyReturn(MSFT,type='log')
MSFT_mean_log<-mean(MSFT_log_returns)
MSFT_sd_log<-sd(MSFT_log_returns)


# 6. Simulate for the next 4 years the stock prices of Microsoft Corporation 
# using Monte Carlo (300 Monte Carlo simulations). Will you buy Microsoft's stock and why?

N     <- 252*4 
M     <- 300  # Number of Monte Carlo Simulations   
mu    <- MSFT_mean_log
sigma <- MSFT_sd_log
day <- 1:N

#most recent colsing price
price_init <- as.numeric(MSFT[(dim(MSFT))[1],4])

price  <- c(price_init, rep(NA, N-1))
for(i in 2:N) {
  price[i] <- price[i-1] * exp(rnorm(1, mu, sigma))
}

price_sim <- cbind(day, price) %>%
  as_tibble() 

end_stk_price <- price_sim %>% 
  filter(day == max(day))

endpris = as.character(round(end_stk_price[2],2))

price_sim %>%
  ggplot(aes(day, price)) +
  geom_text(label = paste('Base Price: ', price[1], sep=''),
            x = min(day),
            y = price[1],
            size = 3,
            color = 'red') + 
  geom_line() +
  geom_text(label = paste('End Price: ', endpris, sep=''),
            x = max(day),
            y = max(price), 
            size = 3,
            color = 'blue')+
  ggtitle(str_c("Simulated Prices for Microsoft in ", N," Trading Days"))


#-----300 Simulations

# Simulate prices
monte_carlo_mat <- matrix(nrow = N, ncol = M)
for (j in 1:M) {
  monte_carlo_mat[[1, j]] <- price_init
  for(i in 2:N) {
    monte_carlo_mat[[i, j]] <- monte_carlo_mat[[i - 1, j]] * exp(rnorm(1, mu, sigma))
  }
}

price_sim_300 <- cbind(day, monte_carlo_mat) %>%
  as_tibble() 
nm <- str_c("Sim.", seq(1, M))
nm <- c("Day", nm)
names(price_sim_300) <- nm
price_sim_300 <- price_sim_300 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))
# Visualize simulation
price_sim_300 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Prices Over ", N, 
                " Trading Days"))

# Using quantile to get confidence intervals for the stock price at the end of the simulation
end_stock_prices <- price_sim_300 %>% 
  filter(Day == max(Day))
probs <- c(0, .25, .5, .75, 1)

dist_end_stock_prices <- quantile(end_stock_prices$Stock.Price, probs = probs)
dist_end_stock_prices %>% round(2)

#---Calculating Occurrences of negative ROI (When predicted price < base price)-----
negative_ROI <- end_stock_prices %>%
  count(end_stock_prices[3] < 284)

#----------------Summarized values-----------------------

summary_val <- price_sim_300 %>%
  group_by(Day) %>%
  summarise(mean_return=mean(Stock.Price), max_return=max(Stock.Price), min_return=min(Stock.Price)) %>%
  gather("Simulation", "Stock.Price", -Day)

summary_val %>%
  ggplot(aes(x=Day, y=Stock.Price)) +
  geom_line(aes(color=Simulation)) +
  ggtitle("Return Values from Simulation")
