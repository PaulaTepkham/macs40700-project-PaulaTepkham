# Final Project
Phornchanok (Paula) Tepkham\(Feb 3, 2025)
---

# Thailand’s International Trade Development 
International trade plays a crucial role in a country's economic development and stability. However, it is also susceptible to external shocks, such as economic recessions in key trading partners, fluctuations in global commodity prices, and supply chain disruptions. A country that relies heavily on a narrow range of exports and import sources may face increased risks, including job losses, price volatility, and economic instability. In this analysis, I will explore Thailand’s International Trade Position. 

### Working RMarkdown: [Assignment 3 RMarkdown](assignment3_PaulaTepkham.Rmd)
### Result file (Please use this file for interactive plots): [Assignment 3 html](assignment3_PaulaTepkham.html) 

# Data Source: 
1) [World Development Indicators, DataBank](https://databank.worldbank.org/source/world-development-indicators)
2) [UN Comtrade](https://comtradeplus.un.org)

| Sources      | Indicators      | Timeline      |
|---------------|---------------|---------------|
| World Development Indicators, DataBank | GDP (constant 2015 US$) | 1960-2023 |
|  | GDP per capita (constant 2015 US$) |  |
|  | Trade (% of GDP) |  |
|  | Exports of goods and services (constant 2015 US$) |  |
|  | Imports of goods and services (constant 2015 US$) |  |
| UN Comtrade | to be updated | to be updated |

## Part 1 How has Thailand’s trade dependency and export structure evolved from 1960 to 2023 compared to Other Countries?
### Figure 1.1 (Draft plot) Scatterplot of Trade Dependency and GDP Per Capita, 2023 
![Figure 1.1 Thailand Trade Dependency and GDP Per Capita, 2023](img/figure_1_1_2023.png)

### Figure 1.2 (Final plot) Animated Scatterplot of Trade Dependency and GDP Per Capita, 1960-2023 
(please click the picture to see animation)
[![Figure 1.2 Thailand Trade Dependency and GDP Per Capita, 1960-2023](https://i.imgur.com/nZZsPyf.gif)](https://imgur.com/nZZsPyf)

### Figure 1.3 (Alternative plot) Dumbell plots of Trade Dependency by Income Group, 1960 and 2023
![Figure 1.3 Trade Dependency by Income Group, 1960 and 2023](img/figure_1_3.png)

### Figure 1.4 (Alternative plot 2) Map of Trade Dependency, 2023
![Figure 1.4 Map Trade Dependency, 2023](img/figure_1_4.png)

#### Analysis: Describe the plot type you selected and what it tells us about the data.

The Thailand Trade Dependency and GDP Per Capita scatterplot animation (figure 1.2) effectively highlights Thailand's economic transformation over the past six decades. Thailand's economic exposure to international trade has increased significantly, shifting from being a net importer to a net exporter. According to figure 1.2, trade dependency, measured as the ratio of exports and imports to GDP, rose dramatically from 34% in 1960 to 130% in 2023. This substantial increase underscores Thailand’s deepening integration into global trade networks.

One key advantage of using a scatterplot in this analysis is that it allows us to observe the relationship between trade dependency and GDP per capita, which serves as a proxy for economic growth. The figure clearly demonstrates a positive correlation between GDP per capita and trade dependency. Higher-income countries tend to have greater exposure to international trade. Additionally, the visualization captures the broader impact of globalization, revealing that most countries have become increasingly reliant on international trade over time.

An especially noteworthy insight from the animation is Thailand’s shift in trade balance. Before 1997, Thailand was predominantly a net importer, but following the Asian financial crisis, the country transitioned to a net exporter. This shift likely reflects structural changes in Thailand’s economy, including trade policy adjustments, currency devaluation, and increased export competitiveness.

#### Analysis: describe the plot you chose, alternatives you considered, and why this was the selected form

Overall, animated scatter plot (Figure 1.2: Final Scatterplot of Trade Dependency and GDP Per Capita, 1960-2023) effectively showcases Thailand’s long-term trade transformation. The animation allows users to observe historical trends, identify key shifts (e.g., Thailand’s transition from a net importer to a net exporter post-1997), and compare Thailand to other countries over time. In Figure 1.1 (Trade Dependency and GDP Per Capita, 2023), a static scatter plot captures the relationship for a single year (2023). Each country is represented by a point, with the x-axis displaying GDP per capita (log-transformed) and the y-axis representing trade dependency. The color gradient reflects net trade balance (surplus or deficit), helping to differentiate between net exporters and net importers. It represents a single year of data, making it unable to capture long-term changes. Additionally, Figure 1.1 displays all country labels, which can make it harder to distinguish Thailand within the plot. While figure 1.3 is faceted before-and-after comparison (1960 vs. 2023) of trade dependency across income groups. It uses lines to connect country-level trade dependency changes over time.

### **Comparison of Trade Dependency Figures**

| **Figure**   | **Type**                               | **Time Coverage**   | **Focus**                                    | **Strengths**                                     | **Limitations**                                  |
|-------------|----------------------------------------|---------------------|----------------------------------------------|--------------------------------------------------|-------------------------------------------------|
| **Figure 1.1 Draft plot** | Scatter plot                         | 2023 (single year)  | Trade dependency vs. GDP per capita         | Snapshot view, easy to interpret                 | No historical comparison                        |
| **Figure 1.2 Final plot** | Animated scatter plot               | 1960-2023 (animated) | Evolution of trade dependency over time     | Shows trends, highlights country transitions     | May be harder to interpret long-term patterns   |
| **Figure 1.3 Alternative plot** | Faceted before-and-after comparison | 1960 vs. 2023       | Trade dependency changes by income group    | Clear within-group patterns, easy comparison    | Does not show correlation with GDP per capita  |

---

#### Analysis: describe the customizations (scales, labels, colors, titles, etc.) that you made to improve the graph from the original baseline
To improve the clarity, interpretability, and aesthetics of the graph, I made several modifications. Since GDP per capita varies significantly across countries, I applied a log transformation to make differences more interpretable and prevent smaller economies from being overshadowed by wealthier ones. Color Encoding for Trade Balance helps highlight Thailand’s shift from a net importer to a net exporter, particularly after the 1997 Asian Financial Crisis. The animation allows users to observe trade dependency trends over six decades, making the evolution of trade engagement and economic growth more intuitive. In Figure 1.1 (static plot), country names are labeled on each data point, which can clutter the visualization.
In Figure 1.2 (animated plot), Thailand is emphasized with a larger marker and text annotations displaying its trade dependency, GDP per capita, and net export values, making it easier to track changes. X-Axis is GDP Per Capita, Log Scale to ensures a balanced view across high-and low-income countries. Y-Axis is Trade Dependency % of GDP, which adjusted to a 0–500% range for consistency across years. The hover text includes specific country details (GDP per capita, trade dependency, and net exports). Last, An animation slider enables users to navigate through different years to examine trends dynamically.

#### Assessment:
While both figures are truthful, Figure 1.2 is comparatively more functional, aesthetically effective, insightful, and enlightening. The animation format highlights Thailand’s position dynamically over time. Furthermore, the figure enhances readability by providing clear textual descriptions of Thailand’s trade dependency ratio, GDP per capita, and net export values for each year. To further improve the depth and clarity of the analysis, incorporating historical event markers—such as the 1997 Asian financial crisis and major trade agreements—would provide additional context to explain significant shifts in Thailand’s trade patterns. This addition would make the visualization even more informative and valuable for economic analysis.

---

## Part 2 How has Thailand’s Export and Import Grown? Exploring Thailand’s transition from a net importer to a net exporter post-1997. 
### Figure 2.1 (Draft plot) Line plot of Thailand Export and Import, 1960-2023
![Figure 2.1 Thailand Export and Import, 1960-2023](img/figure_2_1.png)

### Figure 2.2 (Final plot) Filled plot of Thailand Export, Import, and Net Exports, 1960-2023
![Figure 2.2 Thailand Export, Import, and Net Exports, 1960-2023](img/figure_2_2.png)

### Figure 2.3 (Alternative plot) Line plot of Thailand Export and Import Growth, 1960-2023
![Figure 2.3 Thailand Export and Import Growth (%), 1960-2023](img/figure_2_3.png)

#### Analysis: Describe the plot type you selected and what it tells us about the data.

The figure 2.2 is a stacked area chart combined with a line plot to visualize Thailand’s exports, imports, and net exports from 1960 to 2023. This figure effectively shows both the absolute trade values and the transition from a net importer to a net exporter. Additionally, a vertical dashed line and annotation highlight the 1997 Asian Financial Crisis, marking a key turning point in Thailand’s trade history.

#### Analysis: Describe the plot you chose, alternatives you considered, and why this was the selected form

Figure 2.2 is the best choice for analyzing Thailand’s long-term trade dynamics and the 1997 transition. Unlike Figure 2.1 (which only shows absolute values), Figure 2.2 also plots Net Exports, making it easier to see when Thailand became a net exporter. The stacked area approach allows us to observe how trade composition evolved, while the net export line highlights the trade balance over time. The 1997 Asian Financial Crisis is annotated, helping explain the sharp drop in imports.

### Comparison of Trade Visualizations

| **Figure**  | **Plot Type** | **Focus** | **Strengths** | **Limitations** |
|-------------|--------------|-----------|---------------|-----------------|
| **Figure 2.1** | **Line Chart** | Trade values of **exports and imports** | Simple and clear visualization of absolute trade trends | Does not show net export trends or the shift from a trade deficit to surplus |
| **Figure 2.2** | **Stacked Area Chart with Net Export Line** | **Trade values and trade balance** | Clearly shows the **cumulative relationship** between exports and imports, highlighting the **transition post-1997** | Harder to compare **year-over-year growth rates** |
| **Figure 2.3** | **Growth Rate Line Chart** | **Export & import percentage growth** | Captures **volatility and fluctuations** in trade expansion, useful for understanding trade shocks | Does not show absolute trade values or net exports |


#### Analysis: Describe the customizations (scales, labels, colors, titles, etc.) that you made to improve the graph from the original baseline

To improve the original baseline graph (figure 2.1), several customizations were applied to enhance clarity, readability, and analytical depth in figure 2.2. First, the title and axis labels were refined to clearly define the chart’s purpose, with "Thailand’s Export, Import & Net Export (1960-2023)" as the title and appropriate labels for both axes. The grid lines were removed (showgrid = FALSE) to reduce visual clutter and improve focus on the data. To distinguish between different trade components, color coding was implemented, with exports in dark blue, imports in dark orange, and net exports as a bold black line, ensuring clear differentiation. Transparency (rgba(..., 0.5)) was also applied to the stacked areas, allowing visibility without overlap confusion. Additionally, A vertical dashed line was added at 1997, marking the Asian Financial Crisis as a pivotal moment in trade history. Additionally, an annotation box with an arrow provides context, stating "<b>Asian Financial Crisis 1997</b> Sharp decline in import", ensuring that users can quickly identify the impact of this economic event. To further enhance insights, trade dependency (trade_dep) was plotted as purple dots, making it easy to track Thailand’s increasing reliance on international trade over time. For interactivity, hover mode was updated to "x unified", allowing users to compare all trade values for a given year in one tooltip, avoiding confusion. The legend was repositioned (x=0.1, y=0.9) to prevent it from covering the data. These changes collectively transform the graph from a basic trade visualization into a comprehensive economic analysis, making it easier to interpret Thailand’s historical trade shifts, major economic events, and long-term growth trends.

#### Assessment: Is it truthful?, functional?, beautiful?, insightful?, enlightening?

The visualization is truthful, accurately depicting Thailand’s export, import, and net export trends while aligning with historical events like the 1997 Asian Financial Crisis. It is functional, with a clear layout, well-positioned legend, and interactive hover mode for easy interpretation. The color scheme and transparency enhance readability, making it visually appealing. It is insightful, highlighting Thailand’s shift from a net importer to a net exporter, with the net export line clearly marking this transition. Finally, it is enlightening, providing a deeper understanding of how economic shocks and trade policies shaped Thailand’s trade balance over time.

---
## Comment for Assignment 3: 
You did a great job on the submissions / making things work. The comparison table is excellent.

It is clear that you worked very hard on your plot 1. However, the x axis needs to be more clearly labeled (recall how we talked about converting from log to displaying values). I like the idea of the animation, but you get little information about the other states. We will do an animation segment later and you can revisit this then. In the meantime, I think plot 1 would have worked better. make the points larger and maybe try gglabel to get it a little clearer.

alternative plots: the graphical setup is nice, but I would reverse the coloring.

plot 2: this is stronger than the first plots. I would suggest using area under the curves of 'net exports'. it reads as a bit odd otherwise. the line you have with the text is nice. I would probably use a charcoal instead of black.
---

# Final Project Proposal 
1) Alternating plot 1 to make it more clear.
2) Create a website that reader can choose the country that they need to highlight it.
3) Change the color of plot 2. 



References:
- https://bookdown.org/pbaumgartner/gdswr-notes/91-creating-maps.html
- https://macs40700.netlify.app/slides/10-plotly/?panelset_001=dumbell-plots#11
- https://plotly.com/r/animations/
