# MontecarloSimulation

For the analysis of Microsoft stock prices, the base price value is set to the recent closing price, which was $284, and the simulations are run for 4 years with 252 trading days per year to predict the daily closing price. Figure 1 shows a single random walk simulation to analyze Microsoft’s stocks for the next four years that depicts a rising trend in stock prices with max stock price reaching $817.11 by the end of 4th year. However, we cannot base our decision on single iteration, and we need to simulate for many iterations to build confidence interval. 
 
![image](https://user-images.githubusercontent.com/85155952/213886359-4a09bd9f-2a1b-46a5-a179-65ff272979d2.png)

Figure 1: A Single Simulation for 1008 Trading Days

Figure 2 shows Monte Carlo simulation for 300 iterations. It also shows an overall rising trend in stock prices of Microsoft. Of 300 simulations, there are only 16 times when the simulated price is less than the base price i.e., $284 which makes a likelihood of 5.3% of negative ROI and it seems beneficial to invest in Microsoft stocks. 
 
![image](https://user-images.githubusercontent.com/85155952/213886383-7b5a83f9-00a5-4e08-a839-8555189ba8f9.png)
 
Figure. 2: 300 Simulation for Microsoft Stocks for 1008 Trading Days 
 
Figure 3 gives a pictorial representation of maximum, mean, and minimum return values computed from Monte Carlo 300 simulation. Here again Max return values are showing a rising trend. To gain further confidence in our choice of investment the confidence intervals are computed for the stock price at the end of 300 simulations and the following results have been achieved. From Table 1, it is evident that the median daily log return is $617.39 which is also considered as the most likely estimated price and it is almost twice the base price thus investing in Microsoft shares seems promising. 

![image](https://user-images.githubusercontent.com/85155952/213886396-adb1638d-243c-438f-94f3-f3b1f34030be.png)

Figure. 3: Summarized Stock Price Returns for 1008 Trading Days 
 
0% 	25% 	50% 	75% 	100% 
$93.11 	$458.75 	$617.39 	$873.06 	$2336.53 
Table 1. Confidence Interval 

Q. Suggest your favourite trading strategy and provide an intuitive motivation for your strategy. Code you rule and assess your strategy (with respect to the risk that you take) using the Monte Carlo simulation 

The answer to this question involves three different methods where we explore and compare Microsoft stocks with stock prices of other stakeholders. First using random walk, Microsoft stocks prices are compared with others. Secondly, we have developed a portfolio and compared its returns with Microsoft stock returns to explore which one will perform well. Lastly, we run Monte Carlo simulations for 300 iterations for each stockholder and compared their quantiles results. 
From question number 6 we found that Microsoft stock prices are rising both in random walk single simulation and Monte Carlo 300 simulations, so it gives us an intuitive idea to explore how other companies are performing in comparison to Microsoft by simulating a random walk. Figure 4 gives a pictorial representation of this comparison and Figure 5 gives tabular representation of achieved results. 

![image](https://user-images.githubusercontent.com/85155952/213886476-4f80c8b4-24e8-48fe-ba55-fcd6c05b7b33.png)

Figure.4: Microsoft Vs Intel, Apple, Coca-Cola and Walmart 

![image](https://user-images.githubusercontent.com/85155952/213886483-71e61f43-b0f8-4ddf-b674-13ee5c5ca81a.png)

Figure. 5: Tabular Representation 

The result from above simulation confirms our choice of selection as the predicted price for Microsoft is greater than base price as well as relatively greater than predicted price of other stakeholders, however it is important to dig deep down to better analyze our achieved results. For this purpose, a portfolio is created with 75% of AAPL and 25% of Coca-Cola. The portfolio is created keeping in mind the correlation between stocks, considering stocks with weak correlation like AAPL and KO has weak correlation as well as log mean and log standard deviation values for respective stakeholders as the mean value characterizes the ROI and standard deviation refers to likelihood of risk. The comparison of Microsoft as benchmark and our developed portfolio for daily log returns leads to the results shown in Figure 6.

![image](https://user-images.githubusercontent.com/85155952/213886497-0c2047c4-e8b4-4318-8e5a-eee0b31704bd.png)

Figure. 6: Portfolio vs Microsoft 

The above comparison is based on historical data, and it reveals that our developed portfolio is offering more promising returns than Microsoft stocks as it shows how $1 invested in our portfolio in 2010 would have grown over time. 

Apart from portfolio analysis, we have also conducted Monte Carlo simulations individually for all stocks and computed quantile results for defined probability distributions. The analysis of results given in Figure 7 reveals that likelihood of getting ROI for Microsoft is higher, though in best case scenario the End Stock Price (ESP) for Microsoft and Apple are pretty much close as compared to ESP values of other stockholders, however the median value which is also called the most likely value of MSFT is greater than AAPL. 

![image](https://user-images.githubusercontent.com/85155952/213886515-0d8c14f6-e2b7-4a6b-8d5f-c60810e7e73e.png)

Figure. 7: Confidence Intervals For 5 Companies 

Conclusion: 
In real world businesses, not one statistical method can ensure risk free investment with maximum returns, however using different approaches we can come up with a decision that can offer possible minimal risk and greater returns. From the above analysis, we have come to a decision to stick with investing in Microsoft stocks as the likelihood of getting higher returns is relatively greater.     

