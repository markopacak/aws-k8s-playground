import pandas as pd
from rnn import RNN
from utils import ALL_LETTERS, N_HIDDEN


def train():
    pass


if __name__ == "__main__":
    df = pd.read_csv("../data/characters.csv")
    data = {
        "sith": list(df[df["sith"] == 1]["name"]),
        "non-sith": list(df[df["sith"] == 0]["name"]),
    }
    rnn = RNN(len(ALL_LETTERS), N_HIDDEN, len(data.keys()))
