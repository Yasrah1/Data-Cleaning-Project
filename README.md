# Data-Cleaning-Project
📌 Overview

This is my first data cleaning project. I worked on cleaning an Amazon sales dataset to make it beginner-friendly, consistent, and ready for analysis.

🛠️ Steps I Took

• Removed duplicates → kept only unique records.
• Dealt with NULL values → dropped rows where data could not be imputed.
• Standardised dates → ensured all were in a consistent format.
• Cleaned City/County (State) pairs → corrected formatting and verified valid US locations.
• Checked quantities → removed unrealistic values (such as 500, 999, 1000).
• Handled Sales outliers → removed extreme, unrealistic figures.
• Verified Discounts → ensured all values were between 0% and 80%.
• Confirmed unique IDs → no duplicate IDs remained.
• Left negative profit rows → kept these as they can occur in real-world data (e.g. heavy discounts or loss-making sales).

⚠️ Notes

• Dataset is now clean and consistent.
• Outliers that were reasonable (such as negative profit from clearance sales) were deliberately kept.
• This project focused on practising basic cleaning skills in SQL and Excel/Pandas.

📂 Files

• Cleaned DCP.csv → final cleaned dataset

🚀 Next Steps

➼ Use this cleaned dataset for beginner-friendly analysis (e.g. sales trends, profit by category, etc.).
➼ Continue improving cleaning skills with more complex datasets.
