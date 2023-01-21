library(quantmod)
library(stringr)
library(corrplot)
library(PerformanceAnalytics)
library(ggplot2)
library(tidyverse)
library(rvest)
library(lubridate)
library(dplyr)
library(dygraphs)


# -------------- Random walk Simulation for MSFT vs ALL----------------------
start = as.Date("2009-10-01") 
end = as.Date("2021-09-30")
getSymbols(c("MSFT","INTC","AAPL", "KO", "WMT"), src = "yahoo", from = start, to = end)

#Stock returns in log
MSFT_log_returns<-dailyReturn(MSFT,type='log')
INTC_log_returns<-dailyReturn(INTC,type='log')
AAPL_log_returns<-dailyReturn(AAPL,type='log')
KO_log_returns<-dailyReturn(KO,type='log')
WMT_log_returns<-dailyReturn(WMT,type='log')

#Mean of log stock returns 
MSFT_mean_log<-mean(MSFT_log_returns,na.rm=TRUE)
INTC_mean_log<-mean(INTC_log_returns,na.rm=TRUE)
AAPL_mean_log<-mean(AAPL_log_returns,na.rm=TRUE)
KO_mean_log<-mean(KO_log_returns,na.rm=TRUE)
WMT_mean_log<-mean(WMT_log_returns,na.rm=TRUE)

MSFT_sd_log<-sd(MSFT_log_returns,na.rm=TRUE)
INTC_sd_log<-sd(INTC_log_returns,na.rm=TRUE)
AAPL_sd_log<-sd(AAPL_log_returns,na.rm=TRUE)
KO_sd_log<-sd(KO_log_returns,na.rm=TRUE)
WMT_sd_log<-sd(WMT_log_returns,na.rm=TRUE)

closing_price = c(as.numeric(MSFT[(dim(MSFT))[1],4]),as.numeric(INTC[(dim(INTC))[1],4]), 
                  as.numeric(AAPL[(dim(AAPL))[1],4]), as.numeric(KO[(dim(KO))[1],4]), as.numeric(WMT[(dim(WMT))[1],4]))

df <- data.frame(
  Companies = c('MSFT','INTC','AAPL','KO','WMT'),
  MeanLog = c(MSFT_mean_log,INTC_mean_log,AAPL_mean_log,KO_mean_log,WMT_mean_log),
  SD_Log = c(MSFT_sd_log, INTC_sd_log, AAPL_sd_log, KO_sd_log, WMT_sd_log),
  ClosingPrice = closing_price)


N     <- 252*4 
day <- 1:N
M<- 300  # Number of Monte Carlo Simulations  

comp <- dim(df)[1]
for (d in 1:comp)
{
  mu <- df[d,2]
  sigma <- df[d,3]
  
  
  price_init <- as.numeric(df[d,4])
  price_init
  price  <- c(price_init, rep(NA, N-1))
  for(i in 2:N) {
    price[i] <- price[i-1] * exp(rnorm(1, mu, sigma))
  }
  
  assign(paste0("price_",d),price )
  assign(paste0 ('priceSim_',d),cbind(day,price)%>% as_tibble())
  
}

#----------------------------

endStk_MSFT<- priceSim_1 %>% 
  filter(day == max(day))
endStk_INTC<- priceSim_2 %>% 
  filter(day == max(day))
endStk_APPL<- priceSim_3 %>% 
  filter(day == max(day))
endStk_KO<- priceSim_4 %>% 
  filter(day == max(day))
endStk_WMT<- priceSim_5 %>% 
  filter(day == max(day))

endStocksPrice <- rbind(endStk_MSFT[2], endStk_INTC[2], endStk_APPL[2], endStk_KO[2], endStk_WMT[2])

df['PredictedPrice'] <- endStocksPrice
newdf <- cbind(day, price_1,price_2,price_3, price_4, price_5)
newdf <- as.data.frame(newdf)
names <- c('Days', 'MSFT', 'INTC', 'APPL', 'KO', 'WMT')
newdf <- set_names(newdf,names)

df_reshaped <- data.frame(days = newdf$Days,                           
                          price = c(newdf$MSFT, newdf$INTC, newdf$APPL,newdf$KO,newdf$WMT),
                          companies = c(rep("MSFT", nrow(newdf)),
                                        rep("INTC", nrow(newdf)),
                                        rep("APPL", nrow(newdf)),
                                        rep("KO", nrow(newdf)),
                                        rep("WMT", nrow(newdf))))
ggplot(df_reshaped, aes(days, price, col = companies)) + 
  geom_line() +
  ggtitle(str_c("Simulated Prices for ", N," Trading Days"))

# --------------Portfolio Analysis ----------------------------------------
daily_returns <-function (ticker,start_date,end_date)
{
  stock <- getSymbols(ticker, src = 'yahoo', auto.assign = FALSE,from = start_date, to = end_date)
  stock <- na.omit(stock)
  # keeping one Adjusted stock prices
  stock <- stock[,6]
  
  # calculate log returns
  data <- na.omit(Return.calculate(stock, method = 'log'))
  assign(ticker,data, envir = .GlobalEnv)
  
}

daily_returns('MSFT', "2009-10-01", "2021-09-30")
daily_returns('AAPL', "2009-10-01", "2021-09-30")
daily_returns('KO', "2009-10-01", "2021-09-30")

returns <- merge.xts(MSFT,AAPL,KO)
colnames(returns) <- c('MSFT', 'AAPL', 'KO')

dygraph(returns, main = 'Microsoft vs Apple vs CocaCola') %>%
  dyAxis('y', label = 'Return' )%>%
  dyRangeSelector(dateWindow = c("2009-10-01", "2021-09-30")) %>%
  dyOptions(colors = RColorBrewer :: brewer.pal(4,'Set2'))

round(tail(returns,n=5),4)

# defining weights
wts <- c(0.75,0.25)
portfolio_returns <-Return.portfolio(R=returns[,2:3], weights = wts, wealth.index = TRUE)
benchmark_returns <- Return.portfolio(R=returns[,1], wealth.index = TRUE)

comp <- merge.xts(portfolio_returns, benchmark_returns)
colnames(comp) <- c('Portfolio', 'Benchmark')

dygraph(comp, main = 'Portfolio Performance vs Benchmark')%>%
  dyAxis('y', label = 'Amount ($)')


#----------------------Quantile Analysis-----------------------------------

N     <- 252*4 
day <- 1:N
M<- 300  # Number of Monte Carlo Simulations   

comp <- dim(df)[1]
for (d in 1:comp)
{
  mu <- df[d,2]
  sigma <- df[d,3]
  
  price_init <- as.numeric(df[d,4])
  monte_carlo_mat <- matrix(nrow = N, ncol = M)
  for (j in 1:M) {
    monte_carlo_mat[[1, j]] <- price_init
    for(i in 2:N) {
      monte_carlo_mat[[i, j]] <- monte_carlo_mat[[i - 1, j]] * exp(rnorm(1, mu, sigma))
    }
  }
  
  #assign(paste0("price_",d),price )
  assign(paste0 ('price_sim',d),cbind(day,monte_carlo_mat)%>% as_tibble())
}
nm <- str_c("Sim.", seq(1, M))
nm <- c("Day", nm)
names(price_sim1) <- nm
names(price_sim2) <- nm
names(price_sim3) <- nm
names(price_sim4) <- nm
names(price_sim5) <- nm
price_sim1 <- price_sim1 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))

price_sim2 <- price_sim2 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))
price_sim3 <- price_sim3 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))
price_sim4 <- price_sim4 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))
price_sim5 <- price_sim5 %>%
  gather(key = "Simulation", value = "Stock.Price", -(Day))
# Visualize simulation
price_sim1 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Microsoft Prices Over ", N, 
                " Trading Days"))
price_sim2 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Intel Prices Over ", N, 
                " Trading Days"))
price_sim3 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Apple Prices Over ", N, 
                " Trading Days"))
price_sim4 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Cocacola Prices Over ", N, 
                " Trading Days"))
price_sim5 %>%
  ggplot(aes(x = Day, y = Stock.Price, Group = Simulation)) + 
  geom_line(alpha = 0.1) +
  ggtitle(str_c(M, 
                " Monte Carlo Simulations for Walmart Prices Over ", N, 
                " Trading Days"))

probs <- c(0, .25, .5, .75, 1)

end_stock_prices_MSFT <- price_sim1 %>% 
  filter(Day == max(Day))
ESP_MSFT <- quantile(end_stock_prices_MSFT$Stock.Price, probs = probs)
ESP_MSFT %>% round(2)

end_stock_prices_INTC <- price_sim2 %>% 
  filter(Day == max(Day))
ESP_INTC <- quantile(end_stock_prices_INTC$Stock.Price, probs = probs)
ESP_INTC %>% round(2)

end_stock_prices_AAPL <- price_sim3 %>% 
  filter(Day == max(Day))
ESP_AAPL <- quantile(end_stock_prices_AAPL$Stock.Price, probs = probs)
ESP_AAPL %>% round(2)

end_stock_prices_KO <- price_sim4 %>% 
  filter(Day == max(Day))
ESP_KO <- quantile(end_stock_prices_KO$Stock.Price, probs = probs)
ESP_KO %>% round(2)

end_stock_prices_WMT <- price_sim5 %>% 
  filter(Day == max(Day))
ESP_WMT <- quantile(end_stock_prices_WMT$Stock.Price, probs = probs)
ESP_WMT %>% round(2)

ESP <- rbind(ESP_MSFT,ESP_INTC,ESP_AAPL,ESP_KO,ESP_WMT)
View(ESP)