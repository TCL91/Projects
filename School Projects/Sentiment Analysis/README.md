# Mental Health in the Tech Field 2016

(INSERT LINK IF Applicable)

## Introduction to the Project
This project explores how sentiment analysis is helpful in various types of organizations. retail (Amazon), healthcare, and education are the three areas this paper will explore, but the techniques and results can be used in other areas. With the growth of social media and online presence, people are expressing their opinions daily. Sentiment analysis can help determine whether something is negative, neutral, or positive right away and not have to read every single review or tweet. Using an amazon dataset and gathering tweets using the Twitter API, I conducted sentiment analysis using the VADER (Valence Aware Dictionary for sEntiment Reasoning) and RoBERTa (Robustly Optimized BERT Pre-training Approach) methods and then compared them. The comparison results were largely the same, with the RoBERTa method being more accurate due to being a more powerful tool. Overall, the results will help show that organizations should utilize sentiment analysis to have a better relationship with their customers or clients.

## Table of Contents

- [About the Dataset](#about-the-dataset)
- [Notebook Navigation](#notebook-navigation)
- [My Approach to Solve this Problem](#my-approach-to-solve-this-problem)
- [Technical Approach in This Project](#technical-approach-in-this-project)
- [Limitations of Analysis](#limitations-of-analysis)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)
- [Key Takeaways](#key-takeaways)
- [Business Recommendation](#business-recommendation)
- [Next Step](#next-step)
- [References](#references)

## About the Dataset
- This project uses 3 different datasets Prime Pantry, Healthcare tweets, and Education Tweets.
- Prime Pantry 
    - This dataset contains mental health related information in the tech industy in 2016
    - There are ??? observations and ??? features, with each row being a different person.
    - After adding some features, it now has ?? features.
    - You can find the Prime Pantry data publicly available here under the "Small" subsets for experimentation 5-core: [[Prime Pantry]](https://cseweb.ucsd.edu/~jmcauley/datasets/amazon_v2/)
Healthcare Tweets
    - This dataset contains tweets with the hashtag #healthcare using a Twitter API
    - There are ??? observations and ??? features, with each row being a differnt person.
    - After removing some observation through cleaning, it now has ??? observations.
    - You can find the Healthcare Tweets data publicly available here under my data folder on my Github: [[Healthcare Tweets]](INSERT LINK)
Education
    - This dataset contains This dataset contains tweets with the hashtag #education using a Twitter API
    - There are ??? observations and ??? features, with each row being a different person.
    - After removing some observation through cleaning, it now has ??? observations.
    - You can find the Education Tweets data publicly available here under my data folder on my Github: [[Education Tweets]](INSERT LING)


## Notebook Navigation


## My Approach to Solve this Problem
My approach was to take the reviews or the text of the observations and run it through 2 different types of Sentiment Analysis and determine if it is positive, neutral, or negative and comparing it to the number of stars or 


## Technical Approach in This Project
- Feature cleaning & engineering


- Exploratory Data Analysis

- Modeling
    -  pandas, matplotlib, scikit-learn
    - quick baseline models are implemented and feature importances are calculated and visualized
    - the first set of predictions are also visualized in a scatter mapbox (plotly) that display the predicted frequency of breaks for a test set of pipe segments

## Limitations of Analysis
A limitation of this study is the Twitter API, as after about 450 tweets were gathered, it had to take about a ~13-minute break before collecting more tweets. Depending on how many tweets you wanted, the gathering could take a long time. Another limitation is that using the RoBERTa method can only take so many characters that some texts can be considered too long and will result in an error, so you would have to try and except code to skip them. A related limitation is that the RoBERTa analysis took much time to complete, with about 140,000 rows.

## Data Cleaning
(Taken from my final paper)
First, I signed up for the Twitter API, which requires a Twitter account. After I signed up, I used the Jupyter IDE to write the Python code to utilize the Twitter API and clean and analyze the datasets I used. Then I used the tweepy package to collect the tweets using the mentioned hashtags. I cleaned the dataset to prepare it for sentiment analysis. I used the exact cleaning method for each of the three datasets. I removed the punctuation from the text by using a function and applying it to each of the text columns. Then I tokenized each of the words in the text. The next step was to remove “stop words” or words that don’t add any sentiment, such as “the” and “a,” using the python package NLTK (Natural Language Toolkit), which has its list of “stop words.” After this, I converted the data frame into a CSV file to download for manual cleaning, as the tokenized words had some characters that prevented me from analyzing the data. Such characters included the brackets, coma, and single quotes (‘). Once cleaned, it was uploaded back to jupyter, and finally did, the analysis.

## Data Analysis
(Taken from my final paper)
There are many tools for sentiment analysis, but for this study, we did the VADER and the RoBERTa methods. Both can be used in python, costing the analyst nothing. 

Both methods use both qualitative and quantitative data by taking qualitative data and transforming it into quantitative data. The data that was analyzed came from two sources, primary data, and secondary data. The primary data was from analyzing tweets gathered by the Twitter API by using the hashtag #education and then again by the hashtag #healthcare. The secondary data is from reviews from the prime pantry section of Amazon, collected by Jianmo Ni from the University of California San Diego. By analyzing this data using the free VADER and RoBERTa methods, the companies will benefit tremendously by knowing what their customers feel about them and making better products and services for them. 

The first method of analysis was the RoBERTa method.  “RoBERTa is an improved version of the BERT (Bidirectional Encoder Representations from Transformers) framework, owing to several modifications such as dynamic masking, input changes without the next-sentence-prediction loss, large mini-batches, etc. The BERT framework itself is based on transformers, a deep learning model built upon several encoder layers and multi-heads self-attention mechanism.” referenced by Liu et al., 2019, Devlin et al., 2018, and Vaswani et al., 2017 as quoted by Yan, T., & Liu, F. (2022).

 The method takes a model to classify the data to recognize the relationship between words. This robust model is based on the opened source BERT (Bidirectional Encoder Representations from Transformers) model. In other words, it’s a model that understands language well and can accomplish many language tasks. An excellent example of using BERT is if you ever Google searched something. “To achieve better vector representation, the Bert model uses a transformer structure to learn the contextual information of the input words, which integrates a multi-headed self-attentive mechanism to comprehensively mine the information in different locations under different subspaces and encode the information representation to each location. The main innovation of BERT is using a masked language model and next sentence prediction to capture word and sentence representations, respectively.” (Cao et al., 2022).  Facebook Research AI agency then took BERT and improved upon it, which resulted in the RoBERTa model. That is the reason why I did RoBERTa instead as it’s the evolution of BERT. The one used in all the datasets is the twitter RoBERTa base sentiment from Hugging Face, a company known for the transformers library. This part of the analysis took the longest as the Amazon dataset; it took about two hours. Once done, I converted the list of scores and combined them with the original cleaned dataset. 

 Then I did the VADER analysis on the combined dataset with the RoBERTa results. The VADER analysis was released in 2014. Its goal was to use sentiment analysis that senses the polarity (positive and negative) and the intensity of the emotion. As mentioned in Chiny (2021, quoted in Majidpour, J., & Al-Barznji, K., 2022). “In order to obtain a reliable point estimate of the sentiment valence (intensity) of each lexicalattribute, VADER is based on a wisdom of crowds (WotC) technique.”  “Humans evaluate and approve the lexicons. They use qualitative techniques to enhance the emotion analyzer's effectiveness” as mentioned by Reshi et al. (2022) as quoted in Majidpour, J., & Al-Barznji, K. (2022). I separated the dictionary into separate columns, which took much less time as it only takes each word and scores them as negative, neutral, and positive, with no relationship between them. The Amazon dataset was in a JSON file, so I had to convert the text into a string. I did the same analysis but did not clean the original dataset to compare the two.

 After the analysis, I took the education and healthcare analysis datasets and then grouped them into 11 different groups; 0-999, 1000-1999,…,9000-9999, and 10,000+. I then took the average of the sentiment scores to get it ready to be able to see graphs and plots a bit better by taking out unnecessary columns that were unnamed. 

## Key Takeaways


## Business Recommendation


## Next Step


## References