Text Predict-R
========================================================
author: Charles Bryan
date: 6/19/2020
height: 1075
width: 2000
font-family: 'Times New Roman'


Introduction
========================================================

Our application <span style="font-size:42px; color:red">Text Predict-R</span> is designed to predict the subsequent word given some input text. Similar functionality is currently utilized by applications for phone messaging as well as document writing such as Microsoft Word. What sets <span style="font-size:42px; color:red">Text Predict-R</span> apart from the existing methods is our approach uses a modified Katz's back-off model trained on n-grams derived from a large varied input corpus provided by [Coursera](https://www.coursera.org/learn/data-science-project/supplement/idhGA/syllabus).

<br>

The provided dataset for this project consisted of almost 600 Mb of text data taken from blogs, news, and twitter. Further statistics on this data can be seen in the table below:

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> File </th>
   <th style="text-align:right;background-color: #e6e6e6 !important;font-size: 34px;"> Number_of_Lines </th>
   <th style="text-align:right;background-color: #e6e6e6 !important;font-size: 34px;"> Average_Line_Length </th>
   <th style="text-align:right;background-color: #e6e6e6 !important;font-size: 34px;"> Longest_Line_Length </th>
   <th style="text-align:right;background-color: #e6e6e6 !important;font-size: 34px;"> File_Size_in_Mb </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 30em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> en_US.blogs.txt </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 899288 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 229.98695 </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 40833 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 210.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 30em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> en_US.news.txt </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 77259 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 202.42830 </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 5760 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 205.81 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 30em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> en_US.twitter.txt </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 2360148 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 68.68045 </td>
   <td style="text-align:right;width: 30em; background-color: SkyBlue !important;border-right:1px solid;"> 140 </td>
   <td style="text-align:right;width: 30em; background-color: #C3C3B9 !important;border-right:1px solid;"> 167.11 </td>
  </tr>
</tbody>
</table>


Cleaning the Corpus
========================================================

Before we can work with the n-gram counts we first need to clean all of our training data. 

- We split the text data into 70% training and 30% testing. 
- Then we perform an excessive amount of cleaning (as shown below) for our training set. 

<ol style="font-size:30px; LINE-HEIGHT:30px; color:#737373">
  <li>Split text into sentences</li>
  <li>Lower case all text <span style="color:blue">Ex. CaMeLs -> camels</span></li>
  <li>Replace Unicode issues</li>
  <li>Replace common twitter notation <span style="color:blue">Ex. RT -> retweet</span></li>
  <li>Replace contractions with their elongated form <span style="color:blue">Ex. won't -> will not</span></li>
  <li>Replace character elongation <span style="color:blue">Ex. whyyyyyyy -> why</span></li>
  <li>Replace ordinal numbers <span style="color:blue">Ex. 1st -> first</span></li>
  <li>Replace the numbers 0 through 10 with word equivalent <span style="color:blue">Ex. 0 -> zero</span></li>
  <li>Remove possessive 's <span style="color:blue">Ex. child's -> child</span></li>
  <li>Fix specific common issues</li>
  <li>Remove urls</li>
  <li>Remove remaining punctuation and numbers</li>
  <li>Remove any remaining non ASCII characters</li>
  <li>Remove common ambiguous characters <span style="color:blue">Ex. letters like d or m</span></li>
  <li>Add a token to the start of each sentence</li>
  <li>Remove profanity</li>
</ol>

***
<p style="font-size:30px; LINE-HEIGHT:2px">
<b>Raw text data before and after the application's lengthy cleaning process:</b>
</p>
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> Lines </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> Raw_Text </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> Cleaned_Text </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 5em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Line 1 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> Don't break people's hearts they only have one, Break their bones instead they have 206 of those. </td>
   <td style="text-align:left;width: 30em; background-color: #1AD167 !important;"> &lt;start&gt; do not break people hearts they only have one break their bones instead they have  &lt;del&gt;  of those </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Line 2 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> Dont have a whirpool? Try this: Recovery Shower, Alternate 2min Hot w/ 2min Cold for 4-5 Full rounds, end w/ 2min cold. Great 4 recovery! </td>
   <td style="text-align:left;width: 30em; background-color: #1AD167 !important;"> &lt;start&gt;  do not  have a whirpool </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Line 3 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;">  </td>
   <td style="text-align:left;width: 30em; background-color: #1AD167 !important;"> &lt;start&gt; try this recovery shower alternate  &lt;del&gt;  hot  &lt;del&gt;  cold for  &lt;del&gt;  full rounds end  &lt;del&gt;  cold </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Line 4 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;">  </td>
   <td style="text-align:left;width: 30em; background-color: #1AD167 !important;"> &lt;start&gt; great  four  recovery </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Line 5 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> New Year starting of with with the #packers and #mubb doesn't get much better </td>
   <td style="text-align:left;width: 30em; background-color: #1AD167 !important;"> &lt;start&gt; new year starting of with with the  &lt;del&gt;  and  &lt;del&gt;  does not get much better </td>
  </tr>
</tbody>
</table>


N-Gram Dataframes
========================================================

- After cleaning all of our text, we convert our text into dataframes of n-grams of size 1 through 5. 
- We then reduce our n-grams by removing any n-grams that occur only once. This reduces our total unique n-grams by more than 50%!  
- Next we split the data based on the length of the n-gram and calculate some basic statistics on these dataframes.

<br>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> Basic_Stats </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> one_gram </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> two_gram </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> three_gram </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> four_gram </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;font-size: 34px;"> five_gram </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Unique Tokens </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 152960 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 1908213 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 3134405 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 2363704 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 1265296 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Total Tokens </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 47472152 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 41860275 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 25857675 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 12165203 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 4919565 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Top 5 Token Coverage </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 14.44% </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 2.9% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 0.99% </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 0.49% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 0.36% </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Unique Tokens for 50% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 90 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 8013 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 95967 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 209482 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 206058 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Unique Tokens for 75% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 923 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 89866 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 671092 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 911186 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 650351 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Unique Tokens for 90% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 5216 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 491733 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 1841522 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 1755444 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 1019318 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 25em; font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Unique Tokens for 99% </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 48131 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 1698912 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 3005117 </td>
   <td style="text-align:left;width: 30em; background-color: #C3C3B9 !important;"> 2302878 </td>
   <td style="text-align:left;width: 30em; background-color: SkyBlue !important;"> 1240699 </td>
  </tr>
</tbody>
</table>

Algorithm Implementation
========================================================

The main algorithm of our applicatin is assigning a score to each token based on the preceding words. We only saved n-grams of length 1 through 5, so we only use up to the four preceding words to make a prediction. For an input text of 4 words (or more) the following steps are taken:

<ol style="font-size:28px; LINE-HEIGHT:28px; color:#737373">
  <li>Every potential token is assigned a score (score4) that is simply the probability of the token appearing on the condition of the preceding <b>4</b> words first appearing. <span style="color:blue">This conditional probability will sum to 1 across all tokens.</span></li>
  <li>Every potential token is assigned a score (score3) that is simply the probability of the token appearing on the condition of the preceding <b>3</b> words first appearing.</li>
  <li>Every potential token is assigned a score (score2) that is simply the probability of the token appearing on the condition of the preceding <b>2</b> words first appearing.</li>
  <li>Every potential token is assigned a score (score1) that is simply the probability of the token appearing on the condition of the preceding <b>1</b> word first appearing.</li>
  <li>Every token is assigned a score (score0) that is simply the probability of the token appearing not based on any preceding text.</li>
  <li>For each token, all of its scores are summed together.</li>
  <li>Each token's summed score is multiplied by log(1/score0). <span style="color:blue">This step discourages extremely frequent words such as <i>the</i> or <i>a</i> and instead results in meaningful results.</span></li>
  <li>The top 5 results are then kept.</li>
</ol>

A crucial feature of this application's implementation is that these steps outlined above are performed for all combinations of input text (as seen by the training corpus) prior to deployment, and the results (top 5 tokens and scores) are stored in a lookup table.

At the time a user types in words, the following steps are instantly performed:

<ol style="font-size:28px; LINE-HEIGHT:28px; color:#737373">
        <li>The user's text is cleaned using the same algorithm as on our training corpus.</li>
        <li>The preceding <b>4</b> words are checked against our lookup table. If an exact match is found then the resulting row is used.</li>
        <li> If an exact match is not found then the preceding <b>3</b> words are checked against our lookup table. If an exact match is found then the resulting row is used. </li>
        <li> If an exact match is not found then the preceding <b>2</b> words are checked against our lookup table. If an exact match is found then the resulting row is used. </li>
        <li> If an exact match is not found then the preceding <b>1</b> word are checked against our lookup table. If an exact match is found then the resulting row is used. </li>
        <li>If an exact match is still not found, then we simply have to go with the results of the most common 5 tokens.</li>
</ol>


Application Performance
========================================================

Earlier we separated our large corpus into 70% training data and 30% testing data. We evaluate our application against our training and testing sets separately by randomly selecting tens of thousands of lines from either set and trying to predict a random word in the line based on the preceding words. 

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;background-color: #e6e6e6 !important;"> Application.Performance </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;"> In.Sample_Data </th>
   <th style="text-align:left;background-color: #e6e6e6 !important;"> Out.of.Sample.Data </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Top_1_Accuracy </td>
   <td style="text-align:left;background-color: SkyBlue !important;border-right:1px solid;"> 12.46% </td>
   <td style="text-align:left;background-color: #1AD167 !important;border-right:1px solid;"> 11.96% </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Top_3_Accuracy </td>
   <td style="text-align:left;background-color: SkyBlue !important;border-right:1px solid;"> 20.92% </td>
   <td style="text-align:left;background-color: #1AD167 !important;border-right:1px solid;"> 19.88% </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Top_5_Accuracy </td>
   <td style="text-align:left;background-color: SkyBlue !important;border-right:1px solid;"> 24.91% </td>
   <td style="text-align:left;background-color: #1AD167 !important;border-right:1px solid;"> 24.17% </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Prediction_Speed
 (per prediction) </td>
   <td style="text-align:left;background-color: SkyBlue !important;border-right:1px solid;"> 20.08 msec </td>
   <td style="text-align:left;background-color: #1AD167 !important;border-right:1px solid;"> 18.21 msec </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;background-color: #C3C3B9 !important;border-right:1px solid;"> Memory_Usage_in_Mb </td>
   <td style="text-align:left;background-color: SkyBlue !important;border-right:1px solid;"> 594.11 </td>
   <td style="text-align:left;background-color: #1AD167 !important;border-right:1px solid;"> 594.11 </td>
  </tr>
</tbody>
</table>

Our performance in our training and testing sets are very similar. This is likely due to the extremely large size of our data used. Our accuracies are fairly good, but our most important feature is our almost instantaneous prediction time. This could even be shortened further if needed by reducing our lengthy text cleaning process.

<span style="font-size:26px"> Full Application:  [https://charlesbryan.shinyapps.io/Text_PredictR](https://charlesbryan.shinyapps.io/Text_PredictR)</span>

<span style="font-size:26px"> Full Details:  [https://rpubs.com/CharlesBryan/Text_Prediction](https://rpubs.com/CharlesBryan/Text_Prediction)</span>
***
<span style="font-size:28px; LINE-HEIGHT:24px">Below is our application in use. The user has entered <i><span style="color:red">Getting an A in this course would make me the</span></i> into the app. The top five results are shown in order directly above the text field. A more descriptive display of the results is shown in a table to the right.</span>
![alt text](Application_use.png)
