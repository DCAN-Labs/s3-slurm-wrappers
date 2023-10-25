import pandas as pd
import argparse
from scipy.stats import pearsonr

def main():
    parser = argparse.ArgumentParser(description="intrasubject_similarity")
    parser.add_argument("half1csv", help="csv file resulting from ILI computation of ROIs from the first half of a subject's dtseries")
    parser.add_argument("half2csv", help="csv file resulting from ILI computation of ROIs from the second half of a subject's dtseries")
    args = parser.parse_args()

    df1 = pd.read_csv(args.half1csv)
    df1 = df1.drop(df1.columns[0], axis=1)
    df2 = pd.read_csv(args.half2csv)
    df2 = df2.drop(df2.columns[0], axis=1)

    merged_df = pd.merge(df1, df2, on="file")
    merged_df.rename(columns={"file": "roi", "ILI_x": "ILI_half1", "ILI_y": "ILI_half2"}, inplace=True)\

    # Extract ILI values for the first and second halves
    ili_values_half1 = merged_df['ILI_half1']
    ili_values_half2 = merged_df['ILI_half2']

    # Compute the Pearson correlation coefficient
    correlation, _ = pearsonr(ili_values_half1, ili_values_half2)
    print(correlation)

if __name__ == "__main__":
    main()